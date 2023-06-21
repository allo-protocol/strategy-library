Direct Distribution Strategy
----------------------------

Flow: https://miro.com/app/board/uXjVMXyfa-o=/?moveToWidget=3458764557420723509&cot=14


### Overview

The Direct Distribution Strategy is a simple distribution strategy that directly transfers tokens or funds to specified recipients. It is responsible for executing payouts based on the provided data. This strategy does not involve any complex calculations or allocations.

### Contract Structure

The Direct Distribution Strategy contract, named `DirectGrantsDistributionStrategy`, implements the `IDistributionStrategy` interface. It also utilizes the `Initializable` contract.

#### Dependencies

The Direct Distribution Strategy contract depends on the following interface:

* `IDistributionStrategy` from the `IDistributionStrategy.sol` file in the specified path.

### Contract Initialization

The `DirectGrantsDistributionStrategy` contract requires initialization to set the necessary parameters. The initialization function `initialize` takes encoded parameters as input and sets the following:

* `poolId`: The ID of the pool associated with the strategy.
* `allo`: The address of the allo contract.
* `token`: The token address for distribution.

The initialization function should be called only once during contract deployment.

### Distribution Activation

The Direct Distribution Strategy provides a function called `activateDistribution` to execute the actual payouts. The function takes encoded data as input and decodes it to obtain the following information:

* `token`: The address of the token being distributed.
* `recipients`: An array of addresses representing the recipients of the distribution.
* `amounts`: An array of uint256 values representing the amounts to be distributed to each recipient.

The `activateDistribution` function transfers the specified token or funds to the recipients. It supports custom options for different token types, such as ETH, ERC20, ERC721, ERC1155.

### Claiming Tokens

The Direct Distribution Strategy does not implement the `claim` function and reverts with the `NotUsed` error. This strategy does not involve any claiming mechanism.

### Custom Variables

The Direct Distribution Strategy contract does not define any custom variables beyond the inherited ones.


## Callouts

- activateDistribution should be callable multiple times

