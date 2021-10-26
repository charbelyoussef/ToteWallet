//
//  RegisterVCPhoneCell.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class LimitsVCDefaultCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var vTfContainer: CustomTextFieldContainerView!
    @IBOutlet weak var tfValue: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tfValue.setPadding(left: 5, right: 5)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
