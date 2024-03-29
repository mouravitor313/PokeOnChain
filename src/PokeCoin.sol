// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract PokeCoin {

    string public name = "PokeCoin";
    string public symbol = "PKC";
    uint8 public decimals = 2;
    uint public totalSupply;
    mapping(address => uint256) public balanceOf;
    address public owner;
    mapping(address => mapping(address => uint)) public allowance;

    // constructor
    constructor() {
        owner = msg.sender;
        totalSupply = 1_000_000 * 10 ** decimals;
        balanceOf[owner] = totalSupply;
    }

    // modifiers
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyHolder() {
        require(balanceOf[msg.sender] >= 1, "You don't have enough PokeCoins!");
        _;
    }

    // functions
    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        require(_spender != address(0));
        require(balanceOf[_spender] >= _value);
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transfer(
        address _to,
        uint256 _value
    ) public onlyHolder returns (bool success) {
        require(_to != address(0));
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(_from != address(0), "Invalid from address");
        require(_to != address(0), "Invalid to address");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    // events
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
}
