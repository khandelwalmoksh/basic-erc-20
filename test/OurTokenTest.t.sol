// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
import {OurToken} from "../src/OurToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        //Owner should be msg.sender
        vm.prank(address(msg.sender));
        ourToken.transfer(bob, STARTING_BALANCE); // bob = STARTING_BALANCE
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowancesWork() public {
        uint256 initialAllowance = 1000;

        //Bob approves Alice to spend token on his behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance); // alice = initialAllowance(she can spend upto 1000)

        //creates some tranfer amount
        uint256 transferAmount = 500;

        //pretending to be Alice here
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount); //transfer from bob to alice

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testTransfer() public {
        uint256 amount = 1000;
        address receiver = address(0x1);

        vm.prank(msg.sender);
        ourToken.transfer(receiver, amount);
        assertEq(ourToken.balanceOf(receiver), amount);
    }

    function testBalanceAfterTransfer() public {
        uint256 amount = 1000;
        address receiver = address(0x1);
        uint256 initialbalance = ourToken.balanceOf(msg.sender);

        vm.prank(msg.sender);
        ourToken.transfer(receiver, amount);
        assertEq(ourToken.balanceOf(msg.sender), initialbalance - amount);
    }

    function testTransferFrom() public {
        uint256 amount = 1000;
        address receiver = address(0x1);

        vm.prank(msg.sender);
        ourToken.approve(msg.sender, amount);
        ourToken.transferFrom(msg.sender, receiver, amount);
        assertEq(ourToken.balanceOf(receiver), amount);
    }
}
