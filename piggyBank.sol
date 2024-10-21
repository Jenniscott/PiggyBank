// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./IERC20.sol";

contract piggyBank {
    IERC20 public token;

    mapping(address => uint256) savings;

    event SaveSuccessful(address indexed user, uint256 amount);
    event WithdrawSuccessful(address indexed user, uint256 amount);

    constructor(address _token) {
        token = IERC20(_token);
    }

// This function allows users deposit the amount to save
    function save(uint256 _amount) external {
        require(msg.sender != address(0), "zero address detected");
        require(_amount != 0, "Cannot save zero amount");
        
        uint256 _userBalance = token.balanceOf(msg.sender);
        require(_userBalance >= _amount, "insufficient funds");

        uint256 _allowance = token.allowance(msg.sender, address(this));
        require(_allowance >= _amount, "Insufficient allowance");

        savings[msg.sender] += _amount;

        token.transferFrom(msg.sender, address(this), _amount);

        emit  SaveSuccessful(msg.sender, _amount);
    }

//This function allows users withdraw thier saved amout
    function withdraw(uint256 _amount) external {
        require(msg.sender != address(0), "zero address detected");
        require(_amount > 0, "can't withdraw zero value");
        
        uint256 _userSavings = savings[msg.sender];
        require(_userSavings >= _amount, "insuffiecient savings");

        savings[msg.sender] -= _amount;
        
        token.transfer(msg.sender, _amount);
        
        emit WithdrawSuccessful(msg.sender, _amount);
    }

    function getUserBalance() external view returns (uint256) {
        return savings[msg.sender];
    }
}

