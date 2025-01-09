import "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";

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
