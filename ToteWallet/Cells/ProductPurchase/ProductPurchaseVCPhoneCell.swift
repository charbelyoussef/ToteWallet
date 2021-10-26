//
//  RegisterVCPhoneCell.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class ProductPurchaseVCPhoneCell: UITableViewCell {

    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var vSeparator: UIView!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var btnSelectContact: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vSeparator.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().textFieldsBorderColor ?? "")

        tfValue.setPadding(left: 5, right: 5)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
