// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./Address.sol";
import "./ERC165.sol";

/**
 * @title JOSH NFT [A contract for Josh NFT collections]
 * @author Bytangle
 * @dev this is an experimental implementation of an NFT collections contract
 */
contract JoshNFT is IERC721, ERC165 {
    using Address for address;

    /// @notice Can also get this by calling `IERC721Receiver(0).onERC721Received.selector`
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    /// @notice ERC721 interface id
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    /// @notice Each token identifier mapped to owner's address
    mapping(uint256 => address) tokenOwners_;

    /// @notice each token identifier mapped to approved address
    mapping(uint256 => address) tokenApprovals_;

    /// @notice count number of tokens owned by a particular address
    mapping(address => uint256) private _ownedTokensCount;

    /// @notice map operators to owner's address
    mapping(address => mapping(address => bool)) private _operatorsApprovals;

    /**
     * @dev used with revert when throwing as a result of zero address
     * @param _msg polite description :)
     */
    error ZeroAddressProvided(string _msg);

    /**
     * @dev checks if the address provided is a non-zero address
     * throws if it's a zero address else continue execution
     */
    modifier notZeroAddr(address _addr) {
        if(_addr == address(0)) {
            revert ZeroAddressProvided("zero address provided is considered invalid");
        } else {
            _;
        }
    }

    constructor() {
        _registerInterface(_INTERFACE_ID_ERC721);
    }

    /**
     * @notice counts the `_owner`'s NFTs
     * @dev NFTs assigned to the zero address `address(0)` are considered invalid
     * @param _owner address of owner whose NFTs are to be counted
     * @return returns the total number of NFTs owned by `_owner`
     */
    function balanceOf(address _owner) public notZeroAddr(_owner) view returns (uint256) {
        return _ownedTokensCount[_owner]; 
    }

}