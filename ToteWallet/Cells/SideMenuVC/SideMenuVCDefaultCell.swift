//
//  SideMenuVCDefaultCell.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/22/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class SideMenuVCDefaultCell: UITableViewCell {

    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
