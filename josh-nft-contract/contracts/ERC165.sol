// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./IERC165.sol";

contract ERC165 is IERC165 {

    /// @notice ERC165 interfaceId
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    /// @notice map supported function signatures to bool signifying if they're supported or not
    mapping(bytes4 => bool) supportedInterfaces_;

    constructor() {
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    /**
     * @notice register supported interfaceId
     * @dev throws if `_sig` is `0xffffffff`
     * @param _sig the interfaceId
     */
    function _registerInterface(bytes4 _sig) internal {
        require(_sig != 0xffffffff);
        supportedInterfaces_[_sig] = true;
    }

    /**
     * @notice check if the `_interfaceID` is supported
     * @param _interfaceID the interfaceId to check
     * @return returns `true` if supported otherwise `false`
     */
    function supportsInterface(bytes4 _interfaceID) public view returns (bool) {
        return supportedInterfaces_[_interfaceID];
    }
}