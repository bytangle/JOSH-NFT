// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./IERC165.sol";

/**
 * @title ERC721 Non-Fungible token standard Interface
 * @dev Details can be found here: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 * Note: the ERC-165 identifier for this interface is 0x80ac58cd.
 */
interface IERC721 {
    /**
     * @dev This emits when the ownership of the NFT changes
     * Note: it should also emit on NFT creation and destruction
     * @param _from address of the initial owner
     * @param _to address of the entity to receive the ownership
     * @param _tokenId unique ID of the NFT
     */
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    /**
     * @dev this emits when the approved address for an NFT changes or reaffirmed
     * @param _owner address of the owner of the NFT
     * @param _approved the new owner's address
     * @param _tokenId the ID of the NFT
     */
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    /**
     * @dev emits when an operator is enabled or disabled for an owner
     * @param _owner address of the owner of the NFT
     * @param _operator address of to be set as operator
     * @param _approved boolean showing approval or disapproval
     */
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    /**
     * @notice counts the owner's NFTs
     * @dev cannot count NFTs assigned to the zero address.
     * Note function should possibly throw or revert for an attempt to count NFTs assigned to zero address
     * @param _owner the address of the NFTs owner
     * @return The total NFT owned by `_owner`
     */
    function balanceOf(address _owner) external view returns (uint256);

    /**
     * @notice get the owner of the NFT with token ID `_tokenId`
     * @dev NFTs assigned to zero address are considered invalid
     * @param _tokenId uint256 id of the NFT
     * @return address of the owner of NFT with `_tokenId` token ID
     */
    function ownerOf(uint256 _tokenId) external view returns (address);

    /**
     * @notice transfers the ownership of an NFT from one address to the other
     * @dev throws unless the current owner `_to` is msg.sender, 
            an authorized operator or an approved address for the NFT
     * Note: check the EIP-721 documentation for more details [url provided above]
     * @param _from the current owner of the NFT
     * @param _to the new owner
     * @param _tokenId NFT to transfer
     * @param _data additional data if necessary with no specific format
     */
    function safeTransfer(address _from, address _to, uint256 _tokenId, bytes memory _data) external payable;

    /**
     * @notice transfer NFT ownership between addresses
     * @dev This work identically to the function declared above except that it lacks data argument
     * @param _from address of the NFT owner
     * @param _to new owner of NFT
     * @param _tokenId NFT to transfer
     */
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;

    /**
     * @notice transfers NFT ownership
     * Note: The caller is responsible to check if `_to` is capable of receiving NFTs otherwise, they may be lost
     * @dev throws unless _from is msg.sender, an authorized operator or an approved addressed for the NFT
     * @param _from address of current owner of the NFT
     * @param _to address of the new owner of the NFT
     * @param _tokenId NFT to be transfered
     */
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

    /**
     * @notice change or reaffirm the approved address for an NFT
     * @dev zero address is invalid
     * @param _approved the new approved address for the NFT controller
     * @param _tokenId NFT to approve
     */
    function approve(address _approved, uint256 _tokenId) external payable;

    /**
     * @notice enable or disable approval for a third-party `_operator` to manage `msg.sender`'s assets
     * @dev emits the ApprovalForAll event. The contract must allow multiple operators per owner
     * @param _operator address to add to set of authorized operators
     * @param _approved true if operator is approved, false to revoke approval
     */
    function setApprovalForAll(address _operator, bool _approved) external;

    /**
     * @notice get approved address for a single NFT
     * @dev throws if _tokenId isn't a valid NFT
     * @param _tokenId the NFT to find the approved address for
     * @return approved address
     */
    function getApproved(uint256 _tokenId) external view returns (address);

    /**
     * @notice check if an address is an authorized operator for another address
     * @param _owner the address that owns the NFT
     * @param _operator the address that acts on behalf of the `_owner`
     * @return returns `true` if `_operator` is an approved operator for `_owner`, else otherwise
     */
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}