//
//  LoginVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class LoginVC : UIViewController, UITextFieldDelegate {
    
    // MARK: Class Outlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tvContent: UITableView!
    
    @IBOutlet weak var btnSelectCountry: UIButton!
    @IBOutlet weak var vSeparator: UIView!
    @IBOutlet weak var tfUsername: CustomTextField!
    
    @IBOutlet weak var tfPassword: CustomTextField!
    
    @IBOutlet weak var btnLogin: RoundedButton!
    @IBOutlet weak var btnRegister: RoundedButton!
    @IBOutlet weak var btnVerifyByEmail: RoundedButton!
    @IBOutlet weak var btnVerifyByPhone: RoundedButton!
    
    @IBOutlet weak var lblNoVerification: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnShowPassword: UIButton!
    
    // MARK: Class Variables
    var contentArray = NSMutableArray()
    var registerObject:Structs.RegisterObject?
    
    var isPasswordShown = false

    var selectedCountry:Country?
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        registerForKeyboardNotifications()
        setupDismissOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentingVCToPresentedVC" {
//            let vc = segue.destination as? UIViewController
//            if vc != nil{
//                if let indexPath = tvContent.indexPathForSelectedRow{
//                    // set presented view controller data
//                }
//            }
        }
    }
    
    // MARK: Custom Methods
    func initViews(){
        if let lastCountryId = UserDefaults.standard.string(forKey: "lastLoggedInlastCountryId"), lastCountryId != "", let country = DataHelper.getcountryForId(countryId: lastCountryId) {
            selectedCountry = country
            btnSelectCountry.setTitle(country.codeWithName, for: .normal)
        }
        else{
            if let appConfig = CoreDataService.getAppConfiguration().first, let countryId = appConfig.countryId {
                if let country = DataHelper.getcountryForId(countryId: countryId) {
                    selectedCountry = country
                    btnSelectCountry.setTitle(country.codeWithName, for: .normal)
                }
            }
        }
        
        if let lastPhoneNumber = UserDefaults.standard.string(forKey: "lastLoggedInlastPhoneNumber"), lastPhoneNumber != ""{
            tfUsername.text = lastPhoneNumber
        }

        ConfigurationManager.setPrimaryThemeBGColorForViews(views: [btnRegister])
        ConfigurationManager.setPrimaryLighterThemeBGColorForViews(views: [btnLogin])
        
        vSeparator.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().textFieldsBorderColor ?? "")

        ConfigurationManager.setPrimaryLighterThemeBGColorAsTextForObjects(objects: [lblNoVerification, btnVerifyByPhone, btnVerifyByEmail])
        
        let primaryLightColor = ConfigurationManager.getAppConfiguration().themeBGColorHexPrimaryLighter
        
        btnVerifyByEmail.layer.borderWidth = 1.0
        btnVerifyByEmail.layer.borderColor = UIColor(hexString: primaryLightColor ?? "").cgColor
        
        btnVerifyByPhone.layer.borderWidth = 1.0
        btnVerifyByPhone.layer.borderColor = UIColor(hexString:primaryLightColor ?? "").cgColor
        
        tfUsername.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
        tfPassword.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: true)
    }
    
    func getLoggedInUser() -> Login?{
        return CoreDataService.getLogin()
    }

    func showVerifyEmailAlert() {
        let alertController = UIAlertController(title: "Tote Wallet", message: "Kindly fill the following fields", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter email here"
            textField.customize(keyboardType: .emailAddress, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter token here"
        }
        
        let okAction = UIAlertAction(title: "Send", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let emailTf = alertController.textFields![0] as UITextField
            let tokenTf = alertController.textFields![1] as UITextField

            if let email = emailTf.text, email != "", let token = tokenTf.text, token != "" {
                User.shared.emailVerification(token: token, email: email)
            }
            else{
                self.showAlertWithCompletion(message: Constants.Errors.ERROR_FILL_ALL_FIELDS, okTitle: "Ok", cancelTitle: "") {
                    self.showVerifyEmailAlert()
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in } )
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showVerifyPhoneAlert() {
        let alertController = UIAlertController(title: "Tote Wallet", message: "Kindly fill the following fields", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Phone Number here"
            textField.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)

        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter token here"
        }
        
        let okAction = UIAlertAction(title: "Send", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let phoneNumberTf = alertController.textFields![0] as UITextField
            phoneNumberTf.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)

            let tokenTf = alertController.textFields![1] as UITextField
            
            guard let lastCountryCode = UserDefaults.standard.string(forKey: "lastCountryCode"), lastCountryCode != "" else{
                self.showAlertWithCompletion(message: "You should complete the registration process first", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
                return
            }
            
            if let phoneNumber = phoneNumberTf.text, phoneNumber != "", let token = tokenTf.text, token != "" {
                User.shared.phoneVerification(token: token, phoneCountry: lastCountryCode, phone: phoneNumber)
            }
            else {
                self.showAlertWithCompletion(message: Constants.Errors.ERROR_FILL_ALL_FIELDS, okTitle: "Ok", cancelTitle: "") {
                    self.showVerifyEmailAlert()
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in } )
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK : Button Handlers
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShowPasswordAction(_ sender: Any) {
        if(isPasswordShown == true) {
            tfPassword.isSecureTextEntry = false
            btnShowPassword.setImage(UIImage(named: "shown"), for: .normal)
        } else {
            tfPassword.isSecureTextEntry = true
            btnShowPassword.setImage(UIImage(named: "hidden"), for: .normal)
        }

        isPasswordShown = !isPasswordShown

    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        CoreDataService.clearLogin()
        
        if tfUsername.text == "" {
//            tfUsername.text = "71009767"
            tfUsername.text = "70861600"
//            tfUsername.text = "70568203"
        }
        if tfPassword.text == "" {
//            tfPassword.text = "Password@123"
            tfPassword.text = "P@ssw0rd"
//            tfPassword.text = "123qwe!@#QWE"
        }
        if let country = selectedCountry, let phoneNumber = tfUsername.text, phoneNumber != "", let password = tfPassword.text, password != "" {
            showProgressBar()
            User.shared.login(countryCode: country.phoneCode, phoneNumber: phoneNumber, password: password, delegate: self)
        }
        else{
            showAlertWithCompletion(message: Constants.Errors.ERROR_FILL_ALL_FIELDS, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
    }
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        performSegueIfPossible(identifier: "loginToRegister")
    }
    
    @IBAction func btnVerifyByEmailAction(_ sender: Any) {
        showVerifyEmailAlert()
    }
    
    @IBAction func btnVerifyByPhoneAction(_ sender: Any) {
        showVerifyPhoneAlert()
    }
    
    @IBAction func btnSelectCountryAction(_ sender: Any) {
        selectCountryCode()
    }
    
    @IBAction func btnForgotPasswordAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Tote Wallet", message: "Kindly enter your email address", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter email here"
        }
        
        let okAction = UIAlertAction(title: "Reset", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let emailTf = alertController.textFields![0] as UITextField
            if let tfContent = emailTf.text, tfContent != "" {
                self.showProgressBar()
                User.shared.requestResetPassword(delegate: self, email: tfContent)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in } )
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnPrivacyPolicy(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationPrivacyPolicyVC") as! RegistrationPrivacyPolicyVC
        vc.urlToLoad = "https://totewallet.com/privacy-policy"
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnTermsAndConditions(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationPrivacyPolicyVC") as! RegistrationPrivacyPolicyVC
        vc.urlToLoad = "https://totewallet.com/terms-and-conditions"
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: CountryDropDown Methods
extension LoginVC: CustomCountryDropDownDelegate {
    
    // MARK: CustomDropDown Methods
    @objc func openDropDown(title: String, data:[Country], tag:Int){
        resignFirstResponder()
        CustomCountryDropDown.open(title:"Select Country",
                        data: data,
                        selectedItems: nil,
                        delegate: self,
                        multipleSelection: false,
                        tag:tag)
    }
    
    func dropDownCountryDidSelect(contentReturned: [Country], tag: Int) {
        if let country = contentReturned.first {
            selectedCountry = country
            btnSelectCountry.setTitle(country.codeWithName, for: .normal)
        }
    }
    
    @objc func selectCountryCode(){
        openDropDown(title: "Select Country", data: DataHelper.countries, tag: -1)
    }
}

//An extension for Requests
extension LoginVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        if(status == .loginSuccess){
            User.shared.getProfileDetails(delegate: self)
        }
        else if status == .HTTPSuccess {
            User.shared.getWallets(delegate: self)
        }
        
        else if(status == .walletsFetchSucceeded) {
            hideProgressBar()
            performSegueIfPossible(identifier: "loginToHome")
            return
        }
        
        else if status == .didRequestPassReset {
            hideProgressBar()
            showAlertWithCompletion(message: "An email has been send to you", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            return
        }
        
        else if status == .loginFailed {
            hideProgressBar()
            if message != "" {
                showAlertWithCompletion(message: message, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
            else{
                showAlertWithCompletion(message: Constants.Errors.GENERAL_ERROR, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
        }
    }
    
    func hasFinishedLoadingDataWithError(error: Error?) {
        hideProgressBar()
        showAlertWithCompletion(message: error?.localizedDescription ?? Constants.Errors.GENERAL_ERROR, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
    }
    
}
