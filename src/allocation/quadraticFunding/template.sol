// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAllocationStrategy} from "../../../lib/allo-v2/contracts/core/interfaces/IAllocationStrategy.sol";

contract QFAllocationStrategy is IAllocationStrategy, Initializable {
    // NOTE: Should support multicall using OZ's Multicall2

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

    // call to allo() and query pools[poolId].owner
    function owner() external view returns (address);

    function initialize(bytes calldata encodedParameters) external initializer {
        // set common params
        //  - poolId
        //  - allo
        //  - owner
        // parameters required for QF
        //  - applicationStart
        //  - applicationEnd
        //  - allocationStart
        //  - allocationEnd
        // optional paramers for application or allocation gating
        // - EAS contract / registry contract/ POH contract address
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

    function allocate(
        bytes memory _data,
        address sender
    ) external payable returns (uint) {
        // decode data to get identityId, amount, token
        // check application status from applications mapping
        // transfer tokens to project payout address
    }

    function generatePayouts() external payable returns (bytes memory) {
        // returns payouts
    }

    // -- CUSTOM Variables

    // create a mapping of IdentityId to application status
    struct Application {
        address identityId;
        address recipientAddress;
        ApplicationStatus status;
        MetaPtr metaPtr;
    }

    // create a mapping of applicationId to application status
    mapping(address => Application) applications;

    // payouts data which will be set using setPayouts
    struct Payout {
        address recipientAddress;
        uint32 percentage;
    }

    Payouts[] public payouts;

    // -- CUSTOM FUNCTIONS
    function updateVotingStart(uint64 _votingStart) external {}

    function updateVotingEnd(uint64 _votingEnd) external {}

    function updateApplicationStart(uint64 _applicationStart) external {}

    function updateApplicationEnd(uint64 _applicationEnd) external {}
 
    function reviewApplications(bytes[] memory _data) external {
        // decode data to get identity id and status
        // update application status
    }

    function setPayouts(bytes memory _data) external isPoolOwner {
        // TODO: discuss if this should be on distribution strategy
        // populate payouts array
        // would be invoked by pool owner for off-chain logic
    }
}
