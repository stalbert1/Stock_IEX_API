//
//  StockInfo.swift
//  Stock_IEX_API
//
//  Created by Shane Talbert on 6/23/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import Foundation

struct StockInfo: Codable {
    var symbol: String
    var companyName: String
    var latestPrice: Float
    //"latestPrice":184.92,
    
    //var fiftyDayMA: Float?
    //var twoHundredDayMA: Float?

enum CodingKeys: String, CodingKey {
    
    case symbol
    case companyName
    case latestPrice
    //if the names did not match up
    //case description = "explanation"
    
    //case fiftyDayMA
    //case twoHundredDayMA
    
}

    init(from decoder: Decoder) throws {
        
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.symbol = try valueContainer.decode(String.self, forKey: CodingKeys.symbol)
        self.companyName = try valueContainer.decode(String.self, forKey: CodingKeys.companyName)
        self.latestPrice = try valueContainer.decode(Float.self, forKey: CodingKeys.latestPrice)
        
        //self.fiftyDayMA = try valueContainer.decode(Float.self, forKey: CodingKeys.fiftyDayMA)
        //self.twoHundredDayMA = try valueContainer.decode(Float.self, forKey: CodingKeys.twoHundredDayMA)
        
    }


}
