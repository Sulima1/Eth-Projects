//for fun attempt at creating an ERC20 smart contract

//clean up compile errors 

pragma solidity ^0.8.7;

// SPDX-License-Identifier: UNLICENSED

interface IERC20{
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
}

contract ERC20 is IERC20 {
    //token restrictions
    uint public totalSupply;
    mapping (address => uint) public balanceOf;
    mapping (address => mapping(address => uint)) public allowance;

    //token identifiers
    string public constant symbol = "BTK";
    string public constant name = "Bork Token";
    uint8 public constant decimals = 18;

    //error handler incase of insufficient transfer
    error InsufficientBalance(uint requested, uint balance);

    //transfers the amount of tokens that msg.sender has over to the recipient
    function transfer(address recipient, uint amount) external returns (bool){
        if (amount > balanceOf[msg.sender]) //checks for a valid requested amount, sends error if invalid
            revert InsufficientBalance({
            requested: amount,
            balance: balanceOf[msg.sender]
            });
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    //msg.sender approving a spender to spend some of their balance
    function approve(address spender, uint amount) external returns (bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    //transfers tokens from sender to recipient
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool){
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    //allows new tokens to be minted
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    //burn tokens
    function burn(uint amount) external{
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);        
    }

}