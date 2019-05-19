//
//  StockStats.swift
//  Stock_IEX_API
//
//  Created by Shane Talbert on 6/30/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import Foundation

struct StockStats : Codable {
    
    var fiftyDayMA: Float
    var twoHundredDayMA: Float
    
    //trying to correct a bug.  Currently if the current price drops below the 52 week high or low the current price will fall out of bounds.  May try frixing in the view.
    //this is set when you get the data back in the form of the JSON.  Will need to make a 3rd struct that will be the data that is used to fill out the stock view chart...
    var fiftyTwoWeekHigh: Float
    var fiftyTwoWeekLow: Float
    
    
    enum CodingKeys: String, CodingKey {
        
        //if the names did not match up
        //case description = "explanation"
        
        case fiftyDayMA = "day50MovingAvg"
        case twoHundredDayMA = "day200MovingAvg"
        
        case fiftyTwoWeekHigh = "week52high"
        case fiftyTwoWeekLow = "week52low"
        
        //"week52high": 156.65,
        //"week52low": 93.63,
        
    }
    
    init(from decoder: Decoder) throws {
        
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.fiftyDayMA = try valueContainer.decode(Float.self, forKey: CodingKeys.fiftyDayMA)
        self.twoHundredDayMA = try valueContainer.decode(Float.self, forKey: CodingKeys.twoHundredDayMA)
        
        self.fiftyTwoWeekHigh = try valueContainer.decode(Float.self, forKey: CodingKeys.fiftyTwoWeekHigh)
        self.fiftyTwoWeekLow = try valueContainer.decode(Float.self, forKey: CodingKeys.fiftyTwoWeekLow)
        
        //print("52 week high is \(self.fiftyTwoWeekHigh)")
        
        
    }
}
