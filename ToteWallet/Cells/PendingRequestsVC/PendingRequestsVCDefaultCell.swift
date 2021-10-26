//
//  TransactionsVCDefaultCell.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/19/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class PendingRequestsVCDefaultCell: UITableViewCell {

    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSender: UILabel!
    @IBOutlet weak var lblRecipient: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var cstrBtnExpandHeight: NSLayoutConstraint!
    @IBOutlet weak var vContainerView: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var svButtonsContainer: UIStackView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    var maxDescriptionLines = 0
    var notificationsOpen = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        vContainer.layer.cornerRadius = 10
    }
    
    func configureCell(indexPath:IndexPath, pendingRequest: PendingRequest?){
//        lblDate.text = transaction?.date?.toString(format: "MMM dd, YYYY")
//        if indexPath.row % 2 == 0 {
            vContainer.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().bgColor ?? "")
//        }
        btnExpand.setTitleColor(UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimaryLighter ?? ""), for: .normal)

        lblDate.text = pendingRequest?.date
//        lblSender.text = transaction?.senderOwnerName
        lblRecipient.text = pendingRequest?.receiverOwnerName
        lblAmount.text = "\(pendingRequest?.baseAmount ?? "N/A") TIPS"
        lblDescription.text = pendingRequest?.desc
        maxDescriptionLines = lblDescription.getActualLineNumber()
        
        if pendingRequest?.statusName == "Other" {
            lblStatus.text = ""
            lblStatus.isHidden = true
            svButtonsContainer.isHidden = false
        }
        else{
            svButtonsContainer.isHidden = true
            lblStatus.isHidden = false
            lblStatus.text = pendingRequest?.statusName
        }
        
    }
}
