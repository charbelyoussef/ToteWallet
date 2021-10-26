//
//  RegisterVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class RegisterVC : UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate, CustomCheckBoxDelegate, CustomDropDownDelegate {
    
    // MARK: Class Outlets
//    @IBOutlet weak var countryPickerView: CountryPickerView!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tvContent: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    // MARK: Class Variables
    fileprivate enum TVSections:Int {
//        case ProfilePicture
//        case Title
        case Firstname
        case Lastname
        case Email
        case PhoneNumber
        case Password
        case ConfirmPassword
        case PinCode
        case ConfirmPinCode
        case PrivacyPolicy
        case RegisterButton
        case RowCount
    }
    
    fileprivate enum CheckBoxTags:Int {
        case PrivacyPolicy
    }

    fileprivate enum TVPickers:Int {
        case PhoneCountryCode
    }
    
    var registerObject = Structs.RegisterObject()
    
    var rowHeight:CGFloat = 65
    var contentArray = NSMutableArray()
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var countries = DataHelper.countries
    
    var urlToOpen = ""
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        tvContent.customRegisterForCell(identifiers: ["RegisterVCDefaultCell", "RegisterVCPhoneCell", "RegisterVCRegisterButtonCell", "RegisterVCNotificationsCell"])
        registerForKeyboardNotifications()
        setupDismissOnTap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: TableView Methods
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        label.text = "Account Information"
        label.textAlignment = .center
        label.backgroundColor = .white
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case TVSections.PrivacyPolicy.rawValue:
            return 45
            
        default:
            return rowHeight
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TVSections.RowCount.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            
        case TVSections.Firstname.rawValue:
            let cell:RegisterVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "RegisterVCDefaultCell", for: indexPath) as! RegisterVCDefaultCell
            
            cell.lblTitle.text = "First Name"
            cell.tfValue.tag = TVSections.Firstname.rawValue
            cell.tfValue.delegate = self
            cell.tfValue.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
            
            return cell
            
        case TVSections.Lastname.rawValue:
            let cell:RegisterVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "RegisterVCDefaultCell", for: indexPath) as! RegisterVCDefaultCell
            
            cell.lblTitle.text = "Last Name"
            cell.tfValue.tag = TVSections.Lastname.rawValue
            cell.tfValue.delegate = self
            cell.tfValue.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
            
            return cell
            
        case TVSections.Email.rawValue:
            let cell:RegisterVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "RegisterVCDefaultCell", for: indexPath) as! RegisterVCDefaultCell
            
            cell.lblTitle.text = "Email"
            cell.tfValue.tag = TVSections.Email.rawValue
            cell.tfValue.delegate = self
            cell.tfValue.customize(keyboardType: .emailAddress, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: false)
            
            return cell
            
        case TVSections.PhoneNumber.rawValue:
            let cell:RegisterVCPhoneCell = tableView.dequeueReusableCell(withIdentifier: "RegisterVCPhoneCell", for: indexPath) as! RegisterVCPhoneCell
            
            cell.lblTitle.text = "Phone"
            cell.tfValue.tag = TVSections.PhoneNumber.rawValue
            cell.btnCountryCode.addTarget(self, action: #selector(selectCountryCode), for: .touchDown)
//            cell.btnCountryCode.setTitle("TEST", for: .normal)
            cell.tfValue.delegate = self
            cell.tfValue.customize(keyboardType: .phonePad, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: false)
            
            return cell
            
        case TVSections.Password.rawValue:
            let cell:RegisterVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "RegisterVCDefaultCell", for: indexPath) as! RegisterVCDefaultCell
            
            cell.lblTitle.text = "Password"
            cell.tfValue.tag = TVSections.Password.rawValue
            cell.tfValue.delegate = self
            cell.tfValue.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: true)

            return cell
            
        case TVSections.ConfirmPassword.rawValue:
            let cell:RegisterVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "RegisterVCDefaultCell", for: indexPath) as! RegisterVCDefaultCell
            
            cell.lblTitle.text = "Confirm Password"
            cell.tfValue.tag = TVSections.ConfirmPassword.rawValue
            cell.tfValue.delegate = self
            cell.tfValue.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: true)
            
            return cell
            
            
        case TVSections.PinCode.rawValue:
            let cell:RegisterVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "RegisterVCDefaultCell", for: indexPath) as! RegisterVCDefaultCell
            
            cell.lblTitle.text = "Pin Code"
            cell.tfValue.tag = TVSections.PinCode.rawValue
            cell.tfValue.delegate = self
            cell.tfValue.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: true)
            
            return cell
            
        case TVSections.ConfirmPinCode.rawValue:
            let cell:RegisterVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "RegisterVCDefaultCell", for: indexPath) as! RegisterVCDefaultCell
            
            cell.lblTitle.text = "Confirm Pin Code"
            cell.tfValue.tag = TVSections.ConfirmPinCode.rawValue
            cell.tfValue.delegate = self
            cell.tfValue.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: true)

            return cell
            
        case TVSections.PrivacyPolicy.rawValue:
            let cell:RegisterVCNotificationsCell = tableView.dequeueReusableCell(withIdentifier: "RegisterVCNotificationsCell", for: indexPath) as! RegisterVCNotificationsCell
            
            cell.btnPrivacyPolicy.delegate = self
            cell.btnPrivacyPolicy.tag = CheckBoxTags.PrivacyPolicy.rawValue
            
            cell.btnShowTermsAndConditions.addTarget(self, action: #selector(openTermsAndConditions), for: .touchUpInside)
            cell.btnShowPrivacyDialog.addTarget(self, action: #selector(openPrivacyPolicy), for: .touchUpInside)

            return cell
            
        case TVSections.RegisterButton.rawValue:
            let cell:RegisterVCRegisterButtonCell = tableView.dequeueReusableCell(withIdentifier: "RegisterVCRegisterButtonCell", for: indexPath) as! RegisterVCRegisterButtonCell
            cell.btnRegister.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
            //            cell.btnChangePassword.addTarget(self, action: #selector(changePasswordAction), for: .touchUpInside)
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: NDCheckBox Delegate
    
    func checkBoxChanged(checkBox: CustomCheckBox, checked: Bool) {
        switch checkBox.tag {
        case CheckBoxTags.PrivacyPolicy.rawValue:
            registerObject.privacyPolicyCheck = checked
            break
            
        default:
            break
        }
    }

    
    // MARK: TextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
//            case TVSections.Firstname.rawValue:
//                return false
        default:
            return true
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case TVSections.Firstname.rawValue:
            registerObject.firstname = textField.text ?? ""
            return true
            
        case TVSections.Lastname.rawValue:
            registerObject.lastname = textField.text ?? ""
            return true
            
        case TVSections.Email.rawValue:
            registerObject.email = textField.text ?? ""
            return true
            
        case TVSections.PhoneNumber.rawValue:
            registerObject.phoneNumber = textField.text ?? ""
            return true
            
        case TVSections.Password.rawValue:
            registerObject.password = textField.text ?? ""
            return true
            
        case TVSections.ConfirmPassword.rawValue:
            registerObject.confirmPassword = textField.text ?? ""
            return true
            
        case TVSections.PinCode.rawValue:
            registerObject.pinCode = textField.text ?? ""
            return true
            
        case TVSections.ConfirmPinCode.rawValue:
            registerObject.confirmPinCode = textField.text ?? ""
            return true
        
        default:
            return true
        }
    }

    // MARK: Custom Mehods
    
    func initViews(){
        let s = CoreDataService.getAppConfiguration().first
        
        if registerObject.countryCode == nil || registerObject.countryCode == "" {
            if let appConfig = CoreDataService.getAppConfiguration().first, let countryId = appConfig.countryId {
                registerObject.countryCode = "\(countryId)"
                
                if let country = DataHelper.getcountryForId(countryId: appConfig.countryId ?? "N/A"), let countryCodeWithName = country.codeWithName {
                    if let cell = tvContent.cellForRow(at: IndexPath(row: TVSections.PhoneNumber.rawValue, section: 0)) as? RegisterVCPhoneCell {
                        cell.btnCountryCode.setTitle(countryCodeWithName, for: .normal)
                        tvContent.reloadData()
                    }
                }
            }
        }
    }
    
    func checkPasswordConformity(password:String, confirmPassword:String) -> Bool{
        let isConform = (password == confirmPassword)
        isConform ? () : showAlertWithCompletion(message: Constants.Errors.PASSWORD_MISMATCH_ERROR, okTitle: "Okay", cancelTitle: nil, completionBlock: nil)
        return isConform
    }
    
    func checkPinConformity(pin:String, confirmPin:String) -> Bool{
        let isConform = (pin == confirmPin)
        isConform ? () : showAlertWithCompletion(message: Constants.Errors.PIN_MISMATCH_ERROR, okTitle: "Okay", cancelTitle: nil, completionBlock: nil)
        return isConform
    }
    
    func checkPinLength(pin:String, confirmPin:String) -> Bool {
        if pin.count >= 6, confirmPin.count >= 6 {
            return true
        }
        else {
            return false
        }
    }
    
    @objc func openPrivacyPolicy(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationPrivacyPolicyVC") as! RegistrationPrivacyPolicyVC
        vc.urlToLoad = "https://totewallet.com/privacy-policy"
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func openTermsAndConditions(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationPrivacyPolicyVC") as! RegistrationPrivacyPolicyVC
        vc.urlToLoad = "https://totewallet.com/terms-and-conditions"
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func registerAction(){
        
        if !registerObject.privacyPolicyCheck {
            showAlertWithCompletion(message: "Make sure to check the terms box", okTitle: "Ok", cancelTitle: nil, completionBlock: nil)
            return
        }
        
        if checkIfAllFieldsAreFilled() {
            
            if !Utils.isEmailValid(registerObject.email) {
                showAlertWithCompletion(message: "Invalid Email!", okTitle: "Ok", cancelTitle: nil, completionBlock: nil)
                return
            }
            
            if let password = registerObject.password, password != "", let confirmPassword = registerObject.confirmPassword, confirmPassword != "" {
                
                if !Utils.checkPasswordFormat(password: password) {
                    showAlertWithCompletion(message: Constants.Errors.PASSWORD_FORMAT_ERROR, okTitle: "Ok", cancelTitle: nil, completionBlock: nil)
                    return
                }
                
                if !checkPasswordConformity(password: password, confirmPassword: confirmPassword) {
                    showAlertWithCompletion(message: Constants.Errors.PASSWORD_MISMATCH_ERROR, okTitle: "Ok", cancelTitle: nil, completionBlock: nil)
                    return
                }
            }
            
            if let pin = registerObject.pinCode, pin != "" , let confirmPin = registerObject.confirmPinCode, confirmPin != "" {
                if !checkPinConformity(pin: pin, confirmPin: confirmPin) {
                    showAlertWithCompletion(message: Constants.Errors.PIN_MISMATCH_ERROR, okTitle: "Ok", cancelTitle: nil, completionBlock: nil)
                    return
                }
                
                if !checkPinLength(pin: pin, confirmPin: confirmPin) {
                    showAlertWithCompletion(message: Constants.Errors.PIN_LENGTH_ERROR, okTitle: "Ok", cancelTitle: nil, completionBlock: nil)
                    return
                }
            }

            showProgressBar()
            User.shared.register(delegate:self,
                                 fName: registerObject.firstname ?? "Firstname",
                                 lName: registerObject.lastname ?? "Lastname",
                                 email: registerObject.email ?? "Email",
                                 phoneCountry: registerObject.countryCode ?? "422",
                                 phone: registerObject.phoneNumber ?? "71009767",
                                 password: registerObject.password ?? "N/A",
                                 confirmPassword: registerObject.confirmPassword ?? "N/A",
                                 pinCode: "\(registerObject.pinCode ?? "N/A")",
                                 confirmPinCode: "\(registerObject.confirmPinCode ?? "N/A")")

        }
        else{
            showAlertWithCompletion(message: Constants.Errors.ERROR_FILL_ALL_FIELDS, okTitle: "Ok", cancelTitle: nil, completionBlock: nil)
        }
    }
    
    // MARK: Keyboard Methods
    override func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            tvContent.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 20, right: 0)
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        tvContent.contentInset = .zero
    }
    
    // MARK: Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerToRegistrationSuccessful" {
