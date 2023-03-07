// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/presets/ERC20PresetFixedSupply.sol)
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

contract TestToken is ERC20PresetFixedSupply {
    constructor()
        ERC20PresetFixedSupply("TestToken", "TT", 100000000 ether, msg.sender)
    {}
}
