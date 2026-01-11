// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Voting {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    address public owner;
    bool public votingEnded;
    uint256 public totalVotes;

    mapping(address => bool) public hasVoted;
    Candidate[] public candidates;

    event VoteCasted(address indexed voter, uint256 indexed candidateIndex);
    event VotingEnded();

    error NotOwner();
    error AlreadyVoted();
    error VotingClosed();
    error VotingNotEnded();
    error InvalidCandidate();

    constructor(string[] memory candidateNames) {
        owner = msg.sender;
        for (uint256 i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate(candidateNames[i], 0));
        }
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    modifier votingOpen() {
        if (votingEnded) revert VotingClosed();
        _;
    }

    // Cast a vote
    function vote(uint256 candidateIndex) external votingOpen {
        if (hasVoted[msg.sender]) revert AlreadyVoted();
        if (candidateIndex >= candidates.length) revert InvalidCandidate();

        hasVoted[msg.sender] = true;
        candidates[candidateIndex].voteCount++;
        totalVotes++;

        emit VoteCasted(msg.sender, candidateIndex);
    }

    // End the voting
    function endVoting() external onlyOwner {
        votingEnded = true;
        emit VotingEnded();
    }

    // Return the name of the winning candidate
    function getWinner() external view returns (string memory winnerName, uint256 winnerVotes) {
        if (!votingEnded) revert VotingNotEnded();

        uint256 highestVotes = 0;
        uint256 winningIndex = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > highestVotes) {
                highestVotes = candidates[i].voteCount;
                winningIndex = i;
            }
        }

        return (candidates[winningIndex].name, highestVotes);
    }
function getCandidate(uint256 index) external view returns (string memory, uint256) {
    return (candidates[index].name, candidates[index].voteCount);
}

function candidatesLength() external view returns (uint256) {
    return candidates.length;
}

}

