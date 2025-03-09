// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("OurToken", "OT") {
        //constructor from ERC20.sol
        _mint(msg.sender, initialSupply); // mint from ERC20.sol
    }
}
