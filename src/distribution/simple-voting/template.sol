// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IDistributionStrategy} from "../../../lib/allo-v2/contracts/core/interfaces/IDistributionStrategy.sol";

contract SimpleVoting is IDistributionStrategy {
    // State variables
    address public strategyOwner;
    
    constructor(address _strategyOwner) {
        strategyOwner = _strategyOwner;
    }

    function owner() public view override returns (address) {
        return strategyOwner;
    }

    function activateDistribution(bytes memory _data) public override {
        // Implement the function here, including decoding _data and activating distribution.
    }

    function claim(bytes memory _data) public override {
        // Implement the function here, including decoding _data and claiming a payout.
    }
}
