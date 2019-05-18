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
    
    //test purposes to see the size of the device
    let screenSize = UIScreen.main.bounds
    
    //self children Views
    //Needed so that the labels will be deleted...
    private var priceLabel = UILabel()
    private var fiftyTwoWeekHighLabel = UILabel()
    private var fiftyTwoWeekLowLabel = UILabel()
    private var fiftyDayMALabel = UILabel()
    private var twoHundredDayMALabel = UILabel()
    private var pctChangeLabel = UILabel()
    private var volVelocityLabel = UILabel()
    
    //self children view
    private var barGraphView = UIView()
    //barGraphView children Views
    private var priceBar = UIView()
    private var fiftyDayMA = UIView()
    private var twoHundredDayMAView = UIView()
    
    private var arrowImageView = UIImageView()
    private var arrowImage = UIImage()
    
    private var heightView: CGFloat!
    private var widthView: CGFloat!
    
    // IB Inspectable has to be explicit type.  Type can not be inferred.
    //@IBInspectable
    var backColor: UIColor = UIColor.black

    override init(frame: CGRect) {
        super.init(frame: frame)
        //print("override init called")
        //this one will only be called if created from code
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //this is called when my View is created in the storyboard
        //wondering if this is what is causing this issue?
        //issue is the simulator sizes based on the size that is selected in the storyboard...
        //print("required init with coder")
        setup()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    
    func updateStockBarView (stockInfo: StockInfo, stockStats: StockStats) {
        
        arrowImageView.removeFromSuperview()
    
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
        var arrowPositionY: CGFloat = 0.0
        //print("Price Pct in graph is \(pricePctInGraph)")
        //print("priceLabelYPos start is \(priceLabelPosY)")
        
        //Determining the position of... priceLabelY and arrowPositionY
        
        //Concept is will be splitting the left side view into 2 halfs.  If the price label is top half place the arrow position at bottom half.  The arrow will only be in 1 of 2 positions.  Same with the label that shows the pct change...
        
        //if stock is at 52 week high the pcice pct in graph is close to 1.00 as 100 percent
        if pricePctInGraph > 0.8 {
            priceLabelPosY = priceLabelPosY + 20
        } else if pricePctInGraph < 0.3 {
            priceLabelPosY = priceLabelPosY - 10
        }
        
        if pricePctInGraph > 0.5 {
            //will need to set the position for arrow and pct label at bottom position
            arrowPositionY = heightView - (heightView * 0.25)
        } else {
            //will need to set the position for arrow and pct label at top position
            arrowPositionY = heightView * 0.15
        }
     
        //adding labels to self not the barGraphView
        priceLabel.frame = CGRect(x: 20, y: priceLabelPosY, width: 200, height: 21)
        priceLabel.text = "Price \(stockInfo.latestPrice)"
        priceLabel.textColor = .red
        priceLabel.textAlignment = .left
        self.addSubview(priceLabel)
        
        //52 week High label
        fiftyTwoWeekHighLabel.frame = CGRect(x: windowSize.midX - 100, y: 2, width: 200, height: 21)
        fiftyTwoWeekHighLabel.text = "52 Wk High \(stockStats.fiftyTwoWeekHigh)"
        fiftyTwoWeekHighLabel.textColor = .white
        fiftyTwoWeekHighLabel.textAlignment = .center
        self.addSubview(fiftyTwoWeekHighLabel)
        
        //52 week Low label
        fiftyTwoWeekLowLabel.frame = CGRect(x: windowSize.midX - 100, y: windowSize.height - 25, width: 200, height: 21)
        fiftyTwoWeekLowLabel.text = "52 Wk Low \(stockStats.fiftyTwoWeekLow)"
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
        
        //print("latest volume is \(stockInfo.latestVolume)")
        
        //1.99914e+06 = 1Million 999140 Thousand  almost 2 million
        //seems to be close to other ones I have checked so far...
        //print("avg total volume is \(stockInfo.avgTotalVolume)")
        
        var imageName: String = ""
        var pctChangeColor: UIColor = UIColor.green
        
        //will show the following asset named...
        if stockInfo.changePercent < 0 {
            imageName = "downArrow"
            pctChangeColor = UIColor.red
        } else {
            imageName = "upArrow"
        }
        
        //add UI image view programmatically and set the pic based on change percent negative or positive...
        arrowImage = UIImage(named: imageName)!
        arrowImageView = UIImageView(image: arrowImage)
        arrowImageView.frame = CGRect(x: 50, y: arrowPositionY, width: 50, height: 100)
        self.addSubview(arrowImageView)
        
        //percentage change label
        pctChangeLabel.frame = CGRect(x: 50, y: (arrowPositionY + 110), width: 200, height: 21)
        //the 2 %% in a row prints the %
        pctChangeLabel.text = String(format: "%.2f%%", (stockInfo.changePercent * 100))
        pctChangeLabel.textColor = pctChangeColor
        pctChangeLabel.textAlignment = .left
        self.addSubview(pctChangeLabel)
        
        //at the end I am not going to show the actual volume only 100% if equal to volume per sec
        //50% if half of volume per second.  If after 4pm seconds = seconds???
        
        //9:30am to 4:00pm 6.5 hours
        //6.5 * 60 = 390 minutes
        //390 * 60 = 23400 seconds in a typical trading day
        
        let currentDay = Date()
        let myCalendar = Calendar(identifier: .gregorian)
        let isWeekend: Bool = myCalendar.isDateInWeekend(currentDay)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM-dd-yy-HH-mm-ss"
        var currDayStr = formatter.string(from: currentDay)
        
        //only have the curr day as a string so I can set the start and end market open times
        currDayStr.removeLast(8)
        let marketOpenStr: String = currDayStr + "09-30-00"
        //let marketCloseStr: String = currDayStr + "16-00-00"
        
        //now that we have the strings we can create a Date object from the strings
        let marketOpen = formatter.date(from: marketOpenStr)
        //dont think I will need market close due to the fact I will be using 23_400 seconds
        //let marketClose = formatter.date(from: marketCloseStr)
        
        let timeSinceOpen = currentDay.timeIntervalSince(marketOpen!)
        
        //This is to determine how many seconds to use, will start by thinking its after hours or the weekend
        var secondsInTradingDay: Int = 23400
    
        if !isWeekend && (timeSinceOpen < 23400 && timeSinceOpen > 0) {
            //It's withing trading time, unless it's a holiday at which time the number will be wonky
            secondsInTradingDay = Int(timeSinceOpen)
            //print("It is within trading time")
        }
        
        //print("Seconds in the trading day is \(secondsInTradingDay)")
        
        //will have to averages to compare avgVolSec and volSec
        let avgVolSec: Int = Int(stockInfo.avgTotalVolume) / 23400
        let volSec: Int = Int(stockInfo.latestVolume) / secondsInTradingDay
        
        //print("AvgVolSec is \(avgVolSec), while the volSec is \(volSec)")
        let pctVolume: Float = Float(volSec) / Float(avgVolSec)
        
        //This is what will need to be displayed...
        //print(pctVolume)
        
        //Volume Velocity Label
        volVelocityLabel.frame = CGRect(x: (windowSize.maxX - 105), y: 2, width: 100, height: 21)
        volVelocityLabel.text = String(format: "VolV %.0f%%", (pctVolume * 100))
        volVelocityLabel.textColor = UIColor.orange
        volVelocityLabel.textAlignment = .right
        self.addSubview(volVelocityLabel)
        
        
        
        
    }// End Function updateStockBarView (stockInfo: StockInfo, stockStats: StockStats)

    func setup() {
        
        print("StockBarView setup called")
        backgroundColor = backColor
        
        //print("selfs super view is \(String(describing: self.superview))")
        
        //tried .frame... no dice
        windowSize = self.bounds
        
        heightView = windowSize.height * 0.85
        let yPos = windowSize.height * 0.075
        widthView = windowSize.width * 0.25
        let xPos = windowSize.midX - (widthView / 2)
        
        barGraphView.frame = CGRect(x: xPos, y: yPos, width: widthView, height: heightView)
        barGraphView.backgroundColor = UIColor.gray
        //adding the barView to self
        addSubview(barGraphView)
 
        print("the window size is \(windowSize)")
        print("the size of bounds is  \(self.bounds)")
        print("trying to find the correct one frame \(self.frame)")
        
        //Try using screenSize
        print("Screen size is... \(screenSize)")
        
    }
 

}
