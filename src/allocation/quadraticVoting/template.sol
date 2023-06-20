// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAllocationStrategy} from "../../../lib/allo-v2/contracts/core/interfaces/IAllocationStrategy.sol";
import {Initializable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {EnumerableMap} from "openzeppelin-contracts/contracts/utils/structs/EnumerableMap.sol";
import {MetaPtr} from "../../../lib/allo-v2/contracts/utils/MetaPtr.sol";

contract QVAllocationStrategy is IAllocationStrategy, Initializable {
    // NOTE: Should support multicall using OZ's Multicall2

    uint256 public poolId;
    address public allo;

    uint64 public applicationStart;
    uint64 public applicationEnd;
    uint64 public votingStart;
    uint64 public votingEnd;

    enum ApplicationStatus {
        None,
        Pending,
        Accepted,
        Rejected
        // Reapplied @discuss: How do we add new status
    }

    function initialize(bytes calldata encodedParameters) external initializer {
        // set common params
        //  - poolId
        //  - allo
        // parameters required for QF
        //  - applicationStart
        //  - applicationEnd
        //  - allocationStart
        //  - allocationEnd
        //  - votesPerAllocator
        // optional paramers for application or allocation gating
        // - EAS contract / registry contract/ POH contract address
    }

    function owner() external view returns (address) {
        // returns pool owner by query allo contract
    }

    function applyToPool(
        bytes memory _data,
        address sender
    ) external payable override returns (bytes memory) {
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
        (address identityId) = abi.decode(_data, (address));

        // return application status from applications mapping
        return applications[identityId].status;
    }

    function allocate(
        bytes memory _data,
        address sender
    ) external payable returns (uint) {
        // decode data to get identityId, amount, token
        // check application status
        // check if allocator is valid by looking up voteCounter and is less than votesPerAllocator
        // check if allocator has enough votes (rely on votesCasted and votesPerAllocator)
        // update votesReceived on applications mapping
    }

    function generatePayouts() external payable returns (bytes memory) {
        // uses votesReceived from applications as input to run the QV math to generate payout
        // uses allocationTracker as input
        // loop through allocationTracker and generate payouts
        // calc using QV math
    }

    // -- CUSTOM Variables

    struct Application {
        address identityId;
        address recipientAddress;
        ApplicationStatus status;
        MetaPtr metaPtr;
        uint32 votesReceived;
    }

    // create a mapping of applicationId to application status
    mapping(address => Application) applications;

    // some means to track votes casted by user
    mapping(address => uint32) voteCounter;

    // identityId => allocationAmount
    EnumerableMap.AddressToUintMap private allocationTracker;
    uint256 totalAllocations;

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
