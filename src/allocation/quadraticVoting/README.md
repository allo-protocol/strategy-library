QV Allocation Strategy
----------------------

Flow: https://miro.com/app/board/uXjVMXyfa-o=/?moveToWidget=3458764557414692165&cot=14

## Overview 

The QV Allocation Strategy is designed to handle allocations and distributions in a pool based on Quadratic Voting. Quadratic Voting allows users to allocate tokens while considering the square of the number of tokens they possess. The distribution of funds in the pool is determined based on the total votes received by each allocation.

### Architecture

The QV Allocation Strategy is implemented as a Solidity contract named `QVAllocationStrategy`. It follows the `IAllocationStrategy` interface and requires initialization before use. The strategy operates within the context of a pool and works alongside a distribution strategy.

#### Dependencies

The QV Allocation Strategy depends on the following:

* OpenZeppelin's Multicall2 for supporting multicall operations.
* `EnumerableMap` from OpenZeppelin for managing allocations.


### Initialization

The `QVAllocationStrategy` contract requires initialization to set the necessary parameters. The initialization function `initialize` takes encoded parameters as input and sets the following:

* `poolId`: The ID of the pool associated with the strategy.
* `allo`: The address of the allo contract.
* `applicationStart`: The timestamp when the application period starts.
* `applicationEnd`: The timestamp when the application period ends.
* `allocationStart`: The timestamp when the allocation period starts.
* `allocationEnd`: The timestamp when the allocation period ends.

The initialization function should be called only once during contract deployment.

### Application Workflow

The QV Allocation Strategy supports the following workflow for applying to the pool:

1. Users encode application data and call the `applyToPool` function, passing the encoded data and their address.
2. The encoded data is decoded to obtain the following:
    * `identityId`: The identity ID associated with the application.
    * `applicationMetaPtr`: A pointer to the metadata of the application.
    * `recipientAddress`: The address to receive allocations if the application is accepted.
3. Custom logic can be implemented in the `applyToPool` function to gate applications based on additional checks, such as an Enterprise Authentication Service (EAS), registry verification, or proof-of-humanity (POH) contract address.
4. The application status is set to either `Pending` or `Reapplied` based on the custom logic.
5. The application is added or updated in the `applications` mapping, with the `identityId` as the key.

### Allocation Workflow

The QV Allocation Strategy supports the following workflow for allocating funds:

1. Users encode allocation data and call the `allocate` function, passing the encoded data and their address.
2. The encoded data is decoded to obtain the following:
    * `identityId`: The identity ID associated with the allocation.
    * `amount`: The amount of tokens being allocated.
    * `token`: The token type being allocated.
3. The application status is checked to ensure it is not `None` or `Rejected`.
4. The allocator's validity is checked by verifying their vote count (`voteCounter`).
5. The allocator's vote count is checked to ensure it is less than the required threshold (`votesPerAllocator`).
6. The votes received by the application in the `applications` mapping are updated based on the quadratic voting logic: `Vote Weight = (Number of Tokens)^2`.

### Payout Generation

The QV Allocation Strategy provides a function called `generatePayouts` to calculate the distribution of funds based on the quadratic voting logic.

1. The `generatePayouts` function is called, and it returns a bytes array containing the payout information.
2. The function uses the votes received from the `applications` mapping as input to run the quadratic voting calculations and generate the payout percentages.
3. The allocation tracker (`allocationTracker`) is used as input to determine the allocation amounts for each address.
4. The function loops through the `allocationTracker` and generates the payouts based on the calculated percentages.
5. The specific quadratic voting math is implemented to determine the payouts.

### Customization Options

The QV Allocation Strategy provides several functions to customize the strategy's behavior:

* `updateAllocationStart(uint64 _allocationStart)`: Allows updating the allocation period's start timestamp.
* `updateAllocationEnd(uint64 _allocationEnd)`: Allows updating the allocation period's end timestamp.
* `updateApplicationStart(uint64 _applicationStart)`: Allows updating the application period's start timestamp.
* `updateApplicationEnd(uint64 _applicationEnd)`: Allows updating the application period's end timestamp.
* `reviewApplications(bytes[] memory _data)`: Allows reviewing multiple applications by providing an array of encoded application data. The function decodes the data to obtain the identity ID and status and updates the respective applications.

### Data Structures

The QV Allocation Strategy uses the following additional data structures:

* `Application`: A struct containing the following information about an application:
    
    * `identityId`: The identity ID associated with the application.
    * `recipientAddress`: The address to receive allocations if the application is accepted.
    * `status`: The status of the application, which can be one of the following:
        * `None`: Initial status before an application is submitted.
        * `Pending`: Status indicating the application is pending review.
        * `Accepted`: Status indicating the application has been accepted.
        * `Rejected`: Status indicating the application has been rejected.
        * `Reapplied`: Status indicating the application has been reapplied after rejection.
    * `metaPtr`: A pointer to the metadata of the application.
    * `votesReceived`: The number of votes received by the application.
* `applications`: A mapping that associates an address (identity ID) with an `Application` struct. It stores the applications submitted by different identities.
    
* `voteCounter`: A mapping that tracks the number of votes cast by each user (identity ID).
    


#### New Variables
```javascript
struct Application {
    address identityId;
    address recipientAddress;
    ApplicationStatus status;
    MetaPtr metaPtr;
    uint32 votesReceived;
}

// create a mapping of applicationId to application status
mapping(address => Application) applications;

// some means to track votes casted by user
mapping(address => uint32) voteCounter;

// identityId => allocationAmount
EnumerableMap.AddressToUintMap private allocationTracker;
uint256 totalAllocations;

```

#### New Functions

Functions around updating constructor arguments.

```javascript
function updateAllocationStart(uint64 _allocationStart) external {}
function updateAllocationEnd(uint64 _allocationEnd) external {}
function updateApplicationStart(uint64 _applicationStart) external {}
function updateApplicationEnd(uint64 _applicationEnd) external {}
```

Functions around actual functionality

```javascript
function reviewApplications(bytes[] memory _data) external {
    // decode data to get identity id and status
    // update application status
}
```


### Open Questions

- How do we new add application status (like reapplied)

## Variations

The allocation strategy can be customized for different usecase

- Application Gating 
    - update initialize() (if applicable)
    - update applyToPool to invoke contracts to check gating
- Allocation Gating
    - update initialize() (if applicable)
    - update allocate to invoke contracts to check gating
- Not using registry. AKA no indentityId 
    - in these cases, an applicationID would have to be generated by the AllocationStrategy