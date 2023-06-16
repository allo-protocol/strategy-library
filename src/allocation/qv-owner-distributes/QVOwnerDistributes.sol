// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IAllocationStrategy} from "../../../lib/allo-v2/contracts/core/interfaces/IAllocationStrategy.sol";

contract QVOwnerDistributes is IAllocationStrategy {
    // State variables
    address public strategyOwner;

    // Constructor
    constructor() {
        strategyOwner = msg.sender;
    }

    function owner() public view override returns (address) {
        return strategyOwner;
    }

    function applyToPool(
        bytes memory _data
    ) external payable override returns (bytes memory) {
        // Implement the function here, including decoding _data and storing the applicant.
        // Return some bytes data.
        return _data;
    }

    function allocate(
        bytes memory _data
    ) external payable override returns (uint) {
        // Implement the function here, including decoding _data and performing necessary actions.
        // Return the number of votes cast. For now, return a dummy value.
        (, uint amount) = abi.decode(_data, (address, uint));

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
}
