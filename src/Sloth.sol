// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/ISloth.sol";

// User can connect metamask 
// User can mint a sNFT either by USDC or USDC
// User can redeem the input asset by burning his sNFT 
// [non-essential]
// User can send sNFT to another wallet 
// User can send tokens and sNFT to another wallet 
// [UNIC]
// User can scan a minted sNFT to verify authenticity 

/*
//                           ***DEMO***
//  This contract has only two functions, mintWithTenUSD() and redeem().
//  mintWithTenUSD(): User can mint by paying 10 USD
//  redeem(): redeem USD they paid, and return NFT to this contract
//  * In Demo,
//  * 1. Only USDC is used
//  * 2. After redeem, NFT is lock into contract.
*/ 
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
    
    event totalSupplyAdded(uint256);
    event mintNFT_FiftyUSD(address owner, uint256 tokenId);
    event mintNFT_TenUSD(address owner, uint256 tokenId);

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

        require(totalSupply < maxSloth, "mint(): exceed maxSupply");
        require(SlothTotalSupplyByPrice[_price] < maxSlothByPrice[uint256(_price)], "mint(): exceed maxSupplyByPrice");
        uint256 tokenId = totalSupply;
        
        // must approve the contract for payment
        if(paymentToken == USDT){
            IERC20(USDT).safeTransferFrom(msg.sender, address(this), price[uint256(_price)]*10**6);
        } else if(paymentToken == USDC){
        // USDC payment
            IERC20(USDC).safeTransferFrom(msg.sender, address(this), price[uint256(_price)]*10**6);
        } else{
            revert("mint(): Wrong Payment Token");
        }

        NFTInfos[tokenId] = NFTInfo(
            tokenId,
            paymentToken,
            msg.sender,
            _price
        );

        totalSupply++;
        SlothTotalSupplyByPrice[_price]++;

        _safeMint(msg.sender, tokenId);

    }

    
    /// @notice Users can redeem USDT or USDC, and return NFT to contract
    /// @dev Transfers the `paymentToken` to `msg.sender` and `safeTransferFrom` NFT to address(this)
    /// @param tokenId USDC or USDT, only USDC for DEMO
    function redeem(uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(owner == msg.sender, "redeem(): Invalid Owner");

        // later used for payment
        NFTInfo memory tokenInfo = NFTInfos[tokenId];
        NFTInfos[tokenId] = NFTInfo(
            tokenId,
            address(0),
            address(this),
            tokenInfo.price
        );

        // token 회수
        safeTransferFrom(msg.sender, address(this), tokenId);
        
        // token 돈 다시 보내주기
        // maybe just use safeTransfer
        if(tokenInfo.paymentToken == USDT){
            IERC20(USDT).safeTransfer(owner, price[uint256(tokenInfo.price)]*10**6);
        } else {
            IERC20(USDC).safeTransfer(owner, price[uint256(tokenInfo.price)]*10**6);
        }

    }

    function onERC721Received(address, address, uint256, bytes calldata) external returns (bytes4){
        return IERC721Receiver.onERC721Received.selector;
    }

}