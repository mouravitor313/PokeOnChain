// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Pokedex} from "src/Pokedex.sol";

contract Battles is Pokedex {
    function selectPokemon(
        uint256 selected
    ) internal view returns (uint256 level, uint256 strength) {
        require(
            selected < pokemons[msg.sender].length,
            "Selected pokemon doesn't exist"
        );
        return (
            pokemons[msg.sender][selected].level,
            pokemons[msg.sender][selected].strength
        );
    }
}
