//
//  RegisterVCNotificationsCell.swift
//  White Labelled App
//
//  Created by Charbel Youssef on 1/17/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class RegisterVCNotificationsCell: UITableViewCell {

//    @IBOutlet weak var btnNotifications: NDCheckBox!
//    @IBOutlet weak var btnUpdates: NDCheckBox!
//    @IBOutlet weak var btnOffers: NDCheckBox!
//    @IBOutlet weak var btnGdpr: NDCheckBox!
    @IBOutlet weak var btnPrivacyPolicy: CustomCheckBox!
    
    @IBOutlet weak var btnShowTermsAndConditions: UIButton!
    @IBOutlet weak var btnShowPrivacyDialog: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let configColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimary ?? "")

        DispatchQueue.main.async {
            self.btnPrivacyPolicy.setup(selectedBGColor: configColor, deselectedBGColor: UIColor.white, checkColor: UIColor.white, borderColor: configColor, selected: false)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
