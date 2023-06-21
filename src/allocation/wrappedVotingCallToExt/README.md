Wrapped Voting Allocation Strategy
----------------------------------

Flow: <https://miro.com/app/board/uXjVMXyfa-o=/?moveToWidget=3458764557422793722&cot=14>

### Overview

The Wrapped Voting Allocation Strategy enables token allocation to recipients based on a voting mechanism. It allows participants to apply for allocation, vote for the applicants, and perform token allocation based on the voting results. This strategy is suitable for scenarios where token allocation decisions are determined through a voting process.

### Contract Structure

The Wrapped Voting Allocation Strategy contract, named `WrappedVotingCallToExt`, implements the `IAllocationStrategy` interface and utilizes the `Initializable` contract.

#### Dependencies

The Wrapped Voting Allocation Strategy contract depends on the following interface:

* `IAllocationStrategy` from the `IAllocationStrategy.sol` file in the specified path.

### Contract Initialization

The `WrappedVotingCallToExt` contract requires initialization to set the necessary parameters. The initialization function `initialize` takes encoded parameters as input and sets the following:

* `poolId`: The identifier of the pool associated with the strategy.
* `allo`: The address of the token being allocated.
* `applicationStart`: The timestamp indicating the start of the application period.
* `applicationEnd`: The timestamp indicating the end of the application period.
* `allocationStart`: The timestamp indicating the start of the allocation period.
* `allocationEnd`: The timestamp indicating the end of the allocation period.
* `votesPerAllocator`: The maximum number of votes allowed per allocator.
* Allowed list of voters\`: The addresses of the accounts allowed to vote.
* `externalContract`: The address of the contract to call for before and after allocation operations.

The initialization function should be called only once during contract deployment.

### Pool Owner

The Wrapped Voting Allocation Strategy provides an `owner` function that returns the address of the pool owner. It queries the `allo` contract to obtain the pool owner's address.

### Application Process

The Wrapped Voting Allocation Strategy allows participants to apply for allocation through the `applyToPool` function. The function takes encoded data and the sender's address as input. It performs the following steps:

1. Decodes the data to obtain the following information:
    
    * `identityId`: The identifier of the applicant's identity.
    * `applicationMetaPtr`: A reference to additional metadata for the application.
    * `recipientAddress`: The address where the allocated tokens will be sent.
2. Performs custom logic, if required, to gate applications based on EAS (Enterprise Authentication Service) or registry checks.
    
3. Sets the application status to `Pending` or `Reapplied`.
    
4. Adds or updates the application in the `applications` mapping.
    

### Application Status

The Wrapped Voting Allocation Strategy provides a function called `getApplicationStatus` to retrieve the status of an application. The function takes encoded data as input and decodes it to obtain the `identityId`. It returns the application status from the `applications` mapping.

### Token Allocation

The Wrapped Voting Allocation Strategy allows token allocation through the `allocate` function. The function takes encoded data and the sender's address as input. It performs the following steps:

1. Calls the `beforeAllocate` function of the external contract, passing the encoded data and sender's address as parameters.
    
2. Decodes the data to obtain the following information:
    
    * `identityId`: The identifier of the allocator's identity.
    * `amount`: The amount of tokens to allocate.
3. Checks the application status for the provided `identityId`.
    
4. Verifies that the allocator is valid.
    
5. Verifies that the allocator has not exceeded the maximum number of votes (`voteCounter`).
    
6. Adds the allocation to the `allocationTracker`.
    
7. Updates the total allocations.
    
8. Calls the `afterAllocate` function of the external contract, passing the encoded data and sender's address as parameters.
    

### Payout Generation

The Wrapped Voting Allocation Strategy provides a function called `generatePayouts` to generate token payouts based on the allocation data. The function calculates the payout percentage for each allocation in the `allocationTracker` based on the total allocations and returns the generated payout data as bytes.

### Custom Variables and Functions

The Wrapped Voting Allocation Strategy contract defines several custom variables and functions:

* `externalContract`: The address of the contract to call for before and after allocation operations.
* `allocationTracker`: A mapping of addresses to allocation amounts, used to track allocations.
* `totalAllocations`: The total sum of all allocations.
* `Application` struct: A struct representing an application, consisting of `identityId`, `status`, and `metaPtr` fields.
* `applications`: A mapping of addresses to application data.
* `voteCounter`: A mapping of addresses to the number of votes cast by each user.

Additionally, the contract includes the following custom functions:

* `updateAllocationStart`: Allows updating the allocation start timestamp.
* `updateAllocationEnd`: Allows updating the allocation end timestamp.
* `updateApplicationStart`: Allows updating the application start timestamp.
* `updateApplicationEnd`: Allows updating the application end timestamp.
* `reviewApplications`: Allows reviewing applications and updating their status based on provided data.

#### New Variables

```javascript
  address externalContract;
  EnumerableMap.AddressToUintMap private allocationTracker;
  uint256 totalAllocations;

  struct Application {
      address identityId;
      ApplicationStatus status;
      MetaPtr metaPtr;
  }

// create a mapping of applicationId to application status
mapping(address => Application) applications;

// some means to track votes casted by user
mapping(address => uint32) voteCounter;
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

- Are we allowing updating the allowed list of voters?
- how to deal with votes of voters which will be removed from whitelist
- can the external contract be changed? 

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
