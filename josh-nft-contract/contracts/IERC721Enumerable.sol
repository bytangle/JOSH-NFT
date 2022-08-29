// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

/**
 * @title ERC721 Enumerable interface
 * @dev This interface is optional. More details at https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 * Note: the ERC-165 identifier for this interface is 0x780e9d63.
 */
interface IERC721Enumerable {

    /**
     * @notice counts the NFTs tracked by this contract
     * @return returns the count of NFTs tracked by this contract
     */
    function totalSupply() external returns (uint256);

    /**
     * @notice returns the NFT at `_index` index
     * @dev throws if `_index` >= `totalSupply()`
     * @param _index a counter less than `totalSupply()`
     * @return returns the tokenId of the NFT at the given index
     */
    function tokenByIndex(uint256 _index) external view returns (uint256);

    /**
     * @notice returns the NFT of an `_owner` at `_index` index
     * @dev throws if `_owner` is a zero address or if `_index` >= `totalSupply()`
     * @param _owner address of the NFT owner
     * @param _index a counter less than `totalSupply()`
     * @return returns the tokenId of the NFT at the given index
     */
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
}