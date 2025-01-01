// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GenericStaking is Ownable(address(this)) {
    IERC20 public stakingToken;

    struct Stake {
        uint256 amount; // Amount of tokens staked
        uint256 timestamp; // Timestamp of when the staking started
    }

    mapping(address => Stake) public stakes;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);

    /// @notice Set the token to be used for staking
    /// @param tokenAddress The address of the ERC20 token contract
    constructor(address tokenAddress) {
        require(tokenAddress != address(0), "Token address cannot be zero");
        stakingToken = IERC20(tokenAddress);
    }

    /// @notice Stake a specific amount of tokens
    /// @param amount The amount of tokens to stake
    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");

        // Transfer tokens from the sender to the staking contract
        require(
            stakingToken.transferFrom(msg.sender, address(this), amount),
            "Token transfer failed"
        );

        // Update the stake data for the user
        stakes[msg.sender].amount += amount;
        stakes[msg.sender].timestamp = block.timestamp;

        emit Staked(msg.sender, amount);
    }

    /// @notice Unstake all tokens that the user has staked
    function unstake() external {
        Stake memory userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No tokens to unstake");

        uint256 amountToUnstake = userStake.amount;

        // Reset the user's stake data
        stakes[msg.sender].amount = 0;
        stakes[msg.sender].timestamp = 0;

        // Transfer tokens back to the user
        require(
            stakingToken.transfer(msg.sender, amountToUnstake),
            "Token transfer failed"
        );

        emit Unstaked(msg.sender, amountToUnstake);
    }

    /// @notice Get the stake details for a user
    /// @param user The address of the user
    /// @return amount The amount of tokens staked
    /// @return timestamp The timestamp when the stake started
    function getStakeDetails(address user)
        external
        view
        returns (uint256 amount, uint256 timestamp)
    {
        Stake memory userStake = stakes[user];
        return (userStake.amount, userStake.timestamp);
    }
}