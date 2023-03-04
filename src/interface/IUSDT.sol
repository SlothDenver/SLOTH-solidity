pragma solidity ^0.8.9;

interface IUSDT {
    function transferFrom(address, address, uint256) external;
    function transfer(address, uint256) external;
}
