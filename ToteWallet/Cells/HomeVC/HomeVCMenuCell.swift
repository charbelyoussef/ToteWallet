//
//  HomeVCMenuCell.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/9/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class HomeVCMenuCell: UICollectionViewCell {
    
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(index: Int){
        switch index {
            case HomeVC.CVSections.BuyTips.rawValue:
                lblTitle.text = "Buy Tips"
                ivIcon.image = UIImage(named: "buyTips")
            
            case HomeVC.CVSections.Marketplace.rawValue:
                lblTitle.text = "Marketplace"
                ivIcon.image = UIImage(named: "marketplace")
            
            case HomeVC.CVSections.RequestTips.rawValue:
                lblTitle.text = "Request Tips"
                ivIcon.image = UIImage(named: "requestTips")
            
            case HomeVC.CVSections.SendTips.rawValue:
                lblTitle.text = "Send Tips"
                ivIcon.image = UIImage(named: "sendTips")
            
            case HomeVC.CVSections.Join.rawValue:
                lblTitle.text = "Membership"
                ivIcon.image = UIImage(named: "membership")
            
            case HomeVC.CVSections.GetGrowGain.rawValue:
                lblTitle.text = "Get Grow Gain"
                ivIcon.image = UIImage(named: "get-grow-gain-logo")
        default:
            break
        }
        ivIcon.layer.cornerRadius = ivIcon.frame.size.height/2
//        tintColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexSecondaryLighter ?? "")
    }
}
