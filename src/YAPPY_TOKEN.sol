// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract YAPPY_TOKEN is ERC20("YAPPY", "YAP") {
    
    /*//////////////////////////////////////////////////////////////
                              constructor
    //////////////////////////////////////////////////////////////*/
    
    constructor(uint initialSupply) {
        _mint(msg.sender, initialSupply);
    }


}