// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

/**
 * @notice Utility function
 */
library Address {
    /**
     @notice checks if an address points to a contract or EOA
     @param _self the address to check
     @return `true` if it is or `false` if it isn't
     */
    isAContract(address _self) view returns (bool) {
        uint256 size;

        assembly {
            size := extcodesize(_self);
        }

        return size > 0;
    }
}