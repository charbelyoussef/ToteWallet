//
//  RegisterVCRegisterButtonCell.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class RegisterVCRegisterButtonCell: UITableViewCell {

    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var btnRegister: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ConfigurationManager.setPrimaryLighterThemeBGColorForViews(views: [btnRegister])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
