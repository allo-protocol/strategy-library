## Quadratic Funding (QF) Allocation Strategy

Flow: https://miro.com/app/board/uXjVMXyfa-o=/?moveToWidget=3458764557412142387&cot=14

## Overview 


The Quadratic Funding (QF) allocation strategy is designed to handle incoming allocations and calculate distributions for a pool using quadratic funding principles. The strategy allows users to apply for allocations, and the distribution of funds in the pool follows a quadratic formula based on the votes received by each project.
### Architecture

The QF allocation strategy is implemented as a Solidity contract named `QFAllocationStrategy`. It follows the `IAllocationStrategy` interface and requires initialization before use. The strategy operates within the context of a pool and works alongside a distribution strategy.
#### Dependencies

The QF allocation strategy depends on the following:
- OpenZeppelin's Multicall2 for supporting multicall operations 
- `EnumerableMap` from OpenZeppelin for managing allocations


### Initialization

The `QFAllocationStrategy` contract requires initialization to set the necessary parameters. The initialization function `initialize` takes encoded parameters as input and sets the following: 
- `poolId`: The ID of the pool associated with the strategy 
- `allo`: The address of the allo contract 
- `owner`: The address of the pool owner 
- `applicationStart`: The timestamp when the application period starts 
- `applicationEnd`: The timestamp when the application period ends 
- `allocationStart`: The timestamp when the allocation period starts 
- `allocationEnd`: The timestamp when the allocation period ends
- Optional parameters for application or allocation gating, such as the address of an EAS (Enterprise Authentication Service), registry contract, or POH (Proof of Humanity) contract

The initialization function should be called only once during contract deployment.
### Application Workflow

The QF allocation strategy supports the following workflow for applying to the pool: 
1. Users encode application data and call the `applyToPool` function, passing the encoded data and their address. 
2. The encoded data is decoded to obtain the following: 
- `identityId`: The identity ID associated with the application 
- `applicationMetaPtr`: A pointer to the metadata of the application 
- `recipientAddress`: The address to receive allocations if the application is accepted 
3. Custom logic can be implemented in the `applyToPool` function to gate applications based on additional checks, such as an EAS, registry verification, or POH verification. 
4. The application status is set to either `Pending` or `Reapplied` based on the custom logic. 
5. The application is added or updated in the `applications` mapping, with the `identityId` as the key.
### Allocation Workflow

The QF allocation strategy supports the following workflow for allocating funds: 
1. Users encode allocation data and call the `allocate` function, passing the encoded data and their address. 
2. The encoded data is decoded to obtain the following: 
- `identityId`: The identity ID associated with the allocation 
- `amount`: The amount of tokens being allocated 
- `token`: The token being allocated 
3. The application status is checked in the `applications` mapping to ensure it is not `None` or `Rejected`. 
4. The allocation is added to the `allocationTracker` mapping, using the `identityId` as the key. 
5. The allocation amount is added to the `totalAllocations` variable to keep track of the overall allocation amount.
6. The tokens are transferred to the project payout address.
7. An event is emitted to indicate the allocation.
### Payout Generation

The QF allocation strategy provides a function called `generatePayouts` to calculate the distribution of funds based on the allocation tracker. 
1. The `generatePayouts` function is called, and it returns a bytes array containing the payout information. 
2. The function populates the `payouts` array by iterating over the entries in the `allocationTracker` mapping.
3. For each allocation, the payout percentage is calculated based on the quadratic formula using the allocation amount and the total allocations. 
4. The recipient address and the percentage of funds are stored in the `payouts` array.
5. The payout information can be further processed by the distribution strategy for actual fund distribution.
### Customization Options

The QF allocation strategy provides several functions to customize its behavior: 
- `updateVotingStart(uint64 _votingStart)`: Allows updating the voting period's start timestamp. 
- `updateVotingEnd(uint64 _votingEnd)`: Allows updating the voting period's end timestamp. 
- `updateApplicationStart(uint64 _applicationStart)`: Allows updating the application period's start timestamp. 
- `updateApplicationEnd(uint64 _applicationEnd)`: Allows updating the application period's end timestamp. 
- `reviewApplications(bytes[] memory _data)`: Allows reviewing multiple applications by providing an array of encoded application data. The function decodes the data to obtain the identity ID and application status and updates the respective applications. 
- `setPayouts(bytes memory _data)`: Sets the payouts data. This function should be invoked by the pool owner for off-chain logic and populates the `payouts` array using the allocationTracker and totalAllocations.
### Data Structures

The QF allocation strategy uses the following data structures: 
- `allocationTracker`: An `EnumerableMap` mapping an address (identity ID) to an allocation amount. It keeps track of the allocations made by different identities. 
- `totalAllocations`: A variable representing the total sum of all allocations made. 
- `Application`: A struct containing the following information about an application: 
- `identityId`: The identity ID associated with the application. 
- `recipientAddress`: The address to receive allocations if the application is accepted. 
- `status`: The status of the application, which can be one of the following: 
- `None`: Initial status before an application is submitted. 
- `Pending`: Status indicating the application is pending review. 
- `Accepted`: Status indicating the application has been accepted. 
- `Rejected`: Status indicating the application has been rejected. 
- `Reapplied`: Status indicating the application has been reapplied after rejection. 
- `metaPtr`: A pointer to the metadata of the application. 
- `applications`: A mapping that associates an address (identity ID) with an `Application` struct. It stores the applications submitted by different identities. 
- `Payout`: A struct representing the payout information for each allocation, including the following: 
- `recipientAddress`: The address to receive the payout. 
- `percentage`: The percentage of funds allocated for the recipient. 
- `payouts`: An array of `Payout` structs that stores the payout information.



#### New Variables
```javascript
// create a mapping of IdentityId to application status
EnumerableMap.AddressToUintMap private allocationTracker;
uint256 totalAllocations;

struct Application {
    address identityId;
    address recipientAddress;
    ApplicationStatus status;
    MetaPtr metaPtr;
}

// create a mapping of applicationId to application status
mapping(address => Application) applications;

// payouts data which will be set using setPayouts
struct Payout {
    address recipientAddress;
    uint32 percentage;
}

Payout[] public payouts;
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

function setPayouts(bytes memory _data) external isPoolOwner(){
    // TODO: discuss if this should be on distribution strategy
    // populate payouts array
    // would be invoked by pool owner for off-chain logic
}
```


### Open Questions

- How do we new add application status (like reapplied)
- Would it makes sense to have setPayouts on DistributionStrategy and generatePayout returns nothing ?

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