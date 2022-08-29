// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./Address.sol";

/**
 * @title JOSH NFT [A contract for Josh NFT collections]
 * @author Bytangle
 * @dev this is an experimental implementation of an NFT collections contract
 */
contract JoshNFT is IERC721 {
    using Address for address;

    /// Can also get this by calling `IERC721Receiver(0).onERC721Received.selector`
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    /// each token identifier mapped to owner's address
    mapping(uint256 => address) tokenOwners_;

    /// each token identifier mapped to approved address
    mapping(uint256 => address) tokenApprovals_;
}