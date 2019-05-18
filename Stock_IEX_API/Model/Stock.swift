//
//  Stock.swift
//  Stock_IEX_API
//
//  Created by Shane Talbert on 5/18/19.
//  Copyright © 2019 Shane Talbert. All rights reserved.
//

import Foundation

struct Stock {
    
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
            print("will set fifty two week high")
            //newValue
        }
        didSet {
            print("did set 52 week high")
            //oldValue
        }
    }
    
    
    var fiftyTwoWeekLow: Float
    
    
    
    
}
