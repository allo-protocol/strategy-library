Merkle Distribution Strategy
----------------------------

Flow: https://miro.com/app/board/uXjVMXyfa-o=/?moveToWidget=3458764557420346906&cot=14

### Overview

The Merkle Distribution Strategy is designed to handle token distribution using a Merkle tree. It allows users to claim tokens based on their eligibility determined by a Merkle proof. The distribution strategy utilizes a Merkle root, which cannot be updated once set.

#### Dependencies

The Merkle Distribution Strategy contract depends on the following interface:

* `IDistributionStrategy` from the `IDistributionStrategy.sol` file in the specified path.

### Contract Initialization

The `MerkleIDistributionStrategy` contract requires initialization to set the necessary parameters. The initialization function `initialize` takes encoded parameters as input and sets the following:

* `poolId`: The ID of the pool associated with the strategy.
* `allo`: The address of the allo contract.
* `token`: The token address for distribution.

The initialization function should be called only once during contract deployment.

### Distribution Activation

The Merkle Distribution Strategy provides a function called `activateDistribution` to set the Merkle root, which cannot be updated once set. The function takes encoded data as input and decodes it to obtain the relevant information required to determine payouts.

### Claiming Tokens

Users can claim tokens using the `claim` function, which requires a Merkle proof to verify their eligibility. The function takes encoded data as input and decodes it to obtain the following information:

* `index`: The index in the claimedBitMap for the claimed funds.
* `claimee`: The address to which tokens will be claimed.
* `amount`: The amount of tokens to be claimed.
* `merkleProof`: An array of Merkle proofs used to verify the user's eligibility.

The `claim` function verifies the Merkle proof and updates the claimedBitMap to mark the index as claimed.

### Custom Variables

The Merkle Distribution Strategy contract defines the following custom variables:

* `merkleRoot`: An immutable variable representing the Merkle root generated from the distribution. Once set, it cannot be updated.
* `claimedBitMap`: A mapping of uint256 to uint256 used as a packed array of booleans to keep track of claimed funds.

### Custom Functions

The Merkle Distribution Strategy contract provides the following custom functions:

* `_setClaimed(uint256 _index)`: A private function that marks the claim on the claimedBitMap for the given index.
* `hasClaimed(uint256 _index)`: A public view function that checks if the claimee has already claimed funds by checking if the index has been marked as claimed.
* `reclaimFunds(IERC20 _token)`: An external function that enables the funder to withdraw the remaining balance. It serves as an escape hatch and can be used if the uploaded Merkle root is incorrect. Only the funder is allowed to withdraw funds at any time.
* `batchClaim(Claim[] calldata _claims)`: An external function useful for batch claims. It allows users to make multiple claims in a single transaction by providing an array of `Claim` struct objects.

### Claim Structure

The `Claim` struct contains the following information:

* `index`: The index in the claimedBitMap, indicating the claimed funds.
* `claimee`: The address of the user claiming the funds.
* `amount`: The amount of tokens to be claimed.
* `merkleProof`: An array of bytes32 representing the Merkle proof for verifying the user's eligibility.


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