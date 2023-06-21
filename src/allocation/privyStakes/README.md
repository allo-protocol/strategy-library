## Overview 

Flow: https://miro.com/app/board/uXjVMXyfa-o=/?moveToWidget=3458764557421590780&cot=14
The Privy Stakes allocation strategy is designed to handle incoming allocations and calculate distributions for a pool based on a voting mechanism. The strategy allows whitelisted users to allocate tokens and cast votes. The distribution of funds in the pool is proportional to the percentage of votes received by each project.

## Architecture

The Privy Stakes allocation strategy is implemented as a Solidity contract named `PrivyStakesAllocationStrategy`. It follows the `IAllocationStrategy` interface and requires initialization before use. The strategy operates within the context of a pool and works alongside a distribution strategy.

**Dependencies**
The Privy Stakes allocation strategy depends on the following:

- `Initializable` from OpenZeppelin for managing allocations
- `EnumerableMap` from OpenZeppelin for managing allocations
- _OpenZeppelin's Multicall2 for supporting multicall operations_ **(tbd)**

## Initialization
The `PrivyStakesAllocationStrategy` contract requires initialization to set the necessary parameters. The initialization function initialize takes _encoded_ parameters as input and sets the following:

- `poolId`: The ID of the pool associated with the strategy
- `allo`: The address of the allo contract
- `applicationStart`: The timestamp when the application period starts
- `applicationEnd`: The timestamp when the application period ends
- `votingStart`: The timestamp when the voting period starts
- `votingEnd`: The timestamp when the voting period ends
- `votesPerAllocator`: The number of votes every user receives
- `allowedUser`: The list of users which are allowed to vote
  
The initialization function should be called only once during strategy creation.

## Application Workflow

The Privy Stakes allocation strategy supports the following workflow for applying to the pool:

1. Users encode application data and call the `applyToPool` function, passing the encoded data and their address.

2. The encoded data is decoded to obtain the following:

     - `identityId`: The identity ID associated with the application
     - `applicationMetaPtr`: A pointer to the metadata of the application
     - `recipientAddress`: The address to receive allocations if the application is accepted

3. _Custom logic can be implemented in the applyToPool function to gate applications based on additional checks, such as an EAS (Enterprise Authentication Service) or registry verification._ **(tbd)**

4. The application status is set to either Pending or Reapplied based on the custom logic.
5. The application is added or updated in the applications mapping, with the identityId as the key.

## Allocation Workflow

The Privy Stakes allocation strategy supports the following workflow for allocating funds:

1. Users encode allocation data and call the allocate function via the Allo contract, which passes the encoded data and the senders address.

2. The encoded data is decoded to obtain the following:
    - `identityId`: The identity ID associated with the application
    - `amount`: The amount of tokens being allocated

3. The application status is checked to ensure that it is not `None` or `Rejected`.

4. The allocator's validity is checked.

5. The allocator's vote count is checked to ensure it meets the required threshold, which is determined by the `votesPerAllocator` parameter.

6. The allocation is added to the `allocationTracker` mapping, using the `identityId` as the key.

7. The allocation amount is added to the `totalAllocations` variable to keep track of the overall allocation amount.


## Payout Generation

The Privy Stakes allocation strategy provides a function called `generatePayouts` to calculate the distribution of funds based on the `allocationTracker`.

1. The `generatePayouts` function is called, and it returns a bytes array containing the payout information.

2. The function iterates over the entries in the `allocationTracker` mapping to calculate the payout percentage for each allocation.

3. For each allocation, the payout percentage is calculated as:
    `(allocationTracker.at(index) * 100) / totalAllocations`.

4. The payout percentages are stored in the bytes array, which represents the payout information for each allocation.

5. The payout information can be further processed by the distribution strategy for actual fund distribution.

## Customization Options
The Privy Stakes allocation strategy provides several functions to customize the strategy's behavior:

- `updateVotingStart(uint64 _votingStart)`: Allows updating the voting period's start timestamp.

- `updateVotingEnd(uint64_votingEnd)`: Allows updating the voting period's end timestamp.

- `updateApplicationStart(uint64 _applicationStart)`: Allows updating the application period's start timestamp.

- `updateApplicationEnd(uint64_applicationEnd)`: Allows updating the application period's end timestamp.

- `reviewApplications(bytes[] memory _data)`: Allows reviewing multiple applications by providing an array of encoded application data. The function decodes the data to obtain the identity ID and application status and updates the respective applications.

## Data Structures
The Privy Stakes allocation strategy uses the following data structures:

- `allocationTracker`: An EnumerableMap mapping an address (identity ID) to an allocation amount. It keeps track of the allocations made by different identities.

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

- `votesCastByUser`: A mapping that tracks the number of votes cast by each user (identity ID).
  
---

#### New Variables
```javascript
EnumerableMap.AddressToUintMap private allocationTracker;
uint256 totalAllocations;

struct Application {
    address identityId;
    address recipientAddress;
    ApplicationStatus status;
    MetaPtr metaPtr;
    uint32 votesReceived;
}

// create a mapping of applicationId to application status
mapping(address => Application) applications;

// some means to track votes casted
mapping(address => uint32) votesCastByUser;
```

#### New Functions

Functions around updating constructor arguments.

```javascript
function updateVotingStart(uint64 _votingStart) external {}
function updateVotingEnd(uint64 _votingEnd) external {}
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