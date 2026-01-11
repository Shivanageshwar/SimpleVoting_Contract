// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Test.sol";
import "../src/Voting.sol";

contract VotingTest is Test {
    Voting voting;

    address owner = address(1);
    address alice = address(2);
    address bob = address(3);

    function setUp() public {
        string;
        names[0] = "Alice";
        names[1] = "Bob";
        names[2] = "Charlie";

        vm.prank(owner);
        voting = new Voting(names);
    }

    function testVoteSuccessfully() public {
        vm.prank(alice);
        voting.vote(0);

        (, uint256 votes) = voting.getCandidate(0);
        assertEq(votes, 1);
        assertEq(voting.totalVotes(), 1);
    }

    function testCannotVoteTwice() public {
        vm.startPrank(alice);
        voting.vote(0);

        vm.expectRevert(Voting.AlreadyVoted.selector);
        voting.vote(1);
        vm.stopPrank();
    }

    function testInvalidCandidateReverts() public {
        vm.prank(alice);
        vm.expectRevert(Voting.InvalidCandidate.selector);
        voting.vote(99);
    }

    function testOnlyOwnerCanEndVoting() public {
        vm.prank(alice);
        vm.expectRevert(Voting.NotOwner.selector);
        voting.endVoting();
    }

    function testVotingClosedAfterEnd() public {
        vm.prank(owner);
        voting.endVoting();

        vm.prank(alice);
        vm.expectRevert(Voting.VotingClosed.selector);
        voting.vote(0);
    }

    function testWinnerAfterVotingEnds() public {
        vm.prank(alice);
        voting.vote(1);

        vm.prank(bob);
        voting.vote(1);

        vm.prank(owner);
        voting.endVoting();

        (string memory name, uint256 votes) = voting.getWinner();
        assertEq(name, "Bob");
        assertEq(votes, 2);
    }

    function testGetWinnerBeforeEndReverts() public {
        vm.expectRevert(Voting.VotingNotEnded.selector);
        voting.getWinner();
    }
}
