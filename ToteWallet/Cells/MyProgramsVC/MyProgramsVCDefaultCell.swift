//
//  WalletsVCDefaultCell.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/9/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class MyProgramsVCDefaultCell: UITableViewCell {

    
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var btnRefer: UIButton!
    @IBOutlet weak var btnSell: UIButton!
    @IBOutlet weak var lblQuantityPurchasedTitle: UILabel!
    @IBOutlet weak var lblQuantityPurchasedValue: UILabel!
    @IBOutlet weak var lblBalanceTitle: UILabel!
    @IBOutlet weak var lblBalanceValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(program:MyProgram?){
        if let myProgram = program {
            lblName.text = myProgram.productName
            lblQuantityPurchasedTitle.text = "Quantity Purchased:"
            lblQuantityPurchasedValue.text = myProgram.quantity
            lblBalanceTitle.text = "Balance:"
            lblBalanceValue.text = myProgram.balance
            ConfigurationManager.setSecondaryLighterThemeBGColorForViews(views: [btnDetails, btnRefer, btnSell])
            btnDetails.layer.cornerRadius = 5
            btnRefer.layer.cornerRadius = 5
            btnSell.layer.cornerRadius = 5

            vContent.addCornerRadius(corners: .allCorners, cornerRadius: 5)
            vContent.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().bgColor ?? "")
        }
    }
}
