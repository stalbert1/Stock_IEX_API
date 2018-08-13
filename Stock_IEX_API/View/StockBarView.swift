//
//  StockBarView.swift
//  Bar_Graph_Demo_Stock_Price
//
//  Created by Shane Talbert on 7/29/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import UIKit

//This caused my storyboard to crash.
//In other example you could see the code inside the custom view
//@IBDesignable

class StockBarView: UIView {
    
    //this will be set in setup and crete the window size as what is created in storyboard.
    var windowSize = CGRect()
    
    //self children Views
    //Needed so that the labels will be deleted...
    private var priceLabel = UILabel()
    private var fiftyTwoWeekHighLabel = UILabel()
    private var fiftyTwoWeekLowLabel = UILabel()
    private var fiftyDayMALabel = UILabel()
    private var twoHundredDayMALabel = UILabel()
    
    //self children view
    private var barGraphView = UIView()
    //barGraphView children Views
    private var priceBar = UIView()
    private var fiftyDayMA = UIView()
    private var twoHundredDayMAView = UIView()
    
    private var heightView: CGFloat!
    private var widthView: CGFloat!
    
    // IB Inspectable has to be explicit type.  Type can not be inferred.
    //@IBInspectable
    var backColor: UIColor = UIColor.black

    override init(frame: CGRect) {
        super.init(frame: frame)
        print("override init called")
        //this one will only be called if created from code
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //this is called when my View is created in the storyboard
        print("required init with coder")
        setup()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    
    func updateStockBarView (stockInfo: StockInfo, stockStats: StockStats) {
 
    
        //determining the height of the price bar, 50 and 200 day MA bars.
        let metricBarHeight = heightView * 0.02
        
        //Calculating the position of the current price of the stock bar
        let spread = stockStats.fiftyTwoWeekHigh - stockStats.fiftyTwoWeekLow
        let pricePctInGraph = (stockInfo.latestPrice - stockStats.fiftyTwoWeekLow) / spread
        var pricePos = heightView - (heightView * CGFloat(pricePctInGraph))
        //now correct for thickness of line
        pricePos = pricePos - (metricBarHeight / 2)
        
        //adding the price bar
        priceBar.frame = CGRect(x: 0, y: pricePos, width: widthView, height: metricBarHeight)
        priceBar.backgroundColor = UIColor.red
        barGraphView.addSubview(priceBar)
        
        
        //Calculating the position of the 50 day moving average price in the stock bar
        let fiftyMAPctInGraph = (stockStats.fiftyDayMA - stockStats.fiftyTwoWeekLow) / spread
        var fiftyMAPos = heightView - (heightView * CGFloat(fiftyMAPctInGraph))
        fiftyMAPos = fiftyMAPos - (metricBarHeight / 2)
        
        //adding the 50 day moving average bar
        fiftyDayMA.frame = CGRect(x: 0, y: fiftyMAPos, width: widthView, height: metricBarHeight)
        fiftyDayMA.backgroundColor = UIColor.green
        barGraphView.addSubview(fiftyDayMA)
        
        //Calculating the position of the 200 day moving average price in the stock bar
        let twoHundredMAPctInGraph = (stockStats.twoHundredDayMA - stockStats.fiftyTwoWeekLow) / spread
        var twoHundredMAPos = heightView - (heightView * CGFloat(twoHundredMAPctInGraph))
        twoHundredMAPos = twoHundredMAPos - (metricBarHeight / 2)
        
        //adding the 200 day moving average bar
        twoHundredDayMAView.frame = CGRect(x: 0, y: twoHundredMAPos, width: widthView, height: metricBarHeight)
        twoHundredDayMAView.backgroundColor = UIColor.cyan
        barGraphView.addSubview(twoHundredDayMAView)
        
        
        //do a function that passes in a price and price pct in graph and get back a correction factor...
        //determine the y pos of price label
        var priceLabelPosY: CGFloat = pricePos * 1.07
        //print("Price Pct in graph is \(pricePctInGraph)")
        //print("priceLabelYPos start is \(priceLabelPosY)")
        
        //if stock is at 52 week high the pcice pct in graph is close to 1.00 as 100 percent
        if pricePctInGraph > 0.8 {
            priceLabelPosY = priceLabelPosY + 20
        } else if pricePctInGraph < 0.3 {
            priceLabelPosY = priceLabelPosY - 10
        }
     
        //adding labels to self not the barGraphView
        priceLabel.frame = CGRect(x: 20, y: priceLabelPosY, width: 200, height: 21)
        priceLabel.text = "Price \(stockInfo.latestPrice)"
        priceLabel.textColor = .red
        priceLabel.textAlignment = .left
        self.addSubview(priceLabel)
        
        //52 week High label
        fiftyTwoWeekHighLabel.frame = CGRect(x: windowSize.midX - 100, y: 2, width: 200, height: 21)
        fiftyTwoWeekHighLabel.text = "52 Week High \(stockStats.fiftyTwoWeekHigh)"
        fiftyTwoWeekHighLabel.textColor = .white
        fiftyTwoWeekHighLabel.textAlignment = .center
        self.addSubview(fiftyTwoWeekHighLabel)
        
        //52 week Low label
        fiftyTwoWeekLowLabel.frame = CGRect(x: windowSize.midX - 100, y: windowSize.height - 25, width: 200, height: 21)
        fiftyTwoWeekLowLabel.text = "52 Week Low \(stockStats.fiftyTwoWeekLow)"
        fiftyTwoWeekLowLabel.textColor = .white
        fiftyTwoWeekLowLabel.textAlignment = .center
        self.addSubview(fiftyTwoWeekLowLabel)
        
        //50 Day MA Label
        fiftyDayMALabel.frame = CGRect(x: windowSize.midX + 50, y: (fiftyMAPos * 1.07), width: 200, height: 21)
        fiftyDayMALabel.text = "50 MA \(stockStats.fiftyDayMA)"
        fiftyDayMALabel.textColor = .green
        fiftyDayMALabel.textAlignment = .left
        self.addSubview(fiftyDayMALabel)
        
        //200 Day MA Label
        twoHundredDayMALabel.frame = CGRect(x: windowSize.midX + 50, y: (twoHundredMAPos * 1.07), width: 200, height: 21)
        twoHundredDayMALabel.text = "200 MA \(stockStats.twoHundredDayMA)"
        twoHundredDayMALabel.textColor = .cyan
        twoHundredDayMALabel.textAlignment = .left
        self.addSubview(twoHundredDayMALabel)
        
    }

    func setup() {
        
        print("StockBarView setup called")
        backgroundColor = backColor
        
        //print("selfs super view is \(String(describing: self.superview))")
        
        windowSize = self.bounds
        
        heightView = windowSize.height * 0.85
        let yPos = windowSize.height * 0.075
        widthView = windowSize.width * 0.25
        let xPos = windowSize.midX - (widthView / 2)
        
        barGraphView.frame = CGRect(x: xPos, y: yPos, width: widthView, height: heightView)
        barGraphView.backgroundColor = UIColor.gray
        //adding the barView to self
        addSubview(barGraphView)
 
        //print("the size of bounds is  \(self.bounds)")
        //print("trying to find the correct one frame \(self.frame)")
        
    }
    
/*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
*/
 

}
