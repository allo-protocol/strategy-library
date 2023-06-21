// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDistributionStrategy} from "../../../lib/allo-v2/contracts/core/interfaces/IDistributionStrategy.sol";
import {Initializable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {EnumerableMap} from "openzeppelin-contracts/contracts/utils/structs/EnumerableMap.sol";
import {MetaPtr} from "../../../lib/allo-v2/contracts/utils/MetaPtr.sol";

error NotUsed();

contract DirectGrantsDistributionStrategy is
    IDistributionStrategy,
    Initializable
{
    // NOTE: Should support multicall using OZ's Multicall2

    uint256 poolId;
    address allo;
    address token;

    constructor() {
        _disableInitializers();
    }

    function initialize(bytes calldata encodedParameters) external initializer {
        // set common params
        // - poolId
    }

    function owner() public view override returns (address) {
        // returns pool owner by query allo contract
    }

    // NOTE: defaults to send ETH to recipients
    function activateDistribution(bytes memory _data) public override {
        // decode data to get the recipients and amounts
        (address[] memory recipients, uint256[] memory amounts) = abi.decode(
            _data,
            (address[], uint256[])
        );
        // Send the tokens to the recipients.
        // todo: add custom options for token types. i.e. ETH, ERC20, ERC721, ERC1155
        for (uint256 i = 0; i < recipients.length; i++) {
            (bool success, ) = recipients[i].call{value: amounts[i]}("");
            require(
                success,
                "DirectGrantsDistributionStrategy: Transfer failed."
            );
        }
    }

    function claim(bytes memory /* _data */) public pure override {
        // Not used in this strategy.
        revert NotUsed();
    }

    // Custom functions

    // todo: this will be for when we use ERC20 options, not ETH
    function setToken(address _token) public {
        token = _token;
    }
}
