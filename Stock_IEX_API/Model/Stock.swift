//
//  Stock.swift
//  Stock_IEX_API
//
//  Created by Shane Talbert on 5/18/19.
//  Copyright © 2019 Shane Talbert. All rights reserved.
//

import Foundation

struct Stock {
    
    //This struct is only going to be used to display the data on my StockBarView.  Using this struct so that when stocks are at a 52 week high or low it will set the current price to that low or high.  This will keep the current price from falling outside of the stock bar view...
    
    //From StockInfo
    var symbol: String
    var companyName: String
    var latestPrice: Float
    var changePercent: Float
    var latestVolume: Float
    var avgTotalVolume: Float
    
    //From StockStats
    var fiftyDayMA: Float
    var twoHundredDayMA: Float
    
    //trying to correct a bug.  Currently if the current price drops below the 52 week high or low the current price will fall out of bounds.  May try frixing in the view.
    //this is set when you get the data back in the form of the JSON.  Will need to make a 3rd struct that will be the data that is used to fill out the stock view chart...
    var fiftyTwoWeekHigh: Float {
        willSet {
            
            if latestPrice > newValue {
                 self.fiftyTwoWeekHigh = latestPrice
            }
            print("will set fifty two week high \(newValue)")
            //newValue
        }
        didSet {
            print("did set 52 week high \(oldValue)")
            //oldValue
        }
    }
    
    
    var fiftyTwoWeekLow: Float {
        willSet {
            if latestPrice < newValue {
                self.fiftyTwoWeekLow = latestPrice
                print("Will set fifty two week low)")
            }
        }
    }
    
    public func printStockDetails() {
        print("Company name is \(self.companyName).  52 week high is \(fiftyTwoWeekHigh).  52 week low is \(fiftyTwoWeekLow)")
    }
    
    //This will look to see if the stock is at 52 week low or high and alter the 52 week low or high to be the current price...
    public mutating func checkStatusOfHighLow() {
        
        if latestPrice > fiftyTwoWeekHigh {
            //at 52 week high
            fiftyTwoWeekHigh = latestPrice
        }
        
        if latestPrice < fiftyTwoWeekLow {
            //at 52 week low
            fiftyTwoWeekLow = latestPrice
        }
        
    }
    
    
}
