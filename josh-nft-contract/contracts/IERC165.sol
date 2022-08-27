// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

/**
 * @title ERC165 Interface
 */
interface IERC165 {
    /**
     * @notice queries if a contract supports an interface
     * @dev Interface identification is specified in ERC-165. This function uses less than 30,000 gas.
     * @param _interfaceID Interface identifier as specified in ERC-165
     * @return `true` if the contract implements `_interfaceID` and `_interfaceID` is not 0xffffffff, `false` otherwise
     */
    function supportsInterface(bytes4 _interfaceID) external view returns (bool);
}