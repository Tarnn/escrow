// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {
    address public buyer;
    address public seller;
    address public arbiter;
    uint256 public amount;
    bool public isFunded;
    bool public isReleased;
    bool public isRefunded;

    event Deposited(address indexed buyer, uint256 amount);
    event Released(address indexed seller, uint256 amount);
    event Refunded(address indexed buyer, uint256 amount);
    event DisputeResolved(address indexed resolver, bool releasedToSeller);

    modifier onlyBuyer() { require(msg.sender == buyer, "Only buyer can call this"); _; }
    modifier onlyArbiter() { require(msg.sender == arbiter, "Only arbiter can call this"); _; }
    modifier inState(bool _isFunded, bool _isReleased, bool _isRefunded) {
        require(isFunded == _isFunded && isReleased == _isReleased && isRefunded == _isRefunded, "Invalid state");
        _;
    }

    constructor(address _seller, address _arbiter) {
        require(_seller != address(0) && _arbiter != address(0), "Invalid address");
        require(_seller != _arbiter, "Seller and arbiter cannot be the same");
        buyer = msg.sender;
        seller = _seller;
        arbiter = _arbiter;
    }

    function deposit() external payable onlyBuyer inState(false, false, false) {
        require(msg.value > 0, "Deposit must be greater than 0");
        amount = msg.value;
        isFunded = true;
        emit Deposited(msg.sender, msg.value);
    }

    function releaseFunds() external onlyBuyer inState(true, false, false) {
        isReleased = true;
        payable(seller).transfer(amount);
        emit Released(seller, amount);
    }

    function requestRefund() external onlyBuyer inState(true, false, false) {
        isRefunded = true;
        payable(buyer).transfer(amount);
        emit Refunded(buyer, amount);
    }

    function resolveDispute(bool releaseToSeller) external onlyArbiter inState(true, false, false) {
        if (releaseToSeller) {
            isReleased = true;
            payable(seller).transfer(amount);
            emit Released(seller, amount);
        } else {
            isRefunded = true;
            payable(buyer).transfer(amount);
            emit Refunded(buyer, amount);
        }
        emit DisputeResolved(msg.sender, releaseToSeller);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}