//
//  EditProfileVCHeaderImageCell.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/21/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class EditProfileVCHeaderImageCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var btnChangePicture: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
