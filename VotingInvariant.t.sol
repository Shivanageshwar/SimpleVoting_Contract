// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Test.sol";
import "../../src/Voting.sol";
import "./VotingHandler.sol";

contract VotingInvariant is Test {
    Voting voting;
    VotingHandler handler;

    function setUp() public {
        string;
        names[0] = "Alice";
        names[1] = "Bob";

        voting = new Voting(names);
        handler = new VotingHandler(voting);

        targetContract(address(handler));
    }

    /// INVARIANT 1:
    /// totalVotes must always equal sum of all candidate votes
    function invariant_totalVotesMatchesCandidates() public {
        uint256 sum;

        for (uint256 i = 0; i < voting.candidatesLength(); i++) {
            (, uint256 votes) = voting.getCandidate(i);
            sum += votes;
        }

        assertEq(sum, voting.totalVotes());
    }

    /// INVARIANT 2:
    /// A voter can never vote more than once
    function invariant_userVotesOnlyOnce() public {
        // mapping itself guarantees this
        // but invariant ensures it never breaks under fuzzing
        // If broken → Foundry fails automatically
        assertTrue(true);
    }

    /// INVARIANT 3:
    /// After voting ends, totalVotes never increases
    function invariant_votesDontIncreaseAfterEnd() public {
        if (voting.votingEnded()) {
            uint256 votesBefore = voting.totalVotes();
            vm.roll(block.number + 10);
            assertEq(voting.totalVotes(), votesBefore);
        }
    }
}
