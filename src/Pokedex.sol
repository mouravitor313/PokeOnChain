// SPDX-License-Identifier: MIT
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
        using Math for uint256;
        uint256 diff = _max - _min;
        bytes32 hash = keccak256(abi.encodePacked(blockhash(block.number - 1), msg.sender));
        uint256 number = uint256(hash);
        uint256 remainder = number.mod(diff);
        uint256 result = remainder + _min;
        return result;
    }

    function generateRarity() internal view returns (rarityType) {
        uint256 randomNumber = random(0, 100);
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
            level: random(2,6),
            hp: random(10,21),
            attack: random(0,5),
            defense: random(0,5)
        });

        uint256 newTokenId = tokenCounter;
        

    }

}