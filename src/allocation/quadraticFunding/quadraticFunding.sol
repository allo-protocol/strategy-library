// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract qfAllocationStrategy is IAllocationStrategy {

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


    constructor() {
        // set common params
        //  - poolId
        //  - allo

        // parameters required for QF
        //  - applicationStart
        //  - applicationEnd
        //  - allocationStart
        //  - allocationEnd

        // optional paramers for application or allocation gating
        // - EAS contract / registry contract/ POH contract address
    }

    function owner() external view returns (address) {
        // returns pool owner by query allo contract
    }


    function applyToPool(bytes memory _data) external payable returns (bytes memory) {
        // decode data to get 
        //  - project Id 
        //  - applicationMetaPtr
        // NOTE: custom logic if we wanted to gate applications based on EAS / registry check 
        
        // set application status to pending
    }

    function getApplicationStatus(bytes memory _data) external view returns (ApplicationStatus) {
        // decode data to get application id
        // return application status from mapping
    }

    function allocate(bytes memory _data) external payable returns (uint) {
        // decode data to get application, amount, token
        // check application status
        // transfer tokens to project payout address
    }


    function generatePayouts() external payable returns (bytes memory) {
        // returns applicationPayouts
    }

    // -- CUSTOM Variables
    
    // create a mapping of application id to application status 
    mapping (bytes32 => ApplicationStatus) applicationStatuses;

    // payouts data which will be set using setPayouts
    mapping (bytes32 => uint32) applicationPayouts;


    // -- CUSTOM FUNCTIONS
    function updateVotingStart(uint64 _votingStart) external {}
    function updateVotingEnd(uint64 _votingEnd) external {}
    function updateApplicationStart(uint64 _applicationStart) external {}
    function updateApplicationEnd(uint64 _applicationEnd) external {}
    function setPayouts(bytes memory _data) external isPoolOwner(){
        // sets project to percentage ratio
        // would be invoked by pool owner for off-chain logic
    }

}