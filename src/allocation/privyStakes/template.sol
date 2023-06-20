// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAllocationStrategy} from "../../../lib/allo-v2/contracts/core/interfaces/IAllocationStrategy.sol";
import {Initializable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {EnumerableMap} from "openzeppelin-contracts/contracts/utils/structs/EnumerableMap.sol";
import {MetaPtr} from "../../../lib/allo-v2/contracts/utils/MetaPtr.sol";

contract PrivyStakesAllocationStrategy is IAllocationStrategy, Initializable {
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

    function initialize(bytes calldata encodedParameters) external initializer {
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
    }

    function owner() public view returns (address) {
        // returns pool owner by query allo contract
    }

    modifier isPoolOwner(address sender) {
        require(
            sender == owner(),
            "PrivyStakesAllocationStrategy: Only pool owner can call this function"
        );
        _;
    }

    function applyToPool(
        bytes memory _data,
        address sender
    ) external payable override isPoolOwner(sender) returns (bytes memory) {
        // decode data to get
        //  - identityId
        //  - applicationMetaPtr
        //  - recipientAddress
        address[] memory identityIds = abi.decode(_data, (address[]));

        for (uint i = 0; i < identityIds.length; i++) {
            // get application from applications mapping
            // check if application milestone is accepted (lookup applications mapping)
            // update application to status to ALLOCATED and make payment
            // emit event
        }
        // NOTE: custom logic if we wanted to gate applications based on EAS / registry check

        // set application status to pending or reapplied
        // add / update applications mapping

        return _data;
    }

    function getApplicationStatus(
        bytes memory _data
    ) external view returns (ApplicationStatus) {
        // decode data to get identityId
        address identityId = abi.decode(_data, (address));

        // return application status from applications mapping
        return applications[identityId].status;
    }

    function allocate(
        bytes memory _data,
        address sender
    ) external payable returns (uint) {
        // decode data to get identityId, amount
        // check application status
        // check if allocator is valid
        // check if allocator has enough votes (rely on votesCasted and votesPerAllocator)
        // add allocation to allocation tracker
        // add allocation to total allocations
    }

    function generatePayouts() external payable returns (bytes memory) {
        // uses allocationTracker as input
        // loop through allocationTracker and generate payouts
        // calc (allocationTracker.at(index) * 100) / totalAllocations
    }

    // -- CUSTOM Variables

    // identityId => allocationAmount
    EnumerableMap.AddressToUintMap private _allocationTracker;
    uint256 private _totalAllocations;

    struct Application {
        address identityId;
        address recipientAddress;
        ApplicationStatus status;
        MetaPtr metaPtr;
    }

    // create a mapping of applicationId to application status
    mapping(address => Application) public applications;

    // some means to track votes casted
    mapping(address => uint32) public votesCastByUser;

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
