// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Pokedex is ERC721 {

    enum typeOf {
        water,
        fire,
        grass
    }

    enum rarityType {
        normal,
        rare,
        shine
    }

    struct Pokemon {
        string name;
        typeOf tipo;
        rarityType rarity;
        uint256 level;
        uint256 hp;
        uint256 attack;
        uint256 defense;
    }

    mapping(uint256 => Pokemon) public pokemons;
    uint256 public tokenCounter;
    address public pokeCoin;
    uint256 public price;

    event PokemonCreated(uint256 tokenId, Pokemon pokemon);

    constructor() ERC721("Pokedex", "DEX") {
        pokeCoin = ...; // endereço da pokecoin
        price = 1;
        tokenCounter = 0;
    }

    function random(uint256 _min, uint256 _max) internal view returns(uint256) {
        return uint256(keccak256(abi.encodedPacked(blockhash(block.number - 1), msg.sender))) % _max;
    }

    function generateRarity() internal view returns (rarityType) {
        uint256 randomNumber = random(100);
        uint256 normalLimit = 70;
        uint256 rareLimit = 90;

        if (randomNumber < rareLimit) {
            return rarityType.normal;
        } else if (randomNumber < rareLimit) {
            return rarityType.rare;
        } else {
            return rarityType.shine;
        }
    }

    function createPokemon(
        string memory _name,
        typeOf _type,
    ) public {
        IERC20 token = IERC20(pokeCoin);
        require(token.balanceOf(msg.sender) >= price, "Insufficient balance!");
        token.transferFrom(msg.sender, address(this), price);
        rarityType _rarity = generateRarity();

        Pokemon memory newPokemon = Pokemon({
            name: _name,
            tipo: _type,
            rarity: _rarity,
            level: random(4)
            hp: random
        })

    }

}