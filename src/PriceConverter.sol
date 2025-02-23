//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getRawPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (int) {
        (, int answer, , , ) = priceFeed.latestRoundData();
        return answer;
    }

    function getDecimals(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint8) {
        return priceFeed.decimals();
    }

    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (int) {
        // address
        // ABI
        (, int answer, , , ) = priceFeed.latestRoundData();
        return answer * 1e10;
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = uint256(getPrice(priceFeed));
        uint256 ethAmountInUsd = (ethAmount * ethPrice) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        return priceFeed.version();
    }
}
