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
        
        
    }
}
