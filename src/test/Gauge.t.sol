// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";

import "./utils/Caller.sol";

import "./utils/tokens/TokenERC20.sol";

import {Gauge} from "../Gauge.sol";
import {Gauge} from "../Gauge.sol";

contract GaugeTest is DSTest {
    Gauge private _gg;

    TokenERC20 private _stakingToken;
    TokenERC20 private _rewardToken;
    TokenERC20 private _ve;
    TokenERC20 private _veYfiRewardPool;

    address public owner;
    address public rewardManager;

    function setUp() public {
        _stakingToken = new TokenERC20("StakingToken","StakingToken");
        _rewardToken = new TokenERC20("RewardToken","RewardToken");
        _ve = new TokenERC20("VE","VE");
        _veYfiRewardPool = new TokenERC20("RewardPool","RewardPool");

        owner = address(this);
        rewardManager = address(this);

        _gg = new Gauge();
        _gg.initialize(
            address(_stakingToken), 
            address(_rewardToken), 
            owner,
            rewardManager,
            address(_ve),
            address(_veYfiRewardPool));
    }

    function testInitialTotalSupply() public {
        assertEq(_gg.totalSupply(), 0);
    }

    function testOwnerSetVe() public {
        TokenERC20 newVe = new TokenERC20("NewVe","NewVe");
        _gg.setVe(address(newVe));
        assertEq(_gg.veToken(), address(newVe));
    }

    function testNonOwnerCannotSetVe() public {
        Caller user = new Caller();

        (bool ok, ) = user.externalCall(
            address(_gg),
            abi.encodeWithSelector(
                _gg.setVe.selector,
                (address(0xdeadbeef))
            )
        );

        assertTrue(!ok, "Only the owner can change ve");
    }
}
