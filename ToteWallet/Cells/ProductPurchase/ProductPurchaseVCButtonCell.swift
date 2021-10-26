//
//  RegisterVCRegisterButtonCell.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class ProductPurchaseVCButtonCell: UITableViewCell {

    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnPurchase: RoundedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ConfigurationManager.setSecondaryLighterThemeBGColorForViews(views: [btnCancel, btnPurchase])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