//            let vc = segue.destination as? UIViewController
//            if vc != nil{
//                if let indexPath = tvContent.indexPathForSelectedRow{
//                    // set presented view controller data
//                }
//            }
        }
    }
    
    func checkIfAllFieldsAreFilled() -> Bool{
                
        if(registerObject.firstname == nil || registerObject.firstname == ""){
            return false
        }
        if(registerObject.lastname == nil || registerObject.lastname == ""){
            return false
        }
        if(registerObject.email == nil || registerObject.email == ""){
            return false
        }
        if(registerObject.countryCode == nil || registerObject.countryCode == ""){
            return false
        }
        if(registerObject.phoneNumber == nil || registerObject.phoneNumber == "") {
            return false
        }
        if(registerObject.password == nil || registerObject.password == "") {
            return false
        }
        if(registerObject.confirmPassword == nil || registerObject.confirmPassword == "") {
            return false
        }
        if(registerObject.pinCode == nil || registerObject.pinCode == "") {
            return false
        }
        if(registerObject.confirmPinCode == nil || registerObject.confirmPinCode == "") {
            return false
        }
        return true
    }
    
    // MARK: Button Handlers
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: CountryDropDown Methods
extension RegisterVC: CustomCountryDropDownDelegate {
    
    // MARK: CustomDropDown Methods
    @objc func openDropDown(title: String, data:[Country], tag:Int){
        switch tag {
        case TVSections.PhoneNumber.rawValue:
            resignFirstResponder()
            CustomCountryDropDown.open(title:"Select Country",
                            data: data,
                            selectedItems: nil,
                            delegate: self,
                            multipleSelection: false,
                            tag:tag)
            break
                    
        default:
            break
        }
    }
    
