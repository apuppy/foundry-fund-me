// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFounded)
        public addressToAmountFounded;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // Allow users to send $
        // Have a minimum $ 5$
        // How do we send ETH to this contract
        require(
            msg.value.getConversionRate() >= MINIMUM_USD,
            "Didn't send enough ETH."
        );
        funders.push(msg.sender);
        addressToAmountFounded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (
            uint256 founderIndex = 0;
            founderIndex < funders.length;
            founderIndex++
        ) {
            address founder = funders[founderIndex];
            addressToAmountFounded[founder] = 0;
        }
        funders = new address[](0);
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);
        // // send
        // bool sendSucess = payable(msg.sender).send(address(this).balance);
        // require(sendSucess, "Send failed");
        // call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Must be owner");
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external {
        fund();
    }
}
