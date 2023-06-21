
#### New Variables
```javascript
    struct Claim {
        uint256 index;
        address claimee;
        uint256 amount;
        bytes32[] merkleProof;
    }

    /// @notice merkle root generated from distribution
    bytes32 public immutable merkleRoot;

    /// @dev packed array of booleans to keep track of claims
    mapping(uint256 => uint256) private claimedBitMap;


```

#### New Functions
```javascript
 /**
     * @notice Marks claim on the claimedBitMap for given index
     * @param _index index in claimedBitMap which has claimed funds
     */
    function _setClaimed(uint256 _index) private {}


    /**
    * @notice Check if claimee has already claimed funds.
    * @dev Checks if index has been marked as claimed.
    *
    * @param _index Index in claimedBitMap
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
```


## Callouts

- `activateDistribution` can be called only once to set merkle root