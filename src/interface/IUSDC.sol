pragma solidity ^0.8.9;

interface IUSDC {
    function transferFrom(address, address, uint) external returns (bool);
    function transfer(address, uint256) external;
}
