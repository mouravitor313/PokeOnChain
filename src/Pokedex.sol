// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PokemonNFT is ERC721 {

    // Criação da estrutura Pokémon
    struct Pokemon {
        string name;
        uint256 level;
        uint256 hp;
        uint256 attack;
        uint256 defense;
    }

    // Mapeamento de IDs de tokens para Pokémons
    mapping(uint256 => Pokemon) public pokemons;

    // Contador para gerar IDs de tokens únicos
    uint256 public tokenCounter;

    // Endereço do token ERC20 que será usado como pagamento
    address public pokeCoin;

    // Preço em tokens para gerar um Pokémon
    uint256 public price;

    // Evento que é emitido quando um novo Pokémon é criado
    event PokemonCreated(uint256 tokenId, Pokemon pokemon);

    // Construtor que recebe o endereço do token ERC20 e o preço em tokens
    constructor(address _pokeCoin, uint256 _price) ERC721("PokemonNFT", "PKNFT") {
        pokeCoin = _pokeCoin;
        price = _price;
        tokenCounter = 0;
    }

    // Função que cria um novo Pokémon e o atribui ao remetente
    // Recebe o endereço do token ERC20, a quantidade de tokens a serem gastos, e os dados do Pokémon
    function createPokemon(
        address _token,
        uint256 _amount,
        string memory _name,
        uint256 _level,
        uint256 _hp,
        uint256 _attack,
        uint256 _defense
    ) public {
        // Verifica se o endereço do token é o mesmo que foi definido no construtor
        require(_token == pokeCoin, "Invalid token address");

        // Verifica se a quantidade de tokens é igual ou maior que o preço
        require(_amount >= price, "Insufficient tokens");

        // Cria uma interface para o token ERC20
        IERC20 token = IERC20(_token);

        // Verifica se o remetente tem saldo suficiente de tokens
        require(token.balanceOf(msg.sender) >= _amount, "Insufficient balance");

        // Transfere os tokens do remetente para o contrato
        token.transferFrom(msg.sender, address(this), _amount);

        // Cria um novo Pokémon com os dados fornecidos
        Pokemon memory newPokemon = Pokemon({
            name: _name,
            level: _level,
            hp: _hp,
            attack: _attack,
            defense: _defense
        });

        // Gera um novo ID de token
        uint256 newTokenId = tokenCounter;

        // Incrementa o contador de tokens
        tokenCounter++;

        // Cria um novo token NFT e o atribui ao remetente
        _safeMint(msg.sender, newTokenId);

        // Associa o token ao Pokémon
        pokemons[newTokenId] = newPokemon;

        // Emite o evento de criação do Pokémon
        emit PokemonCreated(newTokenId, newPokemon);
    }
}
