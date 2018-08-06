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
    
    //dont think this is the way to go!!!
    var pricePosition: CGFloat = 0.9
    var fiftyMAPosition: CGFloat = 0.4
    var twoMAPosition: CGFloat = 0.2
    
    //self children Views
    var priceLabel = UILabel()
    var fiftyTwoWeekHighLabel = UILabel()
    var fiftyTwoWeekLowLabel = UILabel()
    var fiftyDayMALabel = UILabel()
    var twoHundredDayMALabel = UILabel()
    
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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//    }
    
    //need to make a calculated property
    func updateBarPositions (priceOfStock: Float, fiftyTwoWeekHighStock: Float, fiftyTwoWeekLowStock: Float) {
        
        //here is where we get the 3 floats as the price and we will convert to a pct in the graph and update the 3 bars on the view
        
        let metricBarHeight = heightView * 0.02
        
        //This is the position in % of where the line will be
        //this still needs work line is falling through

        let spread = fiftyTwoWeekHighStock - fiftyTwoWeekLowStock
        let pctInGraph = (priceOfStock - fiftyTwoWeekLowStock) / spread
        
        var pricePos = heightView - (heightView * CGFloat(pctInGraph))
        //now correct for thickness of line
        pricePos = pricePos - (metricBarHeight / 2)
        
        priceBar.frame = CGRect(x: 0, y: pricePos, width: widthView, height: metricBarHeight)
        priceBar.backgroundColor = UIColor.red
        barGraphView.addSubview(priceBar)
        
    }
    
    func refresh() {
        
    
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
        
        print("StockBar View refresh is called")
        //going to have all the things that need to be updated in this function
        //I will call this from the caller to update the UI
        
        //add current price bar
        //each bar would be 2% of the height of the bar
        let metricBarHeight = heightView * 0.02
        
        //This is the position in % of where the line will be
        //this still needs work line is falling through
        
        
        let price = (heightView * pricePosition) - metricBarHeight
        
        //let priceBar = UIView()
        priceBar.frame = CGRect(x: 0, y: price, width: widthView, height: metricBarHeight)
        priceBar.backgroundColor = UIColor.magenta
        barGraphView.addSubview(priceBar)
        
        //need to make it a private ivar or it will not update view correctly
        //let fiftyDayMA = UIView()
        let fiftyMA = (heightView * fiftyMAPosition)
        fiftyDayMA.frame = CGRect(x: 0, y: fiftyMA, width: widthView, height: metricBarHeight)
        fiftyDayMA.backgroundColor = UIColor.green
        barGraphView.addSubview(fiftyDayMA)
        
        //let twoHundredDayMAView = UIView()
        let twoHundredMA = (heightView * twoMAPosition)
        twoHundredDayMAView.frame = CGRect(x: 0, y: twoHundredMA, width: widthView, height: metricBarHeight)
        twoHundredDayMAView.backgroundColor = UIColor.cyan
        barGraphView.addSubview(twoHundredDayMAView)
        
        //adding labels to self not the barGraphView
        //priceLabel.text = ""
        priceLabel = UILabel(frame: CGRect(x: 10, y: 10 + (price * 1.1), width: 200, height: 21))
        priceLabel.textColor = .white
        
        // may not be necessary (e.g., if the width & height match the superview)
        // if you do need to center, CGPointMake has been deprecated, so use this
        //priceLabel.center = CGPoint(x: 160, y: 284)
        
        // this changed in Swift 3 (much better, no?)
        priceLabel.textAlignment = .left
        //priceLabel.text = "Price $32.89"
        self.addSubview(priceLabel)
        
       fiftyTwoWeekHighLabel.text = ""
        fiftyTwoWeekHighLabel = UILabel(frame: CGRect(x: windowSize.midX - 100, y: 2, width: 200, height: 21))
        fiftyTwoWeekHighLabel.textColor = .white
        fiftyTwoWeekHighLabel.textAlignment = .center
        //fiftyTwoWeekHighLabel.text = "52 week high $67.98"
        self.addSubview(fiftyTwoWeekHighLabel)
        
        
         fiftyTwoWeekLowLabel.text = ""
        fiftyTwoWeekLowLabel = UILabel(frame: CGRect(x: windowSize.midX - 100, y: windowSize.height - 25, width: 200, height: 21))
        fiftyTwoWeekLowLabel.textColor = .white
        fiftyTwoWeekLowLabel.textAlignment = .center
        //fiftyTwoWeekLowLabel.text = "52 week low $21.89"
        self.addSubview(fiftyTwoWeekLowLabel)
        
        fiftyDayMALabel.text = ""
        fiftyDayMALabel = UILabel(frame: CGRect(x: windowSize.midX + 50 , y: 76, width: 200, height: 21))
        fiftyDayMALabel.textColor = .white
        fiftyDayMALabel.textAlignment = .left
        //fiftyDayMALabel.text = "50MA $22.56"
        self.addSubview(fiftyDayMALabel)
        
        twoHundredDayMALabel.text = ""
        twoHundredDayMALabel = UILabel(frame: CGRect(x: windowSize.midX + 50, y: 186, width: 200, height: 21))
        twoHundredDayMALabel.textColor = .white
        twoHundredDayMALabel.textAlignment = .left
        //twoHundredDayMALabel.text = "200MA $45.78"
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
        
        self.refresh()
        
    }
    
/*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
*/
 

}
