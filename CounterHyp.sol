// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Counter {
    uint256 public count; // Variable publique pour suivre le compteur

    // Incrémente le compteur, jusqu'à un maximum de 51
    function increment() public {
        require(count < 51, "Compteur a atteint la limite de 51");
        count++;
    }

    // Réinitialise le compteur à 0
    function reset() public {
        count = 0;
    }
}