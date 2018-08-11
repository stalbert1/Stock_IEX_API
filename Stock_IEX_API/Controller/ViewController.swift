//
//  ViewController.swift
//  Stock_IEX_API
//
//  Created by Shane Talbert on 6/23/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //Upper part of UI that is eventually going away to be replaced by a table view...
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblStockSymbol: UILabel!
    @IBOutlet weak var lblLatestPrice: UILabel!
    @IBOutlet weak var lblFiftyDayMA: UILabel!
    @IBOutlet weak var lblTwoHundredDayMA: UILabel!
    
    @IBOutlet weak var txtStockSymbolRequest: UITextField!
    
    //Guaranteed because I drug it out in interface builder...
    @IBOutlet weak var stockBarView: StockBarView!
    
    //test timer to see the timing of the network call
    //var timeStart: Date!
    
    var currentStockStats: StockStats?
    var currentStockInfo: StockInfo?
    
    
    
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
        
        //should stamp the start time
        //timeStart = Date()
        
        
    }
    
    func requestStockInfo () {
        
        //let networkTask = URLSession.shared.dataTask(with: <#T##URL#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
        let urlString = baseUrl + txtStockSymbolRequest.text! + suffixUrlQuote
        let url1 = URL(string: urlString)!
        
        //timeStart = Date()
        
        //Start of closure
        let networkTask1 = URLSession.shared.dataTask(with: url1) { (data, response, error) in
            //This is the network request can use the 3 variables data, response and error
            let jsonDecoder = JSONDecoder()
            if let dataToDecode = data {
                if let stockInfo = try? jsonDecoder.decode(StockInfo.self, from: dataToDecode) {
                    
//                    let timeOfCallOne = Date()
//                    let seconds = timeOfCallOne.timeIntervalSince(self.timeStart)
//                    print("\(seconds) seconds have elapsed this is the time of call one")
//
                    //This causes the code to be ran on the main que...
                    DispatchQueue.main.async {
                        self.lblCompanyName.text = stockInfo.companyName
                        self.lblStockSymbol.text = stockInfo.symbol
                        self.lblLatestPrice.text = "\(stockInfo.latestPrice)"
                        
                        //copy the value of the struct to the ivar
                        self.currentStockInfo = stockInfo
                        
//                        let timeOfCallTwo = Date()
//                        let moreSeconds = timeOfCallTwo.timeIntervalSince(self.timeStart)
//                        print("\(moreSeconds) seconds have elapsed this is the time of call two")
                        
                        self.calculateAndUpdateGraph()
                        
                    }
                    
//                    let timeOfOtherCall = Date()
//                    let otherSecs = timeOfOtherCall.timeIntervalSince(self.timeStart)
//                    print("time of other call is \(otherSecs)")
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
                    
                    //print("response is \(String(describing: response))")
                    //This causes the code to be ran on the main que...
                    DispatchQueue.main.async {
                        self.lblFiftyDayMA.text = "\(stockStats.fiftyDayMA)"
                        self.lblTwoHundredDayMA.text = "\(stockStats.twoHundredDayMA)"
                        
                        //copy the value of the struct to the ivar
                        self.currentStockStats = stockStats
                        
                        //self.stockBarView.setNeedsDisplay()
                        
                        //this is where the delay is need to implement a way to trigger the function after the delay??
                        self.calculateAndUpdateGraph()
                    }
                    
                    //print(response ?? "response for stock stats")
                    
                }
            }
        }
        
        //this is actually calling the network call.
        networkTask1.resume()
        networkTask2.resume()
        
      
    }
    
    func calculateAndUpdateGraph () {
        

        //if either is nil, can't pass along otherwise it will crash in the StockBarView class
        if (currentStockStats != nil && currentStockInfo != nil) {
            
            stockBarView.updateStockBarView(stockInfo: currentStockInfo!, stockStats: currentStockStats!)
  
            
        }
        
        
        
        
    }
    
    
    @IBAction func searchForStockSymbolPressed(_ sender: UIButton) {
        
        //first thing is to reset the current one checked to nil
        currentStockStats = nil
        currentStockInfo = nil
       
        requestStockInfo()
      
        //network call may not be finished may have to update a couple of times to get all the info???
        // need to write a delegate that will wait until the network call is finished.
        //While waiting display something to indicate that you are waiting on the network...
        
        //dismiss the keyboard...
        self.view.endEditing(true)
        
//        let timeOfCallTwo = Date()
//        let moreSeconds = timeOfCallTwo.timeIntervalSince(self.timeStart)
//        print("\(moreSeconds) seconds have elapsed this is the time of call three")
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //dismiss the keyboard...
        self.view.endEditing(true)
    }
    
    


}

