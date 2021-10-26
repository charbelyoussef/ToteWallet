//
//  RegisterVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class RegistrationSuccessfulVC : UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Class Outlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var btnVerifyByEmail: UIButton!
    @IBOutlet weak var btnVerifyByPhone: UIButton!
    @IBOutlet weak var btnGoToLogin: UIButton!
    
    // MARK: Class Variables
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        setupDismissOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ConfigurationManager.setSecondaryExtraLightThemeBGColorForViews(views: [btnVerifyByEmail])
        ConfigurationManager.setSecondaryThemeBGColorForViews(views: [btnVerifyByPhone])
        ConfigurationManager.setSecondaryLighterThemeBGColorForViews(views: [btnGoToLogin])
        //        vContainer.addCornerRadius(corners: .allCorners, cornerRadius: 10)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK : Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerToRegisterationSuccessful" {
//            let vc = segue.destination as? UIViewController
//            if vc != nil{
////                if let indexPath = tvContent.indexPathForSelectedRow{
////                    // set presented view controller data
////                }
//            }
        }
    }
    
    // MARK : Custom Methods
    
    
    // MARK: Button Handlers
    @IBAction func btnVerifyByEmailAction(_ sender: Any) {
        
    }
    
    @IBAction func btnVerifyByPhoneAction(_ sender: Any) {
        
    }
    
    @IBAction func btnGoToLoginAction(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: LoginVC.self)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
