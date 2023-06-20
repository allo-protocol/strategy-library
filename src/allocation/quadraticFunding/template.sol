// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAllocationStrategy} from "../../../lib/allo-v2/contracts/core/interfaces/IAllocationStrategy.sol";
import {Initializable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {EnumerableMap} from "openzeppelin-contracts/contracts/utils/structs/EnumerableMap.sol";
import {MetaPtr} from "../../../lib/allo-v2/contracts/utils/MetaPtr.sol";

contract QFAllocationStrategy is IAllocationStrategy, Initializable {
    // NOTE: Should support multicall using OZ's Multicall2
    using EnumerableMap for EnumerableMap.AddressToUintMap;

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

    // call to allo() and query pools[poolId].owner
    function owner() external view override returns (address) {
        // returns pool owner by query allo contract
    }

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
        // return application status from applications mapping
    }

    function allocate(
        bytes memory _data,
        address sender
    ) external payable override returns (uint) {
        // decode data to get identityId, amount, token
        // decode data to get list of
        //  - identityId
        //  - index of application (to know which milestone)
        address[] memory identityIds = abi.decode(_data, (address[]));

        for (uint i = 0; i < identityIds.length; i++) {
            // get application from applications mapping
            // check if application milestone is accepted (lookup applications mapping)
            // update application to status to ALLOCATED and make payment
            // emit event
        }

        // check application status from applications mapping
        // add allocation to allocation tracker
        // add allocation to total allocations
        // transfer tokens to project payout address

        // emit event
        return 1;
    }

    function generatePayouts() external payable returns (bytes memory) {
        // returns payouts
    }

    // -- CUSTOM Variables

    // identityId => allocationAmount
    EnumerableMap.AddressToUintMap private _allocationTracker;
    uint256 public totalAllocations;

    // create a mapping of IdentityId to application status
    struct Application {
        address identityId;
        address recipientAddress;
        ApplicationStatus status;
        MetaPtr metaPtr;
    }

    // create a mapping of applicationId to application status
    mapping(address => Application) public applications;

    // payouts data which will be set using setPayouts
    struct Payout {
        address recipientAddress;
        uint32 percentage;
    }

    Payout[] public payouts;

    // -- CUSTOM FUNCTIONS
    modifier isPoolOwner(address sender) {
        // query IAllo contract to get pool owner
        _;
    }

    function updateVotingStart(uint64 _votingStart) external {}

    function updateVotingEnd(uint64 _votingEnd) external {}

    function updateApplicationStart(uint64 _applicationStart) external {}

    function updateApplicationEnd(uint64 _applicationEnd) external {}

    function reviewApplications(bytes[] memory _data) external {
        // decode data to get identity id and status
        // update application status
    }

    function setPayouts(
        bytes memory _data,
        address sender
    ) external isPoolOwner(sender) {
        // TODO: discuss if this should be on distribution strategy
        // populate payouts array using allocationTracker and totalAllocations
        // would be invoked by pool owner for off-chain logic
    }
}
