//
//  NotificationsVCContentCell.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/23/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class NotificationsVCContentCell: UITableViewCell {

    @IBOutlet weak var vContainerView: UIView!
    
    @IBOutlet weak var constBtnReadMoreHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var vSeparator: UIView!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnExpand: UIButton!
    
    var notificationsOpen = false
    var maxDescriptionLines = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vSeparator.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimaryLighter ?? "")
        btnExpand.setTitleColor(UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimaryLighter ?? ""), for: .normal)
        lblTitle.textColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimaryLighter ?? "")
        self.vContainerView.layer.cornerRadius = 10.0
    }
}
