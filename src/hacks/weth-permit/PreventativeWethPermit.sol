// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenHandler {
    using ERC165Checker for address;

    bytes4 constant PERMIT_INTERFACE_ID = type(IERC20Permit).interfaceId;

    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        require(
            address(token).supportsInterface(PERMIT_INTERFACE_ID),
            "Token does not support permit"
        );
        token.permit(owner, spender, value, deadline, v, r, s);
    }
}

/// @notice Simplified ERC165Checker library
library ERC165Checker {
    // As per the EIP-165 spec, no interface should ever match 0xffffffff
    bytes4 private constant _INVALID_INTERFACE_ID = 0xffffffff;

    /**
     * @dev Returns true if `account` supports the interface defined by
     * `interfaceId`. Support for {ERC165} itself is queried automatically.
     */
    function supportsInterface(
        address account,
        bytes4 interfaceId
    ) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        if (size == 0) return false;

        (bool success, bytes memory result) = account.staticcall(
            abi.encodeWithSelector(0x01ffc9a7, interfaceId) // ERC165's supportsInterface selector
        );
        if (!success || result.length < 32) return false;

        return abi.decode(result, (bool));
    }
}

/// @notice IERC20 interface with permit support
interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over `owner`'s tokens,
     * given `owner`'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases `owner`'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature
     * for {permit}, as defined by {EIP712}.
     */
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}
