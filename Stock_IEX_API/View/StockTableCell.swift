//
//  StockTableCell.swift
//  Stock_IEX_API
//
//  Created by Shane Talbert on 8/16/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import UIKit

class StockTableCell: UITableViewCell {
    
    @IBOutlet weak var lblStockSymbol: UILabel!
    @IBOutlet weak var lblStockName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
