from brownie import *
import os
import time
import csv

# brownie run scripts/deploy/price-consumer.py

def main():
    myaccount = accounts.add(os.getenv("PRIVATE_KEY"))
    dev = accounts.at(myaccount)
    #return PriceConsumerV3.deploy('0xAB594600376Ec9fD91F8e885dADF0CE036862dE0', [(162000000, 1637366396), (163038093, 1637369858), (164800000, 1637373599), (163100000, 1637377203), (161100123, 1637380663), (161593375, 1637384254), (160747736, 1637387853), (161763469, 1637391451), (160865274, 1637395053), (161950705, 1637398667), (162000000, 1637402255), (162677829, 1637405855), (162911165, 1637409467), (164051826, 1637413054), (162835528, 1637416655), (161202770, 1637420254)], PriceConsumerV3[-1].viewTimestampHour(), {'from': dev, 'gas_price': '35 gwei'})
    #print(PriceConsumerV3[-1].getRoundByTimestamp('0xAB594600376Ec9fD91F8e885dADF0CE036862dE0', 1637296361, 36893488147419955012))
    #print(PriceConsumerV3[-1].getRoundData('0xAB594600376Ec9fD91F8e885dADF0CE036862dE0', 36893488147419950012))
    #PriceConsumerV3[-1].updateByRound(36893488147419966114, {'from': dev, 'gas_price': '35 gwei'})
    #print(PriceConsumerV3[-1].viewHourlyData(4))

    print(PriceConsumerV3[-1].getSumOfHours(16))
    print(PriceConsumerV3[-1].simpleMovingAverage(16))
    #print(PriceConsumerV3[-1].hourlyDataLength())
    #print(PriceConsumerV3[-1].viewHourlyData(0))
    '''with open('roundIds.csv', 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=['time', 'price'])

        writer.writeheader()
        price = PriceConsumerV3[-1].latestPrice()
        print(timestamp)
        print(price)
        writer.writerow({'time': timestamp, 'price': price})
    '''

    print(PriceConsumerV3[-1].viewHistoricalPrice(0, PriceConsumerV3[-1].hourlyDataLength()-1))
    while True:
        timestamp = PriceConsumerV3[-1].viewTimestampHour()
        while time.time() < timestamp + 3450:
            time.sleep(10)
        
        try:
            PriceConsumerV3[-1].update({'from': dev, 'gas_price': '35 gwei'})
        except Exception as err:
            print(err, '\n')

        #previousTimestamp = timestamp
        time.sleep(10)
    

        '''if timestamp > previousTimestamp:
            with open('roundIds.csv', 'w', newline='') as csvfile:
                writer = csv.DictWriter(csvfile, fieldnames=['time', 'price'])
                writer.writerow({'time': timestamp, 'price': PriceConsumerV3[-1].latestPrice()})'''