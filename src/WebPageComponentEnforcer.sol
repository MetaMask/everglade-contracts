// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import { CaveatEnforcer } from "../CaveatEnforcer.sol";
import { Action } from "../utils/Types.sol";

/**
 * @title Uint256FirstParamEnforcer
 * @dev This contract enforces that the first parameter (uint256 identifier) in the Action transaction matches the value specified in the terms.
 */
contract Uint256FirstParamEnforcer is CaveatEnforcer {
    /**
     * @notice Enforces that the first parameter (uint256 identifier) in the Action transaction matches the value specified in the terms.
     * @dev This function enforces the term before the transaction is performed.
     * @param terms The uint256 value that the first parameter of the transaction must match.
     * @param transaction The transaction the delegate might try to perform.
     * @return A boolean value indicating whether the enforcement was successful.
     */
    function enforceBefore(bytes calldata terms, Action calldata transaction, bytes32) public pure override returns (bool) {
        uint256 termValue = getTermsValue(terms);
        uint256 transactionIdentifier = getTransactionFirstUint256(transaction.data);

        require(transactionIdentifier == termValue, "Uint256FirstParamEnforcer:identifier-mismatch");
        return true;
    }

    function getTermsValue(bytes calldata terms) public pure returns (uint256 value) {
        require(terms.length == 32, "invalid terms length");
        return abi.decode(terms, (uint256));
    }

    function getTransactionFirstUint256(bytes calldata transactionData) public pure returns (uint256 identifier) {
        require(transactionData.length >= 36, "invalid transaction data length");
        // The first 4 bytes are the method identifier, the next 32 bytes represent the first uint256 parameter
        return abi.decode(transactionData[4:36], (uint256));
    }
}
