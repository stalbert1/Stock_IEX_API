//
//  SymbolNetworkCall.swift
//  Stock_IEX_API
//
//  Created by Shane Talbert on 8/11/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import Foundation

//protocol for this class that will call when the network has finished loading...
protocol SymbolNetworkCallDelegate {
    func didFinishLoadingSymbol()
}

class SymbolNetworkCall {
    
    public var currentStockStats: StockStats?
    public var currentStockInfo: StockInfo?
    
    public var currentStock: Stock?
    
    var delegate: SymbolNetworkCallDelegate? = nil
    
    //baseURL = "https://api.iextrading.com/1.0"
    //stats will return the moving averages" stock/aapl/stats
    
    //should not have to map out everything, just what I want to store and show...
    //    let baseUrl = URL(string: "https://api.iextrading.com/1.0/stock/aapl/quote")!
    //    let suffixUrl = URL(string: "https://api.iextrading.com/1.0/stock/aapl/stats")!
    private let baseUrl = "https://api.iextrading.com/1.0/stock/"
    private let suffixUrlStats = "/stats"
    private let suffixUrlQuote = "/quote"
    
    //things to add under quote or StockInfo
    //"changePercent": -0.01158
    //"latestVolume": 20567140
    //"avgTotalVolume": 29623234
    
    init() {
        currentStockInfo = nil
        currentStockStats = nil
    }
    
    //this will be the main call
    func requestStockInfo (stockSymbol: String) {
        
        //let networkTask = URLSession.shared.dataTask(with: <#T##URL#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
        let urlString = baseUrl + stockSymbol + suffixUrlQuote
        let url1 = URL(string: urlString)!
        
        //Start of closure
        let networkTask1 = URLSession.shared.dataTask(with: url1) { (data, response, error) in
            //This is the network request can use the 3 variables data, response and error
            let jsonDecoder = JSONDecoder()
            if let dataToDecode = data {
                if let stockInfo = try? jsonDecoder.decode(StockInfo.self, from: dataToDecode) {

                        //copy the value of the struct to the ivar
                        self.currentStockInfo = stockInfo
                    
                    if self.currentStockStats != nil {
                        //this uses the main thread...
                        DispatchQueue.main.async {
                            self.finishedGettingStatsAndInfo()
                        }
                    }


                } else {
                    //print("else statement")
                }
            }
        }//end of closure
        
        let urlString2 = baseUrl + stockSymbol + suffixUrlStats
        let url2 = URL(string: urlString2)!
        let networkTask2 = URLSession.shared.dataTask(with: url2) { (data, response, error) in
            //closure code
            let jDecoder = JSONDecoder()
            if let dataToDecode = data {
                if let stockStats = try? jDecoder.decode(StockStats.self, from: dataToDecode) {

                        //copy the value of the struct to the ivar
                        self.currentStockStats = stockStats
                    
                    if self.currentStockInfo != nil {
                        //this uses the main thread...
                        DispatchQueue.main.async {
                            self.finishedGettingStatsAndInfo()
                        }
                        
                    }

                }
            }
        }
        
        //this is actually calling the network call.
        networkTask1.resume()
        networkTask2.resume()
        
        
    }
    
    //This will fire once the code is reached.  Delayed to wait to info has been received...
    func finishedGettingStatsAndInfo() {
        
        //This is the point in which I need to load the 3rd struct.  ON the 3rd struct I will be able to change the 52 week high and low so that if it is currently in a 52 week high or low it will make the current price be the low or the high...
       
        if delegate != nil {
            
            
            //print(currentStockInfo?.companyName)
            //print(currentStockStats?.fiftyTwoWeekHigh)
            if currentStockStats != nil && currentStockInfo != nil {
                currentStock = Stock(symbol: (currentStockInfo?.symbol)!, companyName: currentStockInfo!.companyName, latestPrice: currentStockInfo!.latestPrice, changePercent: currentStockInfo!.changePercent, latestVolume: currentStockInfo!.latestVolume, avgTotalVolume: currentStockInfo!.avgTotalVolume, fiftyDayMA: currentStockStats!.fiftyDayMA, twoHundredDayMA: currentStockStats!.twoHundredDayMA, fiftyTwoWeekHigh: currentStockStats!.fiftyTwoWeekHigh, fiftyTwoWeekLow: currentStockStats!.fiftyTwoWeekLow)
                
                //will be neccesary to set the correct low and high
                currentStock?.checkStatusOfHighLow()
                currentStock?.printStockDetails()
                
            }
            
            delegate?.didFinishLoadingSymbol()
            print("in the delegarte")
            
        }
        
    }
    
    
}
