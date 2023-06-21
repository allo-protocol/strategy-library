// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDistributionStrategy} from "../../../lib/allo-v2/contracts/core/interfaces/IDistributionStrategy.sol";
import {Initializable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {EnumerableMap} from "openzeppelin-contracts/contracts/utils/structs/EnumerableMap.sol";
import {MetaPtr} from "../../../lib/allo-v2/contracts/utils/MetaPtr.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract MerkleIDistributionStrategy is IDistributionStrategy, Initializable, IERC20 {
    function initialize(bytes calldata _data) external initializer {
        // set common params
        //  - poolId
        //  - allo
        //  - token
    }

    // call to allo() and query rounds[roundId].owner
    function owner() external view returns (address) {
        // returns pool owner by query allo contract
    }

    // decode the _data into what's relevant to determine payouts
    // set the merkle root, once set cannot be updated
    function activateDistribution(bytes memory _data) external  override {
        // decode data to get the merkle root
        // bytes32 merkleRoot = abi.decode(_data, (bytes32));
        // set merkle root
    }

    // claims token to given address and updates _claimedBitMap
    // Reverts a claim if inputs are invalid
    function claim(bytes memory _data) external override {

    }

    // -- Custom Variables

    struct Claim {
        uint256 index;
        address claimee;
        uint256 amount;
        bytes32[] merkleProof;
    }

    /// @notice merkle root generated from distribution
    bytes32 public immutable merkleRoot;

    /// @dev packed array of booleans to keep track of claims
    mapping(uint256 => uint256) private _claimedBitMap;

    // -- Custom Function

    /**
     * @notice Marks claim on the _claimedBitMap for given index
     * @param _index index in _claimedBitMap which has claimed funds
     */
    function _setClaimed(uint256 _index) private {}

    /**
     * @notice Check if claimee has already claimed funds.
     * @dev Checks if index has been marked as claimed.
     *
     * @param _index Index in _claimedBitMap
     */
    function hasClaimed(uint256 _index) public view returns (bool) {}

    /**
     * @notice Enables the funder to withrdraw remaining balance
     * @dev Escape hatch, intended to be used if the merkle root uploaded is incorrect
     * @dev We trust the funder, which is why they are allowed to withdraw funds at any time
     *
     */
    function reclaimFunds(IERC20 _token) external {}

    /**
     * @notice Batch Claim
     * @dev Useful for batch claims (complete pending claims)
     *
     * @param _claims Array of Claim
     */
    function batchClaim(Claim[] calldata _claims) external {}
}
