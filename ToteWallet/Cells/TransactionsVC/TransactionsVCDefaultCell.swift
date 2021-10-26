//
//  TransactionsVCDefaultCell.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/19/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class TransactionsVCDefaultCell: UITableViewCell {

    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSender: UILabel!
    @IBOutlet weak var lblRecipient: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var cstrBtnExpandHeight: NSLayoutConstraint!
    @IBOutlet weak var vContainerView: UIView!
    
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
    
    func configureCell(indexPath:IndexPath, transaction: Transaction?){
//        lblDate.text = transaction?.date?.toString(format: "MMM dd, YYYY")
//        if indexPath.row % 2 == 0 {
            vContainer.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().bgColor ?? "")
//        }
        btnExpand.setTitleColor(UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimaryLighter ?? ""), for: .normal)
        lblDate.text = transaction?.date
        lblSender.text = transaction?.senderOwnerName
        lblRecipient.text = transaction?.receiverOwnerName
        lblAmount.text = "\(transaction?.baseAmount ?? 0) \(transaction?.senderCurrencySymbol ?? "N/A")"
        lblDescription.text = transaction?.desc
        maxDescriptionLines = lblDescription.getActualLineNumber()
    }

}
