//
//  MainScreenVC.swift
//  Stock_IEX_API
//
//  Created by Shane Talbert on 8/13/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import UIKit

class MainScreenVC: UIViewController, SaveStock, SymbolNetworkCallDelegate {
    
    @IBOutlet weak var tblStockList: UITableView!
    @IBOutlet weak var stockBarView: StockBarView!
    
    //this will be the instance of the current Network call which will hold the 2 structs of the current stock
    var currentNetworkCallForStockInList: SymbolNetworkCall?
    
    //empty array of stocklist
    var stockList = [String : String]()
    
    //set that will be built to build the table view and hopefully will be able to maintain an ordered pair...
    var stockSymbols = Set<String>()
    
    //this will be used to fill the table view
    var unorderedStockSymbols = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray
        
        print("stockList has \(stockList.count) count")
        if stockList.count == 0 {
            //load the dictionary as NSUserDefaults
            let posStoredVals = UserDefaults.standard.object(forKey: "storedStocksDict")
            if let storedValues = posStoredVals as? Dictionary<String, String> {
                stockList = storedValues
            }
            
        }
        
        tblStockList.delegate = self
        tblStockList.dataSource = self
        
        currentNetworkCallForStockInList = SymbolNetworkCall()
        
        //I think this will be differentiated by the fact it is a diff instance...
        currentNetworkCallForStockInList?.delegate = self
        
        configureTableView()
        //tblStockList.reloadData()
        displayTableData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print("view did appear")

    }
    
    //need to overwrite prepare for seague and cast as? second Vc and set this VC as the delegete.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("prepare for seaue was called...")
        
        //do I have to name the segue??? searchVC is name of segue from MainScreen to SearchAddVC
        if segue.identifier == "searchVC" {
            if let destination = segue.destination as? SearchAddVC {
                destination.delegate = self
            }
        }
        
    }
    
    func didFinishLoadingSymbol() {
        //This is the delegate that will be called when the network call is finished loading
        
        //This is where we will need to fill the new struct Stock with 2 structs that are used for the JSON call
        print("fill the new Struct")
        //Don't think this is the case???
        //Maybe the struct should fill out inside the model class Symbol network call.  This way I wont have to do it 2 times one in the search VC and the other in the main VC...
      
        //stop the spinner that is in the StockBarView...
        stockBarView.spinner.stopAnimating()
        
        //may need to make sure they are not nil?
        stockBarView.updateStockBarView(stockInfo: (currentNetworkCallForStockInList?.currentStockInfo)!, stockStats: (currentNetworkCallForStockInList?.currentStockStats)!)
    }
    
    func displayTableData () {
        
        //This function that will prepare the arrays and then reload the data
        
        //the _ disregard the value in the dictionary...
        //making a set that will be an array of stockSymbol symbols
        for (key, _) in stockList {
            stockSymbols.insert(key)
        }
        
        //print(stockSymbols.description)
        
        //This is making an array from the set.  Will need to clear out the array to begin with...
        unorderedStockSymbols.removeAll()
        
        for stockSymbol in stockSymbols {
            unorderedStockSymbols.append(stockSymbol)
            
        }
        
        tblStockList.reloadData()
        
    }
    
    
    //this will be called when a stock to save is passed back from the SearchAddVC
    //This function will pass a StructInfo back as a delegate once the add stock button is pressed inside the SearchAddVC.
    func saveThisStock(stockInfo: StockInfo) {
        
        //note this will be called before view did appear...

        //storing the Stock Info into Dictionary [String : String]
        stockList[stockInfo.symbol] = stockInfo.companyName
        //print(stockList.description)
        
        //Save the dictionary as NSUserDefaults
        //UserDefaults.standard.set(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
        UserDefaults.standard.set(stockList, forKey: "storedStocksDict")
        
        displayTableData()
        
    }


}


extension MainScreenVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unorderedStockSymbols.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblStockList.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockTableCell
        cell.lblStockSymbol.text = unorderedStockSymbols[indexPath.row]
        //now I will need to look up the dictionary value for that symbol
        let stockName = stockList[unorderedStockSymbols[indexPath.row]]
        cell.lblStockName.text = stockName
        
        return cell
    }
    
    func configureTableView() {
        tblStockList.estimatedRowHeight = 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected indexPath.row \(indexPath.row)    ....    Or, in friendlier terms \(unorderedStockSymbols[indexPath.row])")
        
        //start the spinner that is in the StockBarView...
        stockBarView.spinner.startAnimating()
        
        //Making the network call, should call the delegate function when the call is completed...
        currentNetworkCallForStockInList?.requestStockInfo(stockSymbol: unorderedStockSymbols[indexPath.row])
        
        
        
        
    }
    
    
}
