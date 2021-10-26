//
//  MembershipVCDefaultCell.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/23/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class MembershipVCDefaultCell: UITableViewCell {
    @IBOutlet weak var btnMembership: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var ivMembershipIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
