## Overview 

Flow: https://miro.com/app/board/uXjVMXyfa-o=/?moveToWidget=3458764557415531094&cot=14

### Description

The Request-for-Proposal (RFP) strategy allows the pool owner to facilitate bids for a specific scope of work. As opposed to other strategies where there are multiple recipients of a pool, in this strategy only one applicant is selected to receive the funds.

## New Variables
```javascript

struct Application {
    MetaPtr metaPtr;
    address identityId;
    address recipientAddress;
    ApplicationStatus status;
}

// stores mapping from identityId -> Application
mapping (address => Application[]) public applications;

```

## New Functions

Functions around actual functionality

```javascript

function reviewApplications(bytes[] memory _data) external {
    // decode data to get list of 
    //  - identityId
    //  - index of application (to know which application)
    //  - status
    
    // update application status in applications mapping
}
```


## Open Questions
- How do we want to handle single-choice vs committee vote? Some versions may just want to have one wallet be able to select / chose an application to receive the allocation. Other versions may want to let a small group vote to decide who receives the funds.

## Variations
