// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDistributionStrategy} from "../../../lib/allo-v2/contracts/core/interfaces/IDistributionStrategy.sol";


contract DirectGrantsDistributionStrategy is IDistributionStrategy, Initializable {
    // NOTE: Should support multicall using OZ's Multicall2
    error NotUsed();

    uint256 poolId;
    address allo;
    // todo: should we name this poolOwner?
    address strategyOwner;

    function initialize(bytes calldata _data) external initializer {
        // set common params
        //  - poolId
        //  - allo
        //  - token
    }

    // call to allo() and query rounds[roundId].owner
    function owner() external view returns (address);

    // will be responsible for doing the actual payouts based on the data passed
    // The _data would be fed in from the allocation strategy via the generatePayout function
    // Can be called only be the user
    function activateDistribution(bytes memory _data) public override {
        // decode data to get the recipients and amounts
        (address token, address[] memory recipients, uint256[] memory amounts) = abi.decode(
            _data,
            (address, address[], uint256[])
        );
        // Send the tokens to the recipients.
        // todo: add custom options for token types. i.e. ETH, ERC20, ERC721, ERC1155
        for (uint256 i = 0; i < recipients.length; i++) {
            (bool success, ) = recipients[i].call{value: amounts[i]}("");
            require(success, "DirectGrantsDistributionStrategy: Transfer failed.");
        }
    }

    function claim(bytes memory /* _data */) public pure override {
        // Not used in this strategy.
        revert NotUsed();
    }
}
