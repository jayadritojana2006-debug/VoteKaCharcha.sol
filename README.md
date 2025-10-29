# 🗳️ Vote Ka Charcha  

> A simple **decentralized voting** smart contract built with **Solidity**, designed to make transparent and fair on-chain elections possible.  
> Perfect for learning blockchain fundamentals and experimenting with smart contracts on Ethereum testnets.

---
<img width="1366" height="768" alt="Screenshot (2)" src="https://github.com/user-attachments/assets/1b0e78f3-6196-4790-b7c8-75830448d687" />

## 🚀 Project Description  

**Vote Ka Charcha** is a beginner-friendly blockchain project where people can **vote securely and transparently** without relying on a central authority.  
It demonstrates how voting systems can be made **trustless, verifiable, and decentralized** using Ethereum smart contracts.  

The project can be easily deployed, tested, or extended for educational or real-world use cases such as:
- Club or community elections  
- DAO-style governance  
- Polling systems for decentralized platforms  

---

## 💡 What It Does  

- The **owner** (contract deployer) adds candidates.  
- Once the voting phase starts, **each user can vote only once**.  
- Votes are **recorded on-chain**, ensuring full transparency.  
- After voting ends, **anyone can check who won** based on the vote count.  

---

## ✨ Features  

✅ Owner can register candidates  
✅ Secure one-vote-per-user logic  
✅ Transparent on-chain vote tracking  
✅ Start and end voting phases  
✅ Publicly viewable results  
✅ Beginner-friendly and gas-efficient code  

---

## 🚀 Deployed Smart Contract

**Network:** Celo Sepolia Testnet  
**Contract Address:** [`0xF14d4a63C8D28ff6C4d26c7005014Ef2A179b7BF`](https://celo-sepolia.blockscout.com/tx/0x92f66796ab57e334dea4001fd3cd7acc456a883297eaa21400917bc0c6810325)

## 🧱 Smart Contract Code  

```solidity
// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.19;

/**
 * @title Vote Ka Charcha 🗳️
 * @dev A simple decentralized voting smart contract for beginners
 * @author —
 */

contract VoteKaCharcha {

    // --- STRUCTS ---
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    // --- STATE VARIABLES ---
    address public owner;
    uint public candidatesCount;
    bool public votingActive;

    mapping(uint => Candidate) public candidates; // candidateId => Candidate
    mapping(address => bool) public hasVoted;     // voter address => true/false

    // --- EVENTS ---
    event CandidateAdded(uint candidateId, string name);
    event VoteCasted(address voter, uint candidateId);
    event VotingStarted();
    event VotingEnded();

    // --- MODIFIERS ---
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    modifier whenVotingActive() {
        require(votingActive, "Voting is not active");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // --- FUNCTIONS ---

    /// @notice Add a new candidate (only owner)
    function addCandidate(string memory _name) public onlyOwner {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        emit CandidateAdded(candidatesCount, _name);
    }

    /// @notice Start the voting phase
    function startVoting() public onlyOwner {
        require(!votingActive, "Voting already active");
        votingActive = true;
        emit VotingStarted();
    }

    /// @notice End the voting phase
    function endVoting() public onlyOwner {
        require(votingActive, "Voting is not active");
        votingActive = false;
        emit VotingEnded();
    }

    /// @notice Cast your vote (once per address)
    function vote(uint _candidateId) public whenVotingActive {
        require(!hasVoted[msg.sender], "You already voted!");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");

        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;

        emit VoteCasted(msg.sender, _candidateId);
    }

    /// @notice Get total votes for a candidate
    function getVotes(uint _candidateId) public view returns (uint) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        return candidates[_candidateId].voteCount;
    }

    /// @notice Get the winner (after voting ends)
    function getWinner() public view returns (string memory winnerName, uint winnerVotes) {
        require(!votingActive, "Wait until voting ends");
        uint maxVotes = 0;
        uint winnerId = 0;

        for (uint i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerId = i;
            }
        }

        winnerName = candidates[winnerId].name;
        winnerVotes = candidates[winnerId].voteCount;
    }
}
