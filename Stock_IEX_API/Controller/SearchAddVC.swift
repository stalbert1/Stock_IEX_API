//
//  SearchAddVC.swift
//  Stock_IEX_API
//
//  Created by Shane Talbert on 6/23/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import UIKit

protocol SaveStock {
    func saveThisStock (stockInfo: StockInfo)
}

class SearchAddVC: UIViewController, SymbolNetworkCallDelegate {
 
    //Upper part of UI that is eventually going away to be replaced by a table view...
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblStockSymbol: UILabel!

    @IBOutlet weak var txtStockSymbolRequest: UITextField!
    
    //Guaranteed because I drug it out in interface builder...
    @IBOutlet weak var stockBarView: StockBarView!
    
    //Only adding so the button can be disabled
    @IBOutlet weak var btnAddStock: UIButton!
    
    //this will be the instance of the current Network call which will hold the 2 structs of the current stock
    var currentNetworkCallForStock: SymbolNetworkCall?
    
    //This is the delegate used to pass the stockInfo back to the Main Screen VC
    var delegate: SaveStock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentNetworkCallForStock = SymbolNetworkCall()
        currentNetworkCallForStock?.delegate = self
    }
    
    @IBAction func addStockPressed(_ sender: UIButton) {
        
        //disable the button if no valid stock?  Maybe can just check to see if it is nil?
        //print("Add stock pressed.  Will need to send the structInfo of \(String(describing: currentNetworkCallForStock?.currentStockInfo?.companyName))")
        
        //dont think i will need to disable the button, because if the stock info is nil wont call the delegate...
        if let stockToSend = currentNetworkCallForStock?.currentStockInfo {
            delegate?.saveThisStock(stockInfo: stockToSend)
            self.navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    
    func calculateAndUpdateGraph () {
        
        if (currentNetworkCallForStock?.currentStockStats != nil && currentNetworkCallForStock?.currentStockInfo != nil) {
            
            //updating the stockbar view
            stockBarView.updateStockBarView(stockInfo: (currentNetworkCallForStock?.currentStockInfo!)!, stockStats: (currentNetworkCallForStock?.currentStockStats!)!)
            
            //updating the top view
            lblCompanyName.text = currentNetworkCallForStock?.currentStockInfo?.companyName
            lblStockSymbol.text = currentNetworkCallForStock?.currentStockInfo?.symbol
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

