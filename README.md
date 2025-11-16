#  Voting Smart Contract (Solidity)

A secure, transparent, and gas-efficient blockchain voting system written in **Solidity 0.8.x**.  
The contract supports multiple candidates, prevents double voting, and lets the owner end voting and reveal the winner.

---

##  Features

-  **Owner-controlled voting lifecycle**
-  **One-user-one-vote enforcement**
-  **Double-voting protection**
-  **Dynamic candidate list**
-  **Tracks per-candidate & total votes**
-  **Winner available once voting ends**
-  **Gas-efficient custom errors**
-  **Events for transparency**

---

##  Contract Overview

### **Candidate Structure**
```solidity
struct Candidate {
    string name;

State Variables

 owner — Deployer, controls ending of voting

 votingEnded — Boolean flag

 totalVotes — Number of total votes

 candidates[] — Dynamic array of candidates

 hasVoted[address] — Tracks if an address voted

Events

 Event	Description
 VoteCasted(address voter, uint256 candidateIndex)	Emitted when a vote is submitted
 VotingEnded()	Emitted when the owner closes voting
