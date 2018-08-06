//
//  ViewController.swift
//  Stock_IEX_API
//
//  Created by Shane Talbert on 6/23/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblStockSymbol: UILabel!
    @IBOutlet weak var lblLatestPrice: UILabel!
    @IBOutlet weak var lblFiftyDayMA: UILabel!
    @IBOutlet weak var lblTwoHundredDayMA: UILabel!
    
    @IBOutlet weak var txtStockSymbolRequest: UITextField!
    
    @IBOutlet weak var stockBarView: StockBarView!
    
    //going to have to create some vars so that can do math on 2 different sets of structs...
    var lastPrice: Float?
    var fiftyTwoWeekHighPrice: Float?
    var fiftyTwoWeekLowPrice: Float?
    
    //baseURL = "https://api.iextrading.com/1.0"
    //stats will return the moving averages" stock/aapl/stats
    //will be helpful to pull both stats and quote...
    //start off with just the quote and create a model object first. (struct)
    
    //should not have to map out everything, just what I want to store and show...
//    let baseUrl = URL(string: "https://api.iextrading.com/1.0/stock/aapl/quote")!
//    let suffixUrl = URL(string: "https://api.iextrading.com/1.0/stock/aapl/stats")!
    let baseUrl = "https://api.iextrading.com/1.0/stock/"
    let suffixUrlStats = "/stats"
    let suffixUrlQuote = "/quote"
    
    //try for now the quote will map out to the StockInfo Struct
    //the stats should map out to the same struct, but may need to let the second call stuff be optionals?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    func requestStockInfo () {
        
        //let networkTask = URLSession.shared.dataTask(with: <#T##URL#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
        let urlString = baseUrl + txtStockSymbolRequest.text! + suffixUrlQuote
        let url1 = URL(string: urlString)!
        let networkTask1 = URLSession.shared.dataTask(with: url1) { (data, response, error) in
            //This is the network request can use the 3 variables data, response and error
            let jsonDecoder = JSONDecoder()
            if let dataToDecode = data {
                if let stockInfo = try? jsonDecoder.decode(StockInfo.self, from: dataToDecode) {
                    //print(stockInfo)
                    DispatchQueue.main.async {
                        self.lblCompanyName.text = stockInfo.companyName
                        self.lblStockSymbol.text = stockInfo.symbol
                        self.lblLatestPrice.text = "\(stockInfo.latestPrice)"
                        
                        //update the StockBarView
                        self.stockBarView.priceLabel.text = "Price \(stockInfo.latestPrice)"
                        
                        //get value
                        self.lastPrice = stockInfo.latestPrice
                    }
                    
                    //print(response ?? "response for stock info")
                    
                } else {
                    print("else statement")
                }
            }
        }//end of closure
        
        let urlString2 = baseUrl + txtStockSymbolRequest.text! + suffixUrlStats
        let url2 = URL(string: urlString2)!
        let networkTask2 = URLSession.shared.dataTask(with: url2) { (data, response, error) in
            //closure code
            let jDecoder = JSONDecoder()
            if let dataToDecode = data {
                if let stockStats = try? jDecoder.decode(StockStats.self, from: dataToDecode) {
                    //print(stockStats)
                    DispatchQueue.main.async {
                        self.lblFiftyDayMA.text = "\(stockStats.fiftyDayMA)"
                        self.lblTwoHundredDayMA.text = "\(stockStats.twoHundredDayMA)"
                        
                        //update the StockBarView
                        self.stockBarView.fiftyTwoWeekHighLabel.text = "52 week high \(stockStats.fiftyTwoWeekHigh)"
                        self.stockBarView.fiftyTwoWeekLowLabel.text = "52 week low \(stockStats.fiftyTwoWeekLow)"
                        self.stockBarView.fiftyDayMALabel.text = "50 MA \(stockStats.fiftyDayMA)"
                        self.stockBarView.twoHundredDayMALabel.text = "200 MA \(stockStats.twoHundredDayMA)"
                        
                        //get values
                        self.fiftyTwoWeekHighPrice = stockStats.fiftyTwoWeekHigh
                        self.fiftyTwoWeekLowPrice = stockStats.fiftyTwoWeekLow
                        
                        self.calculateAndUpdateGraph()
                        //self.stockBarView.refresh()
                        self.stockBarView.setNeedsDisplay()
                        //self.view.setNeedsDisplay()
                    }
                    
                    //print(response ?? "response for stock stats")
                    
                }
            }
        }
        
        //this is actually calling the network call.
        networkTask1.resume()
        networkTask2.resume()
        
        //now that we have both sets of vals
        //or maybe we dont have the vals
        //calculateAndUpdateGraph()
        //view.setNeedsDisplay()
        
        
        
    }
    
    func calculateAndUpdateGraph () {
        
        //let spread = stockHigh - stockLow
        
        //need to properly unwrap the optional, sometimes it is still nil, think the network call may be laggy?
        if (fiftyTwoWeekLowPrice != nil && fiftyTwoWeekHighPrice != nil && lastPrice != nil) {
            //let spread = fiftyTwoWeekHighPrice! - fiftyTwoWeekLowPrice!
            //let pctInGraph = (lastPrice! - fiftyTwoWeekLowPrice!) / spread
            //stockBarView.pricePosition = CGFloat(pctInGraph)
            
            //this sometimes updates with a weird number and requires a 2nd update to get correct.
            //has not happened since I am checking all optionals
            //print("pct in graph \(pctInGraph)")
            //This will give the pct full to make the bar graph
            //let pctInGraph = (value - stockLow) / spread
            
            //stockBarView.updateBarPositions(priceOfStock: lastPrice!)
            stockBarView.updateBarPositions(priceOfStock: lastPrice!, fiftyTwoWeekHighStock: fiftyTwoWeekHighPrice!, fiftyTwoWeekLowStock: fiftyTwoWeekLowPrice!)
            
        } else {
            print("1 of the 3 variables were nil, try again")
        }
        
        
        
    }
    
    
    @IBAction func searchForStockSymbolPressed(_ sender: UIButton) {
        
        //print("search pressed")
        requestStockInfo()
    }
    
    


}

