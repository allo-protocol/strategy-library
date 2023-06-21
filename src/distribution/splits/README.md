
Splits Distribution Strategy
----------------------------

Flow: https://miro.com/app/board/uXjVMXyfa-o=/?moveToWidget=3458764557428280180&cot=14


### Overview

The Splits Distribution Strategy allows for token distribution using a split mechanism. It enables the distribution of tokens to multiple accounts based on specified percentages. Additionally, it supports a distributor fee deduction during the distribution process.

### Contract Structure

The Splits Distribution Strategy contract, named `SplitsDistributionStrategy`, implements the `IDistributionStrategy` interface. It also utilizes the `Initializable` contract.

#### Dependencies

The Splits Distribution Strategy contract depends on the following interface:

* `IDistributionStrategy` from the `IDistributionStrategy.sol` file in the specified path.

### Contract Initialization

The `SplitsDistributionStrategy` contract requires initialization to set the necessary parameters. The initialization function `initialize` takes encoded parameters as input and sets the following:

* `token`: The address of the token being distributed.

The initialization function should be called only once during contract deployment.

### Pool Owner Modifier

The Splits Distribution Strategy contract defines a modifier called `isPoolOwner`. This modifier is used to validate that the function caller is the owner of the pool. It performs a lookup of the pool owner from the `IAllo` contract.

### Distribution Activation

The Splits Distribution Strategy provides a function called `activateDistribution` to execute the distribution process. The function takes encoded data as input and decodes it to obtain the following information:

* `accounts`: An array of addresses representing the accounts to receive the distribution.
* `percentAllocations`: An array of uint256 values representing the percentage allocations for each account.
* `distributorFee`: The fee percentage to be deducted during the distribution process.

The `activateDistribution` function performs the following steps:

1. Creates a split using the `SplitMain.createSplit` function, passing the `accounts`, `percentAllocations`, `distributorFee`, and `poolOwner`.
2. Transfers the tokens to the split.
3. Invokes the `split.distributeETH` or `split.distributeERC20` function based on the token type to distribute the tokens to the accounts.

### Claiming Tokens

The Splits Distribution Strategy provides a `claim` function to allow accounts to withdraw their allocated tokens. The function takes encoded data as input and decodes it to obtain the following information:

* `account`: The address of the account performing the claim.

Based on the token type, the `claim` function calls the appropriate withdrawal function from `SplitMain`. For ERC20 tokens, it calls `SplitMain.withdraw` with a withdrawal type of 0 and the token address. For ETH, it calls `SplitMain.withdraw` with a withdrawal type of 1 and an empty array.

### Custom Variable

The Splits Distribution Strategy contract defines a custom variable:

* `split`: The address of the split contract created during the distribution process.


#### New Variables
```javascript
    address split;
```


## Callouts

- When split is created, ownership is set to pool owner. Anything realted to splits functionality can be interacted directly with the splits contract by the pool owner