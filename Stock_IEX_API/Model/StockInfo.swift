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
    
    //new added items...
    var changePercent: Float
    var latestVolume: Float
    var avgTotalVolume: Float
    
    //things to add under quote or StockInfo
    //"changePercent": -0.01158
    //"latestVolume": 20567140
    //"avgTotalVolume": 29623234
    
    

enum CodingKeys: String, CodingKey {
    
    case symbol
    case companyName
    case latestPrice
    
    //new added items...
    case changePercent
    case latestVolume
    case avgTotalVolume
    
    //if the names did not match up
    //case description = "explanation"
    
    
}

    init(from decoder: Decoder) throws {
        
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.symbol = try valueContainer.decode(String.self, forKey: CodingKeys.symbol)
        self.companyName = try valueContainer.decode(String.self, forKey: CodingKeys.companyName)
        self.latestPrice = try valueContainer.decode(Float.self, forKey: CodingKeys.latestPrice)
        
        //new items added
        self.changePercent = try valueContainer.decode(Float.self, forKey: CodingKeys.changePercent)
        self.latestVolume = try valueContainer.decode(Float.self, forKey: CodingKeys.latestVolume)
        self.avgTotalVolume = try valueContainer.decode(Float.self, forKey: CodingKeys.avgTotalVolume)
        
    }


}
