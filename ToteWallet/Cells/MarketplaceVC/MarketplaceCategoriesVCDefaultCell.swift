//
//  MarketplaceCategoriesVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/16/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class MarketplaceCategoriesVCDefaultCell: UICollectionViewCell {
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(category: MarketplaceCategory){
        lblTitle.text = category.name
        
        ivIcon.layer.cornerRadius = 10
        if let imageFile = category.imageFile, imageFile != ""{
            ivIcon.sd_setImage(with: URL(string: ("\(Constants.urlPrefix)\(imageFile)").safeURL()))
        }
        else{
            ivIcon.image = UIImage(named: ConfigurationManager.getAppConfiguration().defaultLogoImageName ?? "")
        }
    }
}
