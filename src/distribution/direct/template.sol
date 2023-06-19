// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDistributionStrategy} from "../../../lib/allo-v2/contracts/core/interfaces/IDistributionStrategy.sol";

contract DirectGrantsDistributionStrategy is IDistributionStrategy {
    // NOTE: Should support multicall using OZ's Multicall2

    uint256 poolId;
    address allo;
    // todo: should we name this poolOwner?
    address strategyOwner;

    uint64 applicationStart;
    uint64 applicationEnd;
    uint64 votingStart;
    uint64 votingEnd;

    enum ApplicationStatus {
        None,
        Pending,
        Accepted,
        Rejected
        // Reapplied @discuss: How do we add new status
    }

    constructor(address _strategyOwner) {
        // set common params
        //  - poolId
        //  - allo
        strategyOwner = _strategyOwner;
        // parameters required for Direct
        //  - applicationStart
        //  - applicationEnd
        // optional paramers for application gating
        // - EAS contract / registry contract/ POH contract address
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
