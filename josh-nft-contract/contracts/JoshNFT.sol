// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./Address.sol";
import "./ERC165.sol";
import "./IERC721Receiver.sol";

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
    mapping(uint256 => address) private _tokenOwners;

    /// @notice each token identifier mapped to approved address
    mapping(uint256 => address) private _tokenApprovals;

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
     * @dev used with revert for unauthorized transfers or access
     * @param _msg brief description
     */
    error Unauthorized(string _msg);

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
     * @dev check if `_addr` is the owner of the token with `_tokenId` identifier
     * @param _addr address to check ownership of token
     * @param _tokenId the identifier of the NFT
     */
    modifier isTokenOwner(address _addr, uint256 _tokenId) {
        if(_tokenOwners[_tokenId] == _addr) _;
        else revert Unauthorized("You dont own this token");
    }

    /**
     * @dev checks if token with the provided ID exists
     * revert if token with the given id cannot be found else continue execution
     * @param _tokenId the given token identifier
     */
    modifier tokenExists(uint256 _tokenId) {
        if(_tokenOwners[_tokenId] != address(0)) {
            _;
        } else {
            revert TokenDoesNotExist("No token with given ID:");
        }
    }

    /**
     * @dev authorize token transfer
     * @param _addr the address of the initiator
     * @param _tokenId the identifier of the NFT to be transferred
     */
    modifier isOwnerOrApproved(address _addr, uint256 _tokenId) {
        address owner = _tokenOwners[_tokenId];

        if(
            (_addr == owner) ||
            (_addr == getApproved(_tokenId)) ||
            isApprovedForAll(owner, _addr)
        ) {
            _;
        } else {
            revert Unauthorized("You do not have rights to perform this transfer");
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
        address owner = _tokenOwners[_tokenId];

        require(owner != address(0)); // address must not be the zero address

        return owner;
    }

    /**
     * @notice approve a particular address to access owner's NFT
     * @dev throws if `msg.sender` isn't an operator or the owner of the NFT
     * @param _approved address to be approved
     * @param _tokenId the NFT identifier
     */
    function approve(address _approved, uint256 _tokenId) public payable notZeroAddr(_approved) {
        address owner = _tokenOwners[_tokenId];

        require(_approved != owner); // owner can't be added as an approved address
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender)); // only owner and operators can approve addresses

        _tokenApprovals[_tokenId] = _approved;

        emit Approval(owner, _approved, _tokenId); // emit event
    }

    /**
     * @notice add an operator
     * @dev throws if operator is a zero account
     * @param _operator address to be added as an operator
     * @param _approved boolean value to define whether the operator is approved or not
     */
    function setApprovalForAll(address _operator, bool _approved) public notZeroAddr(_operator) {
        
        require(_operator != msg.sender); // owner cannot be an operator
        _operatorsApprovals[msg.sender][_operator] = _approved;

        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    /**
     * @notice safe transfer ownership of NFT
     * @dev throws if `_from` isn't an approved address or if `_to` is a zero address
     * @param _from initial owner's address
     * @param _to new owner's address
     * @param _tokenId NFT identifier
     * @param _data optional data of any size or type
     */
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) 
        public notZeroAddr(_from) notZeroAddr(_to) payable {
            safeTransferFrom(_from, _to, _tokenId);

            require(_performSafeTransfer(_from, _to, _tokenId, _data));
    }

    /**
     * @notice safe transfer ownership of NFT
     * @dev throws if `_from` isn't an approved address or if `_to` is a zero address
     * @param _from initial owner's address
     * @param _to new owner's address
     * @param _tokenId NFT identifier
     */
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
        public notZeroAddr(_from) notZeroAddr(_to) payable {
            transferFrom(_from, _to, _tokenId);
    }

    /**
     * @notice transfer ownership of NFT
     * @dev throws if `_from` isn't an approved address or if `_to` is a zero address
     * @param _from initial owner's address
     * @param _to new owner's address
     * @param _tokenId NFT identifier
     */
    function transferFrom(address _from, address _to, uint256 _tokenId) public payable 
        isOwnerOrApproved(_from, _tokenId) notZeroAddr(_to) {
            _clearApprovals(_from, _tokenId); // clear approvals
            _removeTokenFrom(_from, _tokenId); // clear ownership
            _addTokenTo(_to, _tokenId); // update ownership

            emit Transfer(_from, _to, _tokenId); // emit event
    }

    function _burn(address _owner, uint256 _tokenId) internal notZeroAddr(_owner) {
        _clearApprovals(_owner, _tokenId);
        _removeTokenFrom(_owner, _tokenId);

        emit Transfer(_owner, address(0), _tokenId);
    }

    /**
     * @notice clear the token ownership
     * @dev throws if `_owner1 isn't the owner of the NFT
     * @param _owner the owner's address
     * @param _tokenId the idenfitier of the NFT
     */
    function _removeTokenFrom(address _owner, uint256 _tokenId) private isTokenOwner(_owner, _tokenId) {
        if(_tokenOwners[_tokenId] != address(0)) {
            delete _tokenOwners[_tokenId]; // reset to address(0)
            _ownedTokensCount[_owner] -= 1; // decrease number of tokens owned by owner
        }
    }

    /**
     * @notice mint new NFTs
     * @param _to owner's address
     * @param _tokenId the unique iD of the NFT
     */
    function _mint(address _to, uint256 _tokenId) internal notZeroAddr(_to) {
        _clearApprovals(_to, _tokenId);
        _addTokenTo(_to, _tokenId);
        
        emit Transfer(address(0), _to, _tokenId); // emit
    }

    /**
     * @notice clear the token approval for the given owner with `_owner` address
     * @dev throws if `_owner` isn't the owner of the NFT
     * @param _owner the owner's address
     * @param _tokenId the identifier of the NFT
     */
    function _clearApprovals(address _owner, uint256 _tokenId) private isTokenOwner(_owner, _tokenId) {
        if(_tokenApprovals[_tokenId] != address(0)) {
            delete _tokenApprovals[_tokenId]; // reset to address(0)
        }
    }

    /**
     * @dev update NFT ownership
     * @param _to new owner's address
     * @param _tokenId NFT token identifier
     */
    function _addTokenTo(address _to, uint256 _tokenId) private notZeroAddr(_to) {
        require(_tokenOwners[_tokenId] == address(0));
        _tokenOwners[_tokenId] = _to;
        _ownedTokensCount[_to] += 1; // this is checked which means it throws when it overflows or underflows
    }

    /**
     * @notice check if `_to` is a contract and call appropriate callback function
     * @param _from initial NFT owner
     * @param _to new owner
     * @param _tokenId NFT token identifier
     * @param _data optional extra data
     */

    function _performSafeTransfer(address _from, address _to, uint256 _tokenId, bytes memory _data) private returns (bool) {
        if(_to.isAContract()) {
            bytes4 receipt = IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);

            return (receipt == _ERC721_RECEIVED); 
        }

        return true;
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
        return _tokenApprovals[_tokenId];
    }

}