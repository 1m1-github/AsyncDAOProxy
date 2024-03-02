(work-in-progress)

# Async DAO Proxy
the simplest way to update your smart contract

Proxy smart contract forwards calls to the DAO target contract.

Each governance member sets (asynchronously) the target contract which it perceives to be the correct contract.

The DAO target contract is defined as the balance weighted winner contract as defined by the DAO members (ERC20 holders).
A majority (> 50%) target guarantess target.

For gas optimization, each member target set updates the DAO target.

flashloan attack does not work as its intra transaction and the majority reverts

no veto, PoS (economic defense from attaacks)

should be ERC

chatgpt4 prompt:
you are an expert smart contract developer and ERC writer. we are creating a DAO proxy. the DAO proxy is an ERC20. additionally, the DAO proxy contains a mapping from address to another address. 
