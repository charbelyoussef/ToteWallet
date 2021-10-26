//
//  RegisterVCDefaultCell.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class EditProfileVCDefaultCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var vContent: UIView!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfValue: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    
}
