// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDistributionStrategy} from "../../../lib/allo-v2/contracts/core/interfaces/IDistributionStrategy.sol";

contract SplitsDistributionStrategy is IDistributionStrategy, Initializable {
    // NOTE: Should support multicall using OZ's Multicall2

    address token;

    modifier isPoolOwner() {
        // lookup pool owner from IAllo contract
        _;
    }

    function initialize(bytes calldata encodedParameters) external initializer {
        // set common params
        //  - poolId
        //  - allo
        //  - token
    }

     // call to allo() and query rounds[roundId].owner
    function owner() external view returns (address) {}


    function activateDistribution(bytes memory _data) isPoolOwner external {
        // decode data: accounts, percentAllocations, distributorFee
        // 1. create split : SplitMain.createSplit(accounts, percentAllocations, distributorFee, poolOwner)
        // 2. transfer tokens to split
        // 3. invoke split.distributeETH  / split.distributeERC20
    }


    function claim(bytes memory _data) external {
        // decode data to get account  
        // SplitMain.withdraw(account, 0 , [token]) // ERC20
        // SplitMain.withdraw(account, 1 , []) // ETH
    }


    // -- CUSTOM Variable
    address split;

}