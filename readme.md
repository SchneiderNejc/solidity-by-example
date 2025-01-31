# Transient Storage

Data stored in transient storage is cleared out after transaction.

# Errors

Best Practices for Throwing Errors in Solidity
Use require:

For input validation and conditions that depend on user behavior (e.g., require(msg.value >= price)).
Add clear and concise error messages for better debugging.
Use revert:

For complex conditions or when a fallback/early exit is required with a detailed error message.
Use assert:

Only for internal invariants that should never fail if the contract logic is correct.
Avoid using assert for user input validation.
Use Custom Errors:

For gas-efficient error handling, especially in frequently called functions.
To pass structured data along with errors, enabling better debugging and integration.

# Events

Best Practices and Recommendations
Index the right event parameters to enable efficient filtering and searching. Addresses should typically be indexed, while amounts generally should not.
Avoid redundant events by not emitting events that are already covered by underlying libraries or contracts.
Events cannot be used in view or pure functions, as they alter the state of the blockchain by storing logs.
Be mindful of the gas cost associated with emitting events, especially when indexing parameters, as it can impact the overall gas consumption of your contract.

# Inheritance

Solidity supports multiple inheritance. Contracts can inherit other contract by using the is keyword.

Function that is going to be overridden by a child contract must be declared as virtual.

Function that is going to override a parent function must use the keyword override.

Order of inheritance is important.

You have to list the parent contracts in the order from “most base-like” to “most derived”.

# Calling Parent Contracts

Parent contracts can be called directly, or by using the keyword super.

By using the keyword super, all of the immediate parent contracts will be called.

# Interface

You can interact with other contracts by declaring an Interface.

Interface

cannot have any functions implemented
can inherit from other interfaces
all declared functions must be external
cannot declare a constructor
cannot declare state variables

# Delegatecall

delegatecall is a low level function similar to call.

When contract A executes delegatecall to contract B, B's code is executed

with contract A's storage, msg.sender and msg.value.

# Call

call is a low level function to interact with other contracts.

This is the recommended method to use when you're just sending Ether via calling the fallback function.

However it is not the recommended way to call existing functions.

Few reasons why low-level call is not recommended
Reverts are not bubbled up
Type checks are bypassed
Function existence checks are omitted

# Library

Libraries are similar to contracts, but you can't declare any state variable and you can't send ether.

A library is embedded into the contract if all library functions are internal.

Otherwise the library must be deployed and then linked before the contract is deployed.

# Call

call is a low level function to interact with other contracts.

This is the recommended method to use when you're just sending Ether via calling the fallback function.

However it is not the recommended way to call existing functions.

Few reasons why low-level call is not recommended
Reverts are not bubbled up
Type checks are bypassed
Function existence checks are omitted

# Function Selector

When a function is called, the first 4 bytes of calldata specifies which function to call.

This 4 bytes is called a function selector.

Take for example, this code below. It uses call to execute transfer on a contract at the address addr.

addr.call(abi.encodeWithSignature("transfer(address,uint256)", 0xSomeAddress, 123))

# Calling Other Contract

Contract can call other contracts in 2 ways.

The easiest way to is to just call it, like A.foo(x, y, z).

Another way to call other contracts is to use the low-level call.

This method is not recommended.

# Contract that Creates other Contracts (FactoryContract)

Contracts can be created by other contracts using the new keyword. Since 0.8.0, new keyword supports create2 feature by specifying salt options.

Create vs Create2

CREATE uses the deployer's address and their nonce to compute the contract's address. CREATE2 uses the deployer's address, a user-provided salt, and the contract's bytecode to compute the address deterministically.
Use CREATE for straightforward contract deployments without needing deterministic addresses.
Use CREATE2 for applications requiring deterministic, predictable addresses or when deploying contracts with specific address requirements.

# Try Catch

try / catch can only catch errors from external function calls and contract creation.

# ABI Decode

abi.encode encodes data into bytes.

abi.decode decodes bytes back into data.

# Hashing with Keccak256

keccak256 computes the Keccak-256 hash of the input.

Some use cases are:

Creating a deterministic unique ID from an input
Commit-Reveal scheme
Compact cryptographic signature (by signing the hash instead of a larger input)

# Verifying Signature

Messages can be signed off chain and then verified on chain using a smart contract.

# Gas Saving Techniques

Some gas saving techniques.

Replacing memory with calldata
Loading state variable to memory
Replace for loop i++ with ++i
Caching array elements
Short circuit

# Unchecked Math

Overflow and underflow of numbers in Solidity 0.8 throw an error. This can be disabled by using unchecked.
Disabling overflow / underflow check saves gas.

# Gas saving with assembly

Variable Declaration (yul_let):

In Yul, declaring variables (e.g., let x := 123) directly interacts with stack variables, avoiding Solidity's overhead of memory storage.
Gas Savings: Minimal but efficient for simple operations.
Control Flow (yul_if and yul_switch):

Assembly if and switch translate directly into EVM opcodes, eliminating the compiler's additional overhead.
Gas Savings: Noticeable when many conditional checks exist.
Loops (yul_for_loop and yul_while_loop):

Writing loops in Yul avoids unnecessary range checks and function overhead that Solidity includes.
Gas Savings: Significant for operations with many iterations.
Error Handling (yul_revert):

Using revert in Yul directly accesses the EVM opcode, avoiding Solidity's structured exception handling.
Gas Savings: Minor but efficient in specific scenarios.
Math Operations (yul_add, yul_mul):

Assembly math bypasses Solidity's built-in overflow checks (if not required), reducing gas consumption.
Gas Savings: Noticeable for repeated or complex operations.

APPLICATIONS

#EtherWallet
An example of a basic wallet.

Anyone can send ETH.
Only the owner can withdraw.

#Multi-Sig Wallet

The wallet owners can
submit a transaction
approve and revoke approval of pending transactions
anyone can execute a transaction after enough owners has approved it.

# Minimal Proxy Contract

If you have a contract that will be deployed multiple times, use minimal proxy contract to deploy them cheaply.

# Upgradeable Proxy

Example of upgradeable proxy contract. Never use this in production.

This example shows

how to use delegatecall and return data when fallback is called.
how to store address of admin and implementation in a specific slot.

# Crowd Fund

Crowd fund ERC20 token

User creates a campaign.
Users can pledge, transferring their token to a campaign.
After the campaign ends, campaign creator can claim the funds if total amount pledged is more than the campaign goal.
Otherwise, campaign did not reach it's goal, users can withdraw their pledge.

# Multi Call (staticcall)

An example of contract that aggregates multiple queries using a for loop and staticcall.

# Multi Delegatecall

An example of calling multiple functions with a single transaction, using delegatecall.

# Time Lock

TimeLock is a contract that publishes a transaction to be executed in the future. After a minimum waiting period, the transaction can be executed.

TimeLocks are commonly used in DAOs.

HACKS

# Re-Entrancy

Vulnerability
Let's say that contract A calls contract B.
Reentracy exploit allows B to call back into A before A finishes execution.
Note: Reentrancy is possible on an erc20-based transfers as well.

Preventative Techniques
Ensure all state changes happen before calling external contracts
Use function modifiers that prevent re-entrancy

# Arithmetic Overflow and Underflow

Vulnerability
Solidity < 0.8
Integers in Solidity overflow / underflow without any errors

Solidity >= 0.8
Default behaviour of Solidity 0.8 for overflow / underflow is to throw an error.

Preventative Techniques
Use SafeMath to will prevent arithmetic overflow and underflow

# Self Destruct

Contracts can be deleted from the blockchain by calling selfdestruct.

selfdestruct sends all remaining Ether stored in the contract to a designated address.

Vulnerability
A malicious contract can use selfdestruct to force sending Ether to any contract.
Preventative Techniques
Don't rely on address(this).balance

# Accessing Private Data

Vulnerability
All data on a smart contract can be read, even on unverified contract.

Preventative Techniques
Don't store sensitive information on the blockchain.

# Delegatecall

Vulnerability
delegatecall is tricky to use and wrong usage or incorrect understanding can lead to devastating results.

You must keep 2 things in mind when using delegatecall

delegatecall preserves context (storage, caller, etc...)
storage layout must be the same for the contract calling delegatecall and the contract getting called

Preventative Techniques
Use stateless Library

# Source of randomness

Vulnerability
blockhash and block.timestamp are not reliable sources for randomness.

Preventative Techniques
Don't use blockhash and block.timestamp as source of randomness

The vulnerability arises because blockhash and block.timestamp are publicly accessible and deterministic.
Both methods (JavaScript computation or reading storage slots) can bypass the need for deploying the Attack contract, demonstrating how easily the contract's logic can be exploited.

# Denial of Service

Vulnerability
There are many ways to attack a smart contract to make it unusable.

One exploit we introduce here is denial of service by making the function to send Ether fail.

Preventative Techniques
One way to prevent this is to allow the users to withdraw their Ether instead of sending it.

# Phishing with tx.origin

What's the difference between msg.sender and tx.origin?
If contract A calls B, and B calls C, in C msg.sender is B and tx.origin is A.

Vulnerability
A malicious contract can deceive the owner of a contract into calling a function that only the owner should be able to call.

Preventative Techniques
Use msg.sender instead of tx.origin

# Hiding Malicious Code with External Contract

Vulnerability
In Solidity any address can be casted into specific contract, even if the contract at the address is not the one being casted.

This can be exploited to hide malicious code.
If a developer assumes that the address being cast belongs to a trusted contract but it points to a malicious contract or no contract at all, this can be exploited by an attacker to execute harmful operations or manipulate the logic.

Preventative Techniques
Initialize a new contract inside the constructor
Make the address of external contract public so that the code of the external contract can be reviewed

# Honeypot

A honeypot is a trap to catch hackers.

Vulnerability
Combining two exploits, reentrancy and hiding malicious code, we can build a contract that will catch malicious users.
The honeypot traps attackers by locking their deposits, but it also traps honest users' funds, which undermines its practicality.

# Front Running

Vulnerability
Transactions take some time before they are mined. An attacker can watch the transaction pool and send a transaction, have it included in a block before the original transaction. This mechanism can be abused to re-order transactions to the attacker's advantage.

