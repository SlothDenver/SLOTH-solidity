// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/ISloth.sol";

contract Sloth is ISloth, ERC721{

    using SafeERC20 for IERC20;
 
    uint256[7] public price = [
        100,
        1_000,
        5_000,
        10_000,
        50_000,
        1_000_000,
        5_000_000
    ];

    uint256[7] public maxSlothByPrice = [
        5555,
        2222,
        1111,
        555,
        333,
        222,
        2
    ];


    uint256 public constant maxSloth = 10000;
    uint256 public totalSupply;
    mapping (uint256 => NFTInfo) public NFTInfos; // token Id => NFTInfo
    mapping (Price => uint256) public SlothTotalSupplyByPrice; // token Id => NFTInfo

    // munbai USTC: 0xFEca406dA9727A25E71e732F9961F680059eF1F9
    address public immutable USDT;
    address public immutable USDC;
    

    constructor(address _USDC, address _USDT) ERC721("Stablen",  "STB") {
        require(_USDC != address(0), "USDC is ZERO ADDRESS");
        require(_USDT != address(0), "USDT is ZERO ADDRESS");

        USDT = _USDT;
        USDC = _USDC;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "needBaseURI";
    }

    function mint(address paymentToken, Price _price) public {

    }

        function redeem(uint256 tokenId) public {

    }

    function onERC721Received(address, address, uint256, bytes calldata) external returns (bytes4){
        return IERC721Receiver.onERC721Received.selector;
    }

}