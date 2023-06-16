// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IAllocationStrategy} from "../../../lib/allo-v2/contracts/core/interfaces/IAllocationStrategy.sol";
// todo: update name in v2-contracts repo
import {Metadata} from "../../../lib/allo-v2/contracts/core/libraries/Metadata.sol";

/// @title AllPayAuction
/// @notice This contract implements an allocation strategy for a given distribution strategy.
/// @dev This contract is meant to be used as an example for running an all-pay auction.
contract AllPayAuction is IAllocationStrategy {
    // State variables
    address public strategyOwner;
    address public distributionStrategy;

    address public highestBidder;

    uint public startTime;
    uint public endTime;

    mapping(address => uint) public bids;

    /// @dev adding owner and distribution strategy to the constructor
    constructor(
        address _strategyOwner,
        address _distributionStrategy,
        uint _startTime,
        uint _endTime
    ) {
        strategyOwner = _strategyOwner;
        distributionStrategy = _distributionStrategy;
        startTime = _startTime;
        endTime = _endTime;
    }

    function owner() public view override returns (address) {
        return strategyOwner;
    }

    function applyToPool(
        bytes memory _data
    ) external payable override returns (bytes memory) {
        // Implement the function here, including decoding _data and storing the applicant.

        // todo: do we want to use the registry here? @KurtMerbeth @thelostone-mc
        // (address applicant, Metadata.IdentityDetails memory metadata) = abi
        //     .decode(_data, (address, Metadata.IdentityDetails));

        // Return some bytes data.
        return _data;
    }

    function allocate(
        bytes memory _data
    ) external payable override returns (uint) {
        // Implement the function here, including decoding _data and performing necessary actions.
        // Return the number of votes cast.
        (address applicant, uint amount) = abi.decode(_data, (address, uint));

        // add checks for startTime and endTime
        require(block.timestamp > startTime, "Auction has not started yet");
        require(block.timestamp < endTime, "Auction has ended");

        // todo: add checks for amount and who is highest bidder (and highest bidder can't bid again?)
        require(amount > 0, "Amount must be greater than 0");
        require(
            applicant != highestBidder,
            "Applicant must not be the highest bidder"
        );

        bids[applicant] += amount;
        highestBidder = applicant;

        return amount;
    }

    function generatePayouts()
        external
        payable
        override
        returns (bytes memory)
    {
        // Implement the function here, including generating payouts.
        // Return some bytes data. For now, return an empty bytes array.
        return "";
    }

    // Custom functions

    // Setters - by strategy owner only*
    function setStrategyOwner(address _strategyOwner) external {
        require(
            msg.sender == strategyOwner,
            "Only the strategy owner can call this function :: setStrategyOwner"
        );
        strategyOwner = _strategyOwner;
    }

    /// @dev setDistributionStrategy should be set by the strategy owner before the auction starts.
    /// @dev Should we allow the strategy owner to change the distribution strategy after the auction starts?
    function setDistributionStrategy(address _distributionStrategy) external {
        require(
            msg.sender == strategyOwner,
            "Only the strategy owner can call this function :: setDistributionStrategy"
        );
        distributionStrategy = _distributionStrategy;
    }

    // setStartTime should be set by the strategy owner before the auction starts and not changeable after that.

    /// @dev setEndTime should be set by the strategy owner before the auction starts and changeable after that.
    function setEndTime(uint _endTime) external {
        require(
            msg.sender == strategyOwner,
            "Only the strategy owner can call this function :: setEndTime"
        );
        endTime = _endTime;
    }
}
