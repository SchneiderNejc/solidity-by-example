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