    func dropDownCountryDidSelect(contentReturned: [Country], tag: Int) {
        switch tag {
        case TVSections.PhoneNumber.rawValue:
            if let country = contentReturned.first {
                registerObject.countryCode = "\(country.id)"
                if let cell = tvContent.cellForRow(at: IndexPath(row: TVSections.PhoneNumber.rawValue, section: 0)) as? RegisterVCPhoneCell {
                    cell.btnCountryCode.setTitle(country.codeWithName, for: .normal)
                    tvContent.reloadData()
                }
            }
            break
            
        default:
            break
        }
    }
    
    @objc func selectCountryCode(){
        openDropDown(title: "Select Country", data: DataHelper.countries, tag: TVSections.PhoneNumber.rawValue)
    }
}

// MARK: Requests Methods
extension RegisterVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        hideProgressBar()

        if(status == .didRegister){
            
            var messageTemp = message
            
            if messageTemp == "" {
                messageTemp = "You have been successfully registered. Verification tokens have been sent to your Email and Phone Number. Please follow instructions."
            }

            UserDefaults.standard.set(registerObject.countryCode, forKey: "lastCountryCode")
            
            showAlertWithCompletion(message: messageTemp, okTitle: "Go To Login Page", cancelTitle: "") {
                var vcToUse:LoginVC?
                if let vcs = self.navigationController?.viewControllers, vcs.count > 0 {
                    for vc in vcs {
                        if vc.isKind(of: LoginVC.self) {
                            vcToUse = vc as? LoginVC
                        }
                    }
                }
                
                if vcToUse != nil {
                    vcToUse?.registerObject = self.registerObject
                    self.navigationController?.popToViewController(vcToUse!, animated: true)
                }
            }
        }
        else{
            showAlertWithCompletion(message: Constants.Errors.GENERAL_ERROR, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
    }
    
    func hasFinishedLoadingDataWithError(error: Error?) {
        showAlertWithCompletion(message: "Failed to register", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
    }
    
}
