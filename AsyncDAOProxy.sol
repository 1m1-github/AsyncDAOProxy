// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// WORK IN PROGRESS (untested)

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AsyncDAOPRoxy is ERC20 {
    mapping(address => address) public target;
    address[] public target_keys;
    address public target_DAO;

    constructor(string memory name, string memory symbol, address memory token_holder, uint memory num_tokens) ERC20(name, symbol) {
        _mint(token_holder, num_tokens);
    }

    // proxy

    function AsyncDAOPRoxy_update(address _target) public {
        require(_target != address(0), "Invalid target address");
        // Add to target_keys if this is a new target for the caller
        if (target[msg.sender] == address(0)) {
            target_keys.push(msg.sender);
        }
        target[msg.sender] = _target;

        // Calculate the new winner and update target_DAO
        target_DAO = calc_winner();
    }

    function calc_winner() private view returns (address winner) {
        uint256 highestVote = 0;
        address currentWinner = address(0);
        mapping(address => uint256) memory votes = new mapping(address => uint256)();

        // Accumulate votes for each target
        for (uint i = 0; i < target_keys.length; i++) {
            address voter = target_keys[i];
            address voteFor = target[voter];
            votes[voteFor] += balanceOf(voter);

            if (votes[voteFor] > highestVote) {
                highestVote = votes[voteFor];
                currentWinner = voteFor;
            }
        }

        return currentWinner;
    }

    fallback() external payable {
        _forwardCall();
    }

    receive() external payable {
        _forwardCall();
    }

    function _forwardCall() private {
        require(target_DAO != address(0), "Target DAO not set");

        // Ensure we're not trying to call the AsyncDAOPRoxy_update function
        if (msg.sig == this.AsyncDAOPRoxy_update.selector) {
            revert("AsyncDAOPRoxy_update call not allowed through proxy");
        }

        (bool success, ) = target_DAO.delegatecall(msg.data);
        require(success, "Forwarded call failed");
    }

    // minting

    mapping(address => uint256) public voteCount;

    function AsyncDAOPRoxy_mint(address new_token_holder, uint num_tokens) public {
        uint256 callerBalance = balanceOf(msg.sender);
        require(callerBalance > 0, "Caller has no tokens to vote");
        
        voteCount[new_token_holder] += callerBalance;
        
        uint256 totalSupply = totalSupply();
        if (voteCount[new_token_holder] > totalSupply / 2) {
            _mint(new_token_holder, num_tokens);
            voteCount[new_token_holder] = 0; // Reset votes for this holder after minting
        }
    }

    function AsyncDAOPRoxy_unmint(address new_token_holder) public {
        uint256 callerBalance = balanceOf(msg.sender);
        require(callerBalance > 0, "Caller has no tokens to vote");
        require(voteCount[new_token_holder] >= callerBalance, "Not enough votes to remove");

        voteCount[new_token_holder] -= callerBalance;
    }

}
