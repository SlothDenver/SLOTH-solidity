// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import "../src/Sloth.sol";
import "../src/interface/ISloth.sol";
import "../src/test/TestERC20.sol";

contract SlothV2Test is Test {
    Sloth public sloth;
    TestERC20 public USDC;
    TestERC20 public USDT;
    address user;


    function setUp() public {
        USDC = new TestERC20("USDC", "USDC"); // wrong decimal, but ok to test out.
        USDT = new TestERC20("USDT", "USDTs"); // wrong decimal, but ok to test out.
        sloth = new Sloth(address(USDC), address(USDT));
        user = vm.addr(1);
        USDC.mint(user, 100000000000000000000);
        USDT.mint(user, 100000000000000000000);
    }

    function testMint() public {
        vm.prank(user);
        USDC.approve(address(Sloth), 100000000000000000000);
        vm.prank(user);
        Sloth.mint(address(USDC), ISloth.Price.Price_1M);

        uint256 balance = Sloth.balanceOf(user);
        uint256 a = USDC.balanceOf(address(Sloth));
        assertEq(balance, 1);
        assertEq(a, 1_000_000e6);   
    }

    function testRedeem() public {
        vm.startPrank(user);

        uint256 userUSDCBalance = USDC.balanceOf(user);
        USDC.approve(address(Sloth), 100000000000000000000);
        sloth.mint(address(USDC), ISloth.Price.Price_1M);

        assertEq(userUSDCBalance - 1_000_000e6, USDC.balanceOf(user));
        sloth.redeem(0);
        vm.stopPrank();

        uint256 userUSDCBalanceAfter = USDC.balanceOf(user);
        assertEq(userUSDCBalance, userUSDCBalanceAfter);
    }

    function testRedeemWrongTokenId() public {
        vm.startPrank(user);

        uint256 userUSDCBalance = USDC.balanceOf(user);
        USDC.approve(address(sloth), 100000000000000000000);
        sloth.mint(address(USDC), ISloth.Price.Price_1M);

        assertEq(userUSDCBalance - 1_000_000e6, USDC.balanceOf(user));
        vm.expectRevert("ERC721: invalid token ID");
        sloth.redeem(1);

        vm.stopPrank();


    }
}
