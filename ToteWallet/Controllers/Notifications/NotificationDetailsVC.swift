//
//  NotificationDetailsVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class NotificationDetailsVC: UIViewController {
    
    // MARK: Class Outlets
    
    @IBOutlet weak var lblTransactionId: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTargetId: UILabel!
    @IBOutlet weak var tvInfo: UITextView!
    
    // MARK: Class Variables
    var notificationDetails:Alert?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        ConfigurationManager.setPrimaryLighterThemeBGColorAsTextForObjects(objects: [tvTitle])
        lblTransactionId.text = "\(notificationDetails?.id ?? -1)"
        lblTitle.text = notificationDetails?.title
        lblTargetId.text = notificationDetails?.targetId
        tvInfo.text = notificationDetails?.message
    }
    
    // MARK: Button Handlers
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        revealMenu()
    }

}
