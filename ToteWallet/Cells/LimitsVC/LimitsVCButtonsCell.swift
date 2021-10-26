//
//  RegisterVCRegisterButtonCell.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class LimitsVCButtonsCell: UITableViewCell {

    @IBOutlet weak var vButtonsContainer: UIView!
    @IBOutlet weak var vContent: UIView!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSave: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vButtonsContainer.layer.cornerRadius = vButtonsContainer.frame.size.height/2
        vButtonsContainer.clipsToBounds = true
        
        ConfigurationManager.setSecondaryThemeBGColorForViews(views: [btnSave])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
