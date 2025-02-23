// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumUsdIsFive() external view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() external view {
        console.log("fundMe.i_owner(): ", fundMe.i_owner());
        console.log("msg.sender: ", msg.sender);
        // assertEq(fundMe.i_owner(), msg.sender);
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testGetVersionIsAcurate() external view {
        assertEq(fundMe.getVersion(), 4);
    }
}
