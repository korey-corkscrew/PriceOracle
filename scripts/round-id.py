from brownie import accounts, interface
import os
import math

# brownie run scripts/round-id.py

def main():
    myaccount = accounts.add(os.getenv("PRIVATE_KEY"))
    dev = accounts.at(myaccount)
    
    roundId = 36893488147419970572
    
    rounds = [[interface.AggregatorV3Interface('0xF9680D99D6C9589e2a93a78A04A279e509205945').getTimestamp(roundId), roundId]]

    roundId = roundId + 75
    counter = 1
    while roundId < interface.AggregatorV3Interface('0xF9680D99D6C9589e2a93a78A04A279e509205945').latestRound():
        print(roundId)
        timestamp = interface.AggregatorV3Interface('0xF9680D99D6C9589e2a93a78A04A279e509205945').getTimestamp(roundId)
        if timestamp > rounds[-1][0] + 3600:
            rounds.append([timestamp, roundId])
            counter = 1
        roundId = roundId + int(200/ math.sqrt(counter) / counter)
        counter = counter + 1
    print(rounds)
        
    #return PriceConsumerV3.deploy({'from': dev, 'gas_price': '35 gwei'})
    #print(PriceConsumerV3[-1].getRoundByTimestamp('0xAB594600376Ec9fD91F8e885dADF0CE036862dE0', 1637296361, 36893488147419955012))
    #print(PriceConsumerV3[-1].getRoundData('0xAB594600376Ec9fD91F8e885dADF0CE036862dE0', 36893488147419950012))