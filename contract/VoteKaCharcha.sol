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

