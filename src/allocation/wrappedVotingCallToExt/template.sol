// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAllocationStrategy} from "../../../lib/allo-v2/contracts/core/interfaces/IAllocationStrategy.sol";

contract WrappedVotingCallToExt is IAllocationStrategy, Initializable {
    // NOTE: Should support multicall using OZ's Multicall2
    using EnumerableMap for EnumerableMap.AddressToUintMap;

    uint256 poolId;
    address allo;

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

    function initialize(bytes calldata encodedParameters  ) external initializer {
        // set common params
        //  - poolId
        //  - allo
        // parameters required
        //  - applicationStart
        //  - applicationEnd
        //  - allocationStart
        //  - allocationEnd
        //  - votesPerAllocator
        //  - allowed list of voters
        //  - address of contract to call
    }

    function owner() external view returns (address) {
        // returns pool owner by query allo contract
    }

    function applyToPool(
        bytes memory _data,
        address sender
    ) external payable returns (bytes memory) {
        // decode data to get
        //  - identityId
        //  - applicationMetaPtr
        //  - recipientAddress

        // NOTE: custom logic if we wanted to gate applications based on EAS / registry check
 
        // set application status to pending or reapplied
        // add / update applications mapping
    }

    function getApplicationStatus(
        bytes memory _data
    ) external view returns (ApplicationStatus) {
        // decode data to get identityId
        // return application status from applications mapping
    }

    function allocate(bytes memory _data, address sender) external payable returns (uint) {
        // external contract needs to implement beforeAllocate and afterAllocate
        externalContract.beforeAllocate(_data, sender);

        // decode data to get identityId, amount
        // check application status
        // check if allocator is valid
        // check if allocator has enough votes (check voteCounter <= votesPerAllocator)
        // add allocation to allocation tracker
        // add allocation to total allocations

        externalContract.afterAllocate(_data, sender);
    }

    function generatePayouts() external payable returns (bytes memory) {
        // uses allocationTracker as input
        // loop through allocationTracker and generate payouts
        // calc (allocationTracker.at(index) * 100) / totalAllocations
    }

    // -- CUSTOM Variables

    // external contract to call
    address externalContract;

    // identityId => allocationAmount
    EnumerableMap.AddressToUintMap private allocationTracker;
    uint256 totalAllocations;

    struct Application {
        address identityId;
        ApplicationStatus status;
        MetaPtr metaPtr;
    }

    // create a mapping of applicationId to application status
    mapping(address => Application) applications;

    // some means to track votes casted by user
    mapping(address => uint32) voteCounter;

    // -- CUSTOM FUNCTIONS
    function updateVotingStart(uint64 _votingStart) external {}

    function updateVotingEnd(uint64 _votingEnd) external {}

    function updateApplicationStart(uint64 _applicationStart) external {}

    function updateApplicationEnd(uint64 _applicationEnd) external {}

    function reviewApplications(bytes[] memory _data) external {
        // decode data to get identity id and status
        // update application status
    }
}
