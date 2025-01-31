# NFTix 🎟️ – A Decentralized Event Ticketing Smart Contract  

## Overview  
NFTix is a Clarity-based smart contract designed to revolutionize event ticketing using blockchain technology. It enables event organizers to issue tokenized tickets as NFTs, allowing users to buy, own, and transfer tickets in a secure, transparent, and decentralized manner.  

## Features  
✅ **Tokenized Tickets** – Each ticket is minted as a unique NFT, ensuring authenticity.  
✅ **Decentralized Ownership** – Users can securely own and transfer tickets without intermediaries.  
✅ **Escrowed Payments** – Payments are directly transferred to the event organizer upon purchase.  
✅ **Limited Supply** – Enforces a maximum number of tickets to prevent over-issuance.  
✅ **Resale & Transfer** – Allows users to resell or transfer their tickets securely on-chain.  
✅ **Read-Only Queries** – Users can check ticket availability, ownership, and purchase history.  

---

## Smart Contract Functions  

### 🎟️ Ticket Management  
- **`(issue-tickets (amount uint))`**  
  - Allows the contract owner to issue new tickets (NFTs).  
  - ✅ **Only callable by the event organizer.**  
  - ✅ Ensures total tickets do not exceed the maximum limit.  

- **`(buy-ticket)`**  
  - Allows users to buy tickets by sending STX tokens.  
  - ✅ Mints a unique NFT as proof of purchase.  
  - ✅ Ensures sufficient balance and ticket availability.  
  - ✅ Transfers payment to the event organizer.  

- **`(transfer-ticket (to principal) (ticket-id uint))`**  
  - Enables users to transfer a ticket to another user.  
  - ✅ Ensures the sender owns the ticket before transferring.  
  - ✅ Updates ownership records accordingly.  

---

### 🔍 Query Functions  
- **`(get-total-tickets)`** – Returns the total number of tickets issued.  
- **`(get-tickets-sold)`** – Returns the number of tickets sold.  
- **`(get-tickets-owned (owner principal))`** – Returns the number of tickets a user owns.  
- **`(get-ticket-owner (ticket-id uint))`** – Returns the owner of a specific ticket.  

---

## Error Handling 🚨  
NFTix ensures secure transactions with the following error codes:  
- `100` – Not the contract owner (only the organizer can issue tickets).  
- `101` – No tickets available (sold out).  
- `102` – Insufficient funds to buy a ticket.  
- `103` – Invalid ticket ownership during transfers.  

---

## How It Works ⚙️  
1️⃣ **The event organizer issues tickets** using `issue-tickets`.  
2️⃣ **Users purchase tickets** via `buy-ticket`, receiving an NFT.  
3️⃣ **Tickets can be transferred** using `transfer-ticket`.  
4️⃣ **Ownership & availability** can be verified using read-only functions.  

---

## Future Enhancements 🚀  
🔹 Dynamic pricing based on demand.  
🔹 Ticket resale marketplace with royalty fees.  
🔹 Integration with decentralized identity for fraud prevention.  

---

## License 📜  
NFTix is an open-source project licensed under the MIT License. Feel free to contribute, modify, and use it for decentralized ticketing solutions.