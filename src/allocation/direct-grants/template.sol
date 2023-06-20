// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IAllocationStrategy} from "../../../lib/allo-v2/contracts/core/interfaces/IAllocationStrategy.sol";
import {Initializable} from "../../../lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {MetaPtr} from "../../../lib/allo-v2/contracts/utils/MetaPtr.sol";

/// @title DirectGrants
/// @notice This contract implements the core allocation strategy.
/// @dev This contract is meant to be used as an example for running a committee vote strategy.
contract DirectGrants is IAllocationStrategy, Initializable {
    // NOTE: Should support multicall using OZ's Multicall2

    // The id of the Pool contract that this strategy is going to use.
    // NOTE: how are we going to use the pool id?
    uint256 public pool;

    modifier isPoolOwner(address sender) {
        // query IAllo contract to get pool owner
        _;
    }

    enum ApplicationStatus {
        None,
        Pending,
        Accepted,
        Rejected,
        Allocated // How do we add new status ?
    }

    // initialize
    function initialize(bytes calldata encodedParameters) external initializer {
        // set common params
        //  - poolId
        //  - allo
        // parameters required for direct grants
        // optional paramers for application or allocation gating
        // - EAS contract / registry contract/ POH contract address
    }

    // call to allo() and query pools[poolId].owner
    function owner() external view override returns (address) {
        // returns pool owner by query allo contract
    }

    function getApplicationStatus(
        bytes memory _data
    ) external view returns (ApplicationStatus) {
        // decode data to get identityId
        (address identityId, uint32 index) = abi.decode(
            _data,
            (address, uint32)
        );

        // return application status from applications mapping
        return applications[identityId][index].status;
    }

    function applyToPool(
        bytes memory _data,
        address sender
    ) external payable override returns (bytes memory) {
        // NOTE: logic if we wanted to gate applications based on EAS / registry check
        // decode data to create Application struct with status pending
        // add it to applications mapping
        // emit event
    }

    function allocate(
        bytes memory _data,
        address sender
    ) external payable override isPoolOwner(sender) returns (uint) {
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

        // check if application milestone is accepted (lookup applications mapping)
        // update application to status to ALLOCATED and make payment
        // emit event
        return 1;
    }

    // NOTE: This will not be used in a direct grants strategy, no distribution strategy will be implemented.
    function generatePayouts()
        external
        payable
        override
        returns (bytes memory)
    {
        revert();
    }

    // -- CUSTOM Events
    event ApplicationSubmitted(
        bytes32 indexed id,
        address indexed applicant,
        ApplicationStatus status
    );
    event ApplicationStatusSet(
        bytes32 indexed id,
        address indexed applicant,
        ApplicationStatus status
    );

    // -- CUSTOM Variables

    struct MilestoneApplication {
        MetaPtr metaPtr;
        address identityId;
        address recipientAddress;
        uint256 requestedAmount; // uint256 amountPaid => set by pool owner
        ApplicationStatus status;
    }

    // stores mapping from identityId -> MilestoneApplication
    mapping(address => MilestoneApplication[]) public applications;

    // -- CUSTOM Functions

    function isClaimable() external pure returns (bool) {
        // To show that this strategy is not claimable
        return false;
    }

    function reviewApplications(bytes[] memory _data) external {
        // decode data to get list of
        //  - identityId
        //  - index of application (to know which milestone)
        //  - status

        // update application status in applications mapping
        for (uint i = 0; i < _data.length; i++) {
            (address identityId, uint32 indexes, ApplicationStatus status) = abi
                .decode(_data[i], (address, uint32, ApplicationStatus));

            applications[identityId][indexes].status = status;
        }
    }
}
