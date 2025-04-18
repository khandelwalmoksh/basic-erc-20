// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {Test} from "forge-std/Test.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {MintBasicNft} from "../script/Interactions.s.sol";

contract InteractionsTest is Test {
    BasicNft basicNft;

    address USER = makeAddr("user");
    uint256 tokenId = 0;
    string PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        basicNft = new BasicNft();
    }

    function testMintNftOnContract() public {
        uint256 initialSupply = basicNft.totalSupply();

        vm.prank(USER);
        basicNft.mintNft(PUG);

        uint256 finalSupply = basicNft.totalSupply();
        assertEq(finalSupply, initialSupply + 1, "NFT minting failed");
    }

    function testMintUsingScript() public {
        address user = makeAddr("user");
        address mostRecentlyDeployed = address(basicNft);

        vm.startPrank(user);
        basicNft.mintNft(PUG); // Directly minting instead of calling script
        vm.stopPrank();

        assertEq(basicNft.balanceOf(user), 1, "Minting via script failed");
    }
}
