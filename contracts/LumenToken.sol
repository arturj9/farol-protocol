// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

interface ILumenToken is IERC20 {
    function mint(address to, uint256 amount) external;
}

contract LumenToken is ERC20, AccessControl, ILumenToken {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor(address defaultAdmin) ERC20("Lumen", "LUM") {
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _mint(defaultAdmin, 10000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public override onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }
}