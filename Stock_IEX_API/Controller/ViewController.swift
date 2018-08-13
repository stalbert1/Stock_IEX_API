//
//  ViewController.swift
//  Stock_IEX_API
//
//  Created by Shane Talbert on 6/23/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SymbolNetworkCallDelegate {
 
    //Upper part of UI that is eventually going away to be replaced by a table view...
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblStockSymbol: UILabel!
    @IBOutlet weak var lblLatestPrice: UILabel!
    @IBOutlet weak var lblFiftyDayMA: UILabel!
    @IBOutlet weak var lblTwoHundredDayMA: UILabel!
    
    @IBOutlet weak var txtStockSymbolRequest: UITextField!
    
    //Guaranteed because I drug it out in interface builder...
    @IBOutlet weak var stockBarView: StockBarView!
    
    //this will be the instance of the current Network call which will hold the 2 structs of the current stock
    var currentNetworkCallForStock: SymbolNetworkCall?
    

    override func viewDidLoad() {
        super.viewDidLoad()
     
        currentNetworkCallForStock = SymbolNetworkCall()
        currentNetworkCallForStock?.delegate = self
        
    }
    
    func calculateAndUpdateGraph () {
        
        
        if (currentNetworkCallForStock?.currentStockStats != nil && currentNetworkCallForStock?.currentStockInfo != nil) {
            
            stockBarView.updateStockBarView(stockInfo: (currentNetworkCallForStock?.currentStockInfo!)!, stockStats: (currentNetworkCallForStock?.currentStockStats!)!)
        }
        
        
    }
    
    
    @IBAction func searchForStockSymbolPressed(_ sender: UIButton) {
        
        currentNetworkCallForStock?.requestStockInfo(stockSymbol: txtStockSymbolRequest.text!)
        
        //dismiss the keyboard...
        self.view.endEditing(true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //dismiss the keyboard...
        self.view.endEditing(true)
    }
    
    func didFinishLoadingSymbol() {
        //this is called when the stock symbol has loaded...
        calculateAndUpdateGraph()
    }
    

}

