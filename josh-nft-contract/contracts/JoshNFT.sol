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
     * @dev used with revert when throwing as a result of token not found
     * @param _msg description
     */
    error TokenDoesNotExist(string _msg);

    /**
     * @dev used with revert for unauthorized transfers
     * @param _msg brief description
     */
    error UnauthorizedTransfer(string _msg);

    /**
     * @dev checks if the address provided is a non-zero address
     * throws if it's a zero address else continue execution
     * @param _addr address to check
     */
    modifier notZeroAddr(address _addr) {
        if(_addr == address(0)) {
            revert ZeroAddressProvided("zero address provided is considered invalid");
        } else {
            _;
        }
    }

    /**
     * @dev checks if token with the provided ID exists
     * revert if token with the given id cannot be found else continue execution
     * @param _tokenId the given token identifier
     */
    modifier tokenExists(uint256 _tokenId) {
        if(tokenOwners_[_tokenId] != address(0)) {
            _;
        } else {
            revert TokenDoesNotExist("No token with given ID: " + string(_tokenId));
        }
    }

    /**
     * @dev authorize token transfer
     * @param _addr the address of the initiator
     * @param _tokenId the identifier of the NFT to be transferred
     */
    modifier isOwnerOrApproved(address _addr, uint256 _tokenId) {
        address owner = tokenOwners_[_tokenId];

        if(
            (_addr == owner) ||
            (_addr == getApproved(_tokenId)) ||
            isApprovedForAll(owner, _addr)
        ) {
            _;
        } else {
            revert UnauthorizedTransfer("You do not have rights to perform this transfer");
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

    /**
     * @notice retrieves the owner of the NFT with `_tokenId` token identifier
     * @dev throws if the owner of NFT with `_tokenId` token identifier is a zero address
     * @param _tokenId the identifier of the NFT whose owner is queried
     * @return address of the NFT owner
     */
    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = tokenOwners_[_tokenId];

        require(owner != address(0)); // address must not be the zero address

        return owner;
    }

    function safeTransfer(address _from, address _to, uint256 _tokenId, bytes memory _data) 
        public notZeroAddr(_from) notZeroAddr(_to) payable {

            
    } 

    function transferFrom(address _from, address _to, uint256 _tokenId) public payable 
        isOwnerOrApproved(_from, _tokenId) notZeroAddr(_to) {
            
    }

    /**
     * @notice check if `_operator` is authorized to have access to `_owner`'s NFTs
     * @param _owner NFTs owner's address
     * @param _operator address to check wether it's an operator or not
     * @return returns `True` if authorized or `False`
     */
    function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
        return _operatorsApprovals[_owner][_operator];
    }

    /**
     * @notice get approved addresses
     * @dev throws if `_tokenId` is invalid
     * @param _tokenId the identifier of the token to obtain it's approved address
     * @return returns the approved address for the token with the given identifier
     */
    function getApproved(uint256 _tokenId) public view tokenExists(_tokenId) returns (address) {
        return tokenApprovals_[_tokenId];
    }

}