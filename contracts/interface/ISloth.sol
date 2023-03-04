pragma solidity ^0.8.9;

interface ISloth {
    enum Price{
        Price_100,  // 0
        Price_1K,   // 1
        Price_5K,   // 2
        Price_10K,  // 3
        Price_50K,  // 4
        Price_1M,   // 5
        Price_5M    // 6
    }
    struct NFTInfo{
        uint256 tokenId;
        address paymentToken;
        address InitialBuyer;
        Price price;
    }
    function mint(address, Price) external;
    function redeem(uint256) external;     
}