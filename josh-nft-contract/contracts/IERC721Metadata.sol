// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

/**
 * @title ERC621 Metadata interface
 * @dev this is optional. more details at https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
interface IERC721Metadata {
    /**
     * @dev Returns the name of the NFT contract
     * @return the name of the NFTs collection
     */
    function name() external view returns (string memory);

    /**
     * @dev returns the abbreviated name for the NFTs
     * @return returns the abbreviated name [symbol] of the NFTs collection
     */
    function symbol() external view returns (string memory);

    /**
     * @notice returns the unique URI for the given NFT asset
     * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
            3986. The URI may point to a JSON file that conforms to the "ERC721
            Metadata JSON Schema"
     * @param _tokenId the token of the NFT
     * @return returns the URI of the NFT with `_tokenId`
     */
    function tokenURI(uint256 _tokenId) external view returns (string memory);
}