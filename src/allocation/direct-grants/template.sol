// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IAllocationStrategy} from "../../../../lib/allo-v2/contracts/core/interfaces/IAllocationStrategy.sol";

/// @title DirectGrants
/// @notice This contract implements the core allocation strategy.
/// @dev This contract is meant to be used as an example for running a committee vote strategy.
contract DirectGrants is IAllocationStrategy, Initializable {
    // NOTE: Should support multicall using OZ's Multicall2

    // The id of the Pool contract that this strategy is going to use.
    // NOTE: how are we going to use the pool id?
    uint256 pool;
    uint64 applicationStart;
    uint64 applicationEnd;
    

    modifier isCommitteeOwner() {
       // check if msgs.sender is committee owner
        _;
    }

    enum ApplicationStatus {
        None,
        Pending,
        Accepted,
        Rejected
        // Reapplied @discuss: How do we add new status?
    }

    // NOTE: do we need the application metadata here?
    struct Application {
        bytes32 id;
        address applicant;
        ApplicationStatus status;
    }

    // Constructor
    function initialize(bytes calldata encodedParameters  ) external initializer {
        strategyOwner = msg.sender;
    }

    function owner() public view override returns (address) {
        return strategyOwner;
    }

    function getApplicationStatus(bytes memory _data) external view returns (ApplicationStatus) {
        // decode data to get application id
        // return application status from mapping
    }

    mapping(address => Application) public applications;

    function applyToPool(bytes memory _data) external payable override {
        // decode data to get application
        // NOTE: logic if we wanted to gate applications based on EAS / registry check
        // set application status to pending
        // emit event
    }

    // can be invoked only commitee
    function allocate(
        bytes memory _data
    ) external payable override returns (uint) {
        (, uint amount) = abi.decode(_data, (address, uint));

        return amount;
    }

    // NOTE: This will not be used in a direct grants strategy, no distribution strategy will be implemented.
    function generatePayouts() external payable override returns (bytes memory) {
        revert();
    }


    // -- CUSTOM Events    
    event ApplicationSubmitted(bytes32 indexed id, address indexed applicant, ApplicationStatus status);
    event ApplicationStatusSet(bytes32 indexed id, address indexed applicant, ApplicationStatus status);
    event MilestoneSubmitted(bytes32 indexed id, uint256 amount, address indexed recipient);
    event MilestoneStatusSet(bytes32 indexed id, MilestoneStatus status);

    // -- CUSTOM Variables
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

    function isClaimable() external pure returns (bool) {
        // To show that this strategy is not claimable
        return false;
    }

    function reviewApplications(bytes[] memory _data) external {
        // decode _date to get applications
        // toggle application status 
        // possible: prevent application 
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

    // used to set the status of a milestone
    function setMilestoneStatus(bytes32 _id, MilestoneStatus _status) external isCommitteeOwner {
        // NOTE: custom logic to check milestone status
        Milestone storage milestone = milestones[_id];
        milestone.status = _status;

        emit MilestoneStatusSet(_id, _status);
    }
}
