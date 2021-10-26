//
//  WalletsVCDefaultCell.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/9/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class WalletsVCDefaultCell: UITableViewCell {

    
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnTransactions: UIButton!
    @IBOutlet weak var btnLimits: UIButton!
    @IBOutlet weak var lblWalletType: UILabel!
    @IBOutlet weak var lblAvailableBalanceTitle: UILabel!
    @IBOutlet weak var lblAvailableBalanceValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(wallet:Wallet?){
        if let walletTemp = wallet {
            lblName.text = walletTemp.alias
            lblWalletType.text = walletTemp.type
            lblAvailableBalanceTitle.text = "Available Balance"
            lblAvailableBalanceValue.text = "TIPs \(walletTemp.balance)"
            ConfigurationManager.setSecondaryLighterThemeBGColorForViews(views: [btnTransactions, btnLimits])
            btnTransactions.layer.cornerRadius = 5
            btnLimits.layer.cornerRadius = 5
            
            vContent.addCornerRadius(corners: .allCorners, cornerRadius: 5)
            vContent.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().bgColor ?? "")
        }
    }
}
