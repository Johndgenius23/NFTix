;; Event Ticketing Smart Contract in Clarity

;; Define constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant TICKET_PRICE u100) ;; Price per ticket in microSTX
(define-constant MAX_TICKETS u1000) ;; Maximum number of tickets available

;; Data structures
(define-data-var total-tickets uint u0)
(define-data-var tickets-sold uint u0)
(define-map tickets-owned principal uint) ;; Maps principal to number of tickets owned

;; Define NFT trait for tickets
(define-non-fungible-token ticket-nft uint)

;; Errors
(define-constant ERR_NOT_OWNER (err u100))
(define-constant ERR_SOLD_OUT (err u101))
(define-constant ERR_INSUFFICIENT_FUNDS (err u102))
(define-constant ERR_INVALID_TICKET (err u103))
(define-constant ERR_TRANSFER_FAILED (err u104))
(define-constant ERR_MINT_FAILED (err u105))

;; Helper function to check if the caller is the contract owner
(define-private (is-owner)
    (is-eq tx-sender CONTRACT_OWNER)
)

;; Issue new tickets (only contract owner can do this)
(define-public (issue-tickets (amount uint))
    (begin
        (asserts! (is-owner) ERR_NOT_OWNER)
        (asserts! (<= (+ (var-get total-tickets) amount) MAX_TICKETS) ERR_SOLD_OUT)
        (var-set total-tickets (+ (var-get total-tickets) amount))
        (ok true)
    )
)

;; Buy tickets
(define-public (buy-ticket)
    (let 
        ((current-tickets-sold (var-get tickets-sold)))
        ;; Check if tickets are available
        (asserts! (< current-tickets-sold (var-get total-tickets)) ERR_SOLD_OUT)
        ;; Check if the sender has enough funds
        (asserts! (>= (stx-get-balance tx-sender) TICKET_PRICE) ERR_INSUFFICIENT_FUNDS)
        ;; Transfer STX from buyer to contract owner
        (match (stx-transfer? TICKET_PRICE tx-sender CONTRACT_OWNER)
            success
                (match (nft-mint? ticket-nft current-tickets-sold tx-sender)
                    mint-success
                        (begin
                            ;; Update tickets sold
                            (var-set tickets-sold (+ current-tickets-sold u1))
                            ;; Update tickets owned by the buyer
                            (map-set tickets-owned 
                                tx-sender 
                                (+ (default-to u0 (map-get? tickets-owned tx-sender)) u1)
                            )
                            (ok true)
                        )
                    mint-error ERR_MINT_FAILED
                )
            error ERR_TRANSFER_FAILED
        )
    )
)

;; Transfer ticket ownership
(define-public (transfer-ticket (to principal) (ticket-id uint))
    (let 
        ((current-owner tx-sender))
        ;; Check if the sender owns the ticket
        (asserts! (is-eq (nft-get-owner? ticket-nft ticket-id) (some current-owner)) ERR_INVALID_TICKET)
        ;; Transfer the ticket
        (match (nft-transfer? ticket-nft ticket-id current-owner to)
            success
                (begin
                    ;; Update tickets owned by sender and receiver
                    (map-set tickets-owned 
                        current-owner 
                        (- (default-to u0 (map-get? tickets-owned current-owner)) u1)
                    )
                    (map-set tickets-owned 
                        to 
                        (+ (default-to u0 (map-get? tickets-owned to)) u1)
                    )
                    (ok true)
                )
            error ERR_TRANSFER_FAILED
        )
    )
)

;; Get total tickets available
(define-read-only (get-total-tickets)
    (ok (var-get total-tickets))
)

;; Get tickets sold
(define-read-only (get-tickets-sold)
    (ok (var-get tickets-sold))
)

;; Get tickets owned by a specific principal
(define-read-only (get-tickets-owned (owner principal))
    (ok (default-to u0 (map-get? tickets-owned owner)))
)

;; Get ticket owner
(define-read-only (get-ticket-owner (ticket-id uint))
    (ok (nft-get-owner? ticket-nft ticket-id))
)