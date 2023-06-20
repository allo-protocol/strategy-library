// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IAllocationStrategy} from "../../../../lib/allo-v2/contracts/core/interfaces/IAllocationStrategy.sol";

/// @title DirectOwnerPaysMilestone
/// @notice This contract implements the core allocation strategy for a given distribution strategy.
/// @dev This contract is meant to be used as an example for running a committee vote strategy.
contract CommitteeVote is IAllocationStrategy {
    // NOTE: Should support multicall using OZ's Multicall2

    // The id of the Pool contract that this strategy is going to use.
    // NOTE: how are we going to use the pool id?
    uint256 pool;
    // todo: should we name this poolOwner?
    address strategyOwner;

    uint64 applicationStart;
    uint64 applicationEnd;

    enum ApplicationStatus {
        None,
        Pending,
        Accepted,
        Rejected
        // Reapplied @discuss: How do we add new status?
    }

    // mapping(uint256 => Pool) public pools;

    // NOTE: do we need the application metadata here?
    struct Application {
        bytes32 id;
        address applicant;
        ApplicationStatus status;
    }

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

    event MilestoneCreated(
        bytes32 indexed id,
        uint256 amount,
        address indexed recipient
    );
    event MilestoneSubmitted(
        bytes32 indexed id,
        uint256 amount,
        address indexed recipient
    );
    event MilestoneStatusSet(bytes32 indexed id, MilestoneStatus status);

    // Constructor
    constructor() {
        strategyOwner = msg.sender;
    }

    function owner() public view override returns (address) {
        return strategyOwner;
    }

    function getApplicationStatus(
        bytes memory _data
    ) external view returns (ApplicationStatus) {
        // decode data to get application id
        // return application status from mapping
    }

    mapping(address => Application) public applications;

    // NOTE: what do we want the _data to be?
    function applyToPool(
        bytes memory _data
    ) external payable override returns (bytes memory) {
        // NOTE: logic if we wanted to gate applications based on EAS / registry check
        // NOTE: logic to check milestone status?
        // set application status to pending
        return _data;
    }

    function allocate(
        bytes memory _data
    ) external payable override returns (uint) {
        (, uint amount) = abi.decode(_data, (address, uint));

        return amount;
    }

    // NOTE: This was added for ease of fron-end integration.
    function isPayoutGenerateable() external pure returns (bool) {
        return false;
    }

    // NOTE: This was added for ease of fron-end integration.
    function isClaimable() external pure returns (bool) {
        return false;
    }

    // NOTE: This will not be used in a direct grants strategy, no distribution strategy will be implemented.
    function generatePayouts()
        external
        payable
        override
        returns (bytes memory)
    {
        bytes memory data = "";

        return data;
    }

    // Custom logic

    enum MilestoneStatus {
        Valid,
        Paid,
        Pending,
        Voted,
        Rejected,
        Accepted
    }

    struct Milestone {
        bytes32 id;
        bytes32 applicationId;
        uint256 amount;
        uint256 votes;
        address recipient;
        MilestoneStatus status;
    }

    // milestone id to milestone
    mapping(bytes32 => Milestone) public milestones;
    // user to votes cast by that user
    mapping(address => uint32) public votesCastByUser;

    function reviewApplications(bytes[] memory _data) external {
        // NOTE: toggle application status based on _data values
        if (_data.length == 0) {
            revert("No applications to review");
        }

        for (uint i = 0; i < _data.length; i++) {
            (address applicant, ApplicationStatus status) = abi.decode(
                _data[i],
                (address, ApplicationStatus)
            );
            if (status == ApplicationStatus.Accepted) {
                revert("Application already accepted");
            }
            Application storage application = applications[applicant];
            application.status = status;

            emit ApplicationStatusSet(
                application.id,
                application.applicant,
                status
            );
        }
    }

    // when a user submits a milestone for payout, we will check if the milestone has been approved/accepted
    function submitMilestone(
        bytes32 _id,
        address _applicant,
        uint256 _amount,
        address _recipient
    ) external payable returns (bytes memory) {
        Milestone storage milestone = milestones[_id];
        Application storage application = applications[_applicant];

        // make sure the application is accepted, otherwise revert
        if (application.status != ApplicationStatus.Accepted) {
            revert("Milestone can only be submitted for accepted applications");
        }

        // set the status of the milestone to pending
        milestone.status = MilestoneStatus.Pending;
        milestone.amount = _amount;
        milestone.recipient = _recipient;

        emit MilestoneSubmitted(_id, _amount, _recipient);

        // NOTE: not sure what to return here?
        return "";
    }

    // used to set the staus of a milestone
    function setMilestoneStatus(bytes32 _id, MilestoneStatus _status) external {
        // NOTE: custom logic to check milestone status
        Milestone storage milestone = milestones[_id];
        milestone.status = _status;

        emit MilestoneStatusSet(_id, _status);
    }
}
