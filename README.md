(work-in-progress)

# Async DAO Proxy

- Fully on-chain async DAO governance

- smart contract governance is essentially about pointing to the correct smart contract

- all user calls to the AsyncDAOProxy are forwarded to the target_DAO contract

- AsyncDAOProxy is an ERC20 and the votes are contained in the balances mapping

- the target mapping contains an address that each token holder (DAO member) considers the current latest version

- target_DAO is calculated as the address with the most votes, on each call to AsyncDAOProxy_update, which is run by each token holder asynchronously

- the contract is protected economically, just like Proof-of-Stake (DAO members can proxy to a bad contract destroying the value of their own token)

- flashloan attacks do not work as they only point to a bad contract intra-transaction, i.e. only for themselves, before reverting to the previous state

- this is a no veto, purely democratic DAO governance structure

- minting: AsyncDAOProxy_mint adds votes for an address to become a new token_holder, AsyncDAOProxy_unmint removes votes. if an address reaches majority votes (upon calling AsyncDAOProxy_mint), new tokens are minted for that address. the constructor contains an init token holder that can bootstrap all other token holders.

- a single dev can use this simple contract to have an updatable smart contract
- a community can use this for a purely democratic update process
- any distribution (of unequal) governance power can be implemented using this contract