Preventative Techniques
use commit-reveal scheme (https://medium.com/swlh/exploring-commit-reveal-schemes-on-ethereum-c4ff5a777db8)
use submarine send (https://libsubmarine.org/)
Commit-Reveal Schemes
A commitment scheme is a cryptographic algorithm used to allow someone to commit to a value while keeping it hidden from others with the ability to reveal it later. The values in a commitment scheme are binding, meaning that no one can change them once committed. The scheme has two phases: a commit phase in which a value is chosen and specified, and a reveal phase in which the value is revealed and checked.

Findings

1. In the reveal-commit scheme participant first calls commitSolution and secondly revealSolution, in two seperate transactions.
2. Reveal-commit scheme adds complexity to the source contract, method of interaction (two tx instead of just one), consumes more time, as well as higher cost of interaction in exchange for security.

Trade-Offs of Commit-Reveal
While the scheme adds robustness to the protocol, its usability is less ideal for real-world applications that demand simplicity and low costs. Developers must carefully evaluate if the added security against front-running outweighs the drawbacks of increased complexity and user effort.

Alternative solutions:
Zero-Knowledge Proofs (ZKPs) - require advanced cryptographic techniques
Private Transactions - systems like Flashbots or encrypted mempools to submit his solution directly to miners without exposing it to the public transaction pool.

# Block Timestamp Manipulation

Vulnerability
block.timestamp can be manipulated by miners with the following constraints

it cannot be stamped with an earlier time than its parent
it cannot be too far in the future

# Block Timestamp Manipulation

Vulnerability
block.timestamp can be manipulated by miners with the following constraints

it cannot be stamped with an earlier time than its parent
it cannot be too far in the future

Preventative Techniques
Don't use block.timestamp for a source of entropy and random number

# Signature Replay

Signing messages off-chain and having a contract that requires that signature before executing a function is a useful technique.

For example this technique is used to:

reduce number of transaction on chain
gas-less transaction, called meta transaction
Vulnerability
Same signature can be used multiple times to execute a function. This can be harmful if the signer's intention was to approve a transaction once.

Preventative Techniques
Sign messages with nonce and address of the contract. Make sure tx can only execute once.

# Bypass Contract Size Check

Vulnerability
If an address is a contract then the size of code stored at the address will be greater than 0 right?
Not if the call is made from the contract during deployment (in constructor) - extcodesize will be 0.

# Deploy Different Contracts at the Same Address

DAO verifies out Proposal as valid. We then redeploy different contract to Proposal address.
DAO invokes "verifies" method on our now Attack contract by using delegatecall.
Method allows to update all state variables from DAO, as long as we know its storage layout.
Attackers is using CREATE2 on relayer contract.

# Vault Inflation

Vulnerability
Vault shares can be inflated by donating ERC20 token to the vault.

Attacker can exploit this behavior to steal other user's deposits.

Protections
Min shares -> protects from front running
Internal balance -> protects from donation
Dead shares -> contract is first depositor
Decimal offset (OpenZeppelin ERC4626)

# WETH Permit

Always validate assumptions about external contracts before interacting with them.

This includes ensuring that:

The external contract supports the expected functionality (e.g., permit).
Calls to external contracts behave predictably and do not silently fail or trigger unintended fallback functions.

DEFI

# Chainlink Price Oracle

The ChainlinkPriceOracle contract fetches the latest price data for a specified asset pair (ETH/USD) using Chainlink's decentralized oracle network.

Functions:

getLatestPrice
Purpose: Returns the most recent ETH/USD price in human-readable format.
Steps:
Calls the latestRoundData function of the Chainlink AggregatorV3Interface.

Returns:
Current ETH/USD price as an int256.
Key Features:

Dependency: Relies on the Chainlink AggregatorV3Interface at a hardcoded address for price data.
Scaling: Chainlink prices are returned with an 8-decimal precision; this is adjusted for usability.

# Staking Rewards

The StakingRewards contract allows users to stake an ERC20 token to earn rewards in another ERC20 token. Rewards are distributed over a specified duration, calculated proportionally to the user's staked amount and the time elapsed. The contract is simple, efficient, and includes basic admin controls for reward management.

Functions

stake(uint256 \_amount)
Purpose: Allows users to deposit staking tokens into the contract.

withdraw(uint256 \_amount)
Purpose: Enables users to withdraw their staked tokens.

getReward()
Purpose: Transfers the user’s accumulated rewards to their address.

earned(address \_account)
Purpose: Calculates the total rewards earned by a user based on their staked amount.
Return Value: The total unclaimed reward amount for the user.

setRewardsDuration(uint256 \_duration)
Purpose: Sets the duration of the rewards program (only callable by the owner).

notifyRewardAmount(uint256 \_amount)
Purpose: Updates the reward pool with new tokens and adjusts the reward rate.

# Discrete Staking Rewards

Differences Overview
Staking Rewards: Rewards are distributed at a constant rate over a specified duration. The reward calculation depends on the duration, total supply, and staking amount.
Discrete Staking Rewards: Rewards can vary dynamically over time. Each update to the reward index adjusts the amount distributed based on available rewards and the current total staked supply.

# Vault

The Vault contract allows users to deposit tokens, which mint shares in return. These shares represent the user's stake in the vault. When users want to withdraw, they burn their shares to receive a proportional amount of the underlying tokens, including any accrued yield.

\_mint(address \_to, uint256 \_shares): Mints new shares for a user and updates the total supply and the user's balance.

\_burn(address \_from, uint256 \_shares): Burns shares from a user and updates the total supply and the user's balance.

deposit(uint256 \_amount): Allows a user to deposit tokens, minting an equivalent amount of shares based on the token balance and total supply.

withdraw(uint256 \_shares): Allows a user to withdraw tokens by burning their shares, with the amount based on the share-to-token ratio.

# Constant Sum AMM

The Constant Sum AMM (CSAMM) is an Automated Market Maker that maintains the invariant X + Y = K. This means that the sum of token reserves remains constant, allowing 1:1 token swaps. It is useful for pegged assets (e.g., stablecoins) but is vulnerable to arbitrage and impermanent loss.

Functions:

swap(address \_tokenIn, uint256 \_amountIn) → uint256 amountOut
Trades \_tokenIn for the other token while applying a 0.3% fee. Ensures constant sum liquidity is maintained.

addLiquidity(uint256 \_amount0, uint256 \_amount1) → uint256 shares
Adds liquidity to the pool by depositing both tokens. Mints liquidity shares based on the added amount.

removeLiquidity(uint256 \_shares) → (uint256 d0, uint256 d1)
Burns \_shares and withdraws proportional token reserves.

\_update(uint256 \_res0, uint256 \_res1) (private)
Updates the reserve balances.

\_mint(address \_to, uint256 \_amount) (private)
Mints \_amount liquidity shares for \_to.

\_burn(address \_from, uint256 \_amount) (private)
Burns \_amount liquidity shares from \_from.

# Constant Product AMM

The CPAMM is a decentralized liquidity pool implementing x \* y = k, ensuring that trades maintain a constant product of token reserves. It enables:

Swaps between two ERC-20 tokens.
Liquidity provisioning for users to earn fees.
Liquidity removal with proportional asset withdrawal.

Key Functionalities
Swaps (swap) – Trades tokens using the constant product formula while applying a 0.3% fee.
Liquidity Provision (addLiquidity) – Allows users to deposit token pairs and mint LP tokens.
Liquidity Removal (removeLiquidity) – Burns LP tokens to redeem underlying assets.
Internal Utility Functions (\_mint, \_burn, \_update) – Manages LP tokens and reserve updates.
Math Helpers (\_sqrt, \_min) – Implements square root and min functions for share calculations.

# Stable Swap AMM

This contract implements a stable swap automated market maker (AMM) similar to Curve Finance. It optimizes for minimal slippage when swapping between stablecoins by using a specialized invariant formula. The contract supports:

Swaps between tokens using Newton's method for solving the invariant equation.
Liquidity management, including adding/removing liquidity and withdrawing single tokens.
Virtual price calculations to estimate LP share value.
The invariant ensures low slippage swaps by keeping the pool balanced and adjusting token weights dynamically.

Functions
\_getD(uint256[N] memory xp) → uint256
Computes the stable swap invariant (D) using Newton's method.

\_getY(uint256 i, uint256 j, uint256 x, uint256[N] memory xp) → uint256
Calculates the new balance of token j after swapping x of token i.

swap(uint256 i, uint256 j, uint256 dx, uint256 minDy) → uint256
Executes a token swap while enforcing the invariant and fees.

addLiquidity(uint256[N] calldata amounts, uint256 minShares) → uint256
Adds liquidity to the pool, minting LP tokens while applying imbalance fees.

removeLiquidity(uint256 shares, uint256[N] calldata minAmountsOut) → uint256[N]
Removes liquidity proportionally across all tokens.

removeLiquidityOneToken(uint256 shares, uint256 i, uint256 minAmountOut) → uint256
Withdraws liquidity in a single token, applying slippage and imbalance fees.

getVirtualPrice() → uint256
Estimates the value of 1 LP share relative to underlying tokens.
