// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract WMND {
    string public constant name = "Wrapped Monad";
    string public constant symbol = "WMND";
    uint8 public constant decimals = 18;

    event Approval(address indexed src, address indexed guy, uint256 wad);
    event Transfer(address indexed src, address indexed dst, uint256 wad);
    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() payable {
        deposit();
    }

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 _wad) public {
        require(balanceOf[msg.sender] >= _wad);
        balanceOf[msg.sender] -= _wad;
        payable(msg.sender).transfer(_wad);

        emit Withdrawal(msg.sender, _wad);
    }

    function totalSupply() public view returns (uint256) {
        return address(this).balance;
    }

    function approve(address _guy, uint256 _wad) public returns (bool) {
        allowance[msg.sender][_guy] = _wad;

        emit Approval(msg.sender, _guy, _wad);

        return true;
    }

    function transfer(address _dst, uint256 _wad) public returns (bool) {
        return transferFrom(msg.sender, _dst, _wad);
    }

    function transferFrom(address src, address _dst, uint256 _wad) public returns (bool) {
        require(balanceOf[src] >= _wad);

        if (src != msg.sender && allowance[src][msg.sender] != 0) {
            require(allowance[src][msg.sender] >= _wad);
            allowance[src][msg.sender] -= _wad;
        }

        balanceOf[src] -= _wad;
        balanceOf[_dst] += _wad;

        emit Transfer(src, _dst, _wad);

        return true;
    }
}
