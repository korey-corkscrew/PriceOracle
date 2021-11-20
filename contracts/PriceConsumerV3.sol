pragma solidity ^0.6.0;

pragma experimental ABIEncoderV2;

import "../interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";


contract PriceConsumerV3 {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;


    AggregatorV3Interface internal priceFeed;

    struct Price {
        int256 price;
        uint256 timestamp;
    }


    Price[] private HourlyData;
    uint256 private timestampHour; // = 1637362800; // 11/19/2021 17:00:00


    constructor(AggregatorV3Interface _priceFeed, Price[] memory _data, uint256 _timestampHour) public {
        priceFeed = _priceFeed;
        timestampHour = _timestampHour;
        for(uint i = 0; i < _data.length; i++) {
            HourlyData.push(_data[i]);
        }
    }

    function hourlyDataLength() public view returns (uint256) {
        return HourlyData.length;
    }

    function latestTimestamp() public view returns (uint256) {
        return HourlyData[HourlyData.length.sub(1)].timestamp;
    }

    function latestPrice() public view returns (int256) {
        return HourlyData[HourlyData.length.sub(1)].price;
    }

    function viewHourlyData(uint256 _index) public view returns (Price memory) {
        return HourlyData[_index];
    }

    function viewTimestampHour() public view returns (uint256) {
        return timestampHour;
    }

    function pricePeriodsBehind(uint256 _periods) public view returns (int256) {
        return HourlyData[HourlyData.length.sub(_periods)].price;
    }

    function viewHistoricalPrice(uint256 _start, uint256 _end) public view returns (Price[] memory) {
        Price[] memory data = new Price[](_end.sub(_start).add(1));
        for(uint256 i = _start; i <= _end; i++) {
            data[i.sub(_start)] = HourlyData[i];
        }
        return data;
    }

    /* ----------------------------------------------------------------------------------- */

    // Update Oracle
    function update() public {
        uint256 latestTime = priceFeed.latestTimestamp();
        if(latestTime > timestampHour.add(3450) && latestTime < timestampHour.add(3750)) {
            HourlyData.push(Price(priceFeed.latestAnswer(), latestTime));
            timestampHour += 3600;
        }
        else {
            revert("CornFi Price Oracle: Current Round Out of Range");
        }
    }

    function updateByRound(uint80 _round) public {
        ( , int256 roundPrice, uint256 roundTime, , ) = priceFeed.getRoundData(_round);
        if(roundTime > timestampHour.add(3450) && roundTime < timestampHour.add(3750)) {
            HourlyData.push(Price(roundPrice, roundTime));
            timestampHour += 3600;
        }
        else {
            revert("CornFi Price Oracle: Current Round Out of Range");
        }
    }
 

    /* ----------------------------------------------------------------------------------- */

    // Price functions
    function getSumOfHours(uint256 _hours) public view returns (uint256) {
        uint256 sum = 0;
        for(uint256 i = HourlyData.length.sub(_hours); i < HourlyData.length; i++) {
            sum = sum.add(uint256(HourlyData[i].price));
        }
        return sum;
    }

    function simpleMovingAverage(uint256 _periods) public view returns (uint256) {
        return getSumOfHours(_periods).div(_periods);
    }

    function priceRateOfChange(uint256 _periods) public view returns (uint256) {
        return uint256(latestPrice()).sub(uint256(pricePeriodsBehind(_periods))).mul(100);
    }











    /**
     * Returns the latest price
     */
    /*function getLatestPrice(AggregatorV3Interface _aggregator) public view returns (uint80, int, uint, uint, uint80) {
        return _aggregator.latestRoundData();
        
    }

    function getRoundData(AggregatorV3Interface _aggregator, uint80 _roundId) external view returns (uint80, int256, uint256, uint256, uint80) {
        return _aggregator.getRoundData(_roundId);
    }

    function getRoundByTimestamp(AggregatorV3Interface _aggregator, uint256 _timestamp, uint80 _startingRound) external view returns (uint80) {
        for(uint80 i = _startingRound; i < _aggregator.latestRound(); i++) {
            if(_aggregator.getTimestamp(i) > _timestamp - 60 && _aggregator.getTimestamp(i) < _timestamp + 60) {
                return i;
            }
            if(_aggregator.getTimestamp(i) > _timestamp + 60) {
                return uint80(0);
            }
        }
        return uint80(0);
    }

    function storeHourlyData(AggregatorV3Interface _aggregator, uint80 _startingRoundId, uint80 _offset) public {
        uint80 startingRoundId = _startingRoundId;
        (uint80 latestRound, , , , ) = _aggregator.latestRoundData();
        ( , int initialPrice, uint lastTime, , ) = _aggregator.getRoundData(startingRoundId);
        while(initialPrice == 0) {
            (latestRound, initialPrice, lastTime, , ) = _aggregator.getRoundData(startingRoundId++);
        }
        HourlyData.push(Price(initialPrice, lastTime));
        for(uint80 i = _startingRoundId; i < latestRound; i+_offset) {
            ( , int price, uint timestamp, , ) = _aggregator.getRoundData(i);
            if(timestamp > lastTime + 3600) {
                HourlyData.push(Price(price, timestamp));
                lastTime = timestamp;
            }
        }
    }

    function viewHourlyData() external view returns (Price[] memory) {
        return HourlyData;
    }*/
}
