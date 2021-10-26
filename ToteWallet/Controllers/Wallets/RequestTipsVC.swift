//
//  ViewController.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import ContactsUI

class RequestTipsVC: UIViewController, CustomCheckBoxDelegate {
    
    // MARK: Class Outlets
    @IBOutlet weak var lblBalanceTitle: UILabel!
    @IBOutlet weak var lblBalanceValue: UILabel!
    
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tvContent: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnRequestTips: UIButton!
    @IBOutlet weak var btnGetPushNotification: CustomCheckBox!
    @IBOutlet weak var vSeparator: UIView!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var lblRequestResponse: UILabel!
    
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfAmountOfTips: CustomTextField!
    @IBOutlet weak var tfDescription: CustomTextField!
    @IBOutlet weak var tfPin: CustomTextField!
    
    // MARK: Class Variables
    struct RequestTipObject {
        var senderCountryId:String?
        var senderNumber:String?
        var amountOfTips:Double?
        var description:String?
        var pin:Int?
        //        var getPushNotification:Bool
    }
    
    var requestTipObject = RequestTipObject()
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var countries =  DataHelper.countries
    var countryId = -1
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        
        registerForKeyboardNotifications()

        setupDismissOnTap()
        addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: Keyboard Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.size.height
            let keyboardY = UIScreen.main.bounds.size.height - keyboardHeight
            
            let btnMaxY = self.btnRequestTips.convert(btnRequestTips.bounds, to: self.view).maxY
            if keyboardY < btnMaxY {
                self.view.frame.origin.y = keyboardY - btnMaxY - 10
            }
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }

    // MARK: Custom Mehods
    func initViews() {
        lblBalanceTitle.text = "TOTAL BALANCE:"
        lblBalanceValue.text = "\(CoreDataService.getWallets().first?.roundedBalance ?? 0)"
        
        ConfigurationManager.setSecondaryLighterThemeBGColorForViews(views: [btnRequestTips])
        vSeparator.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().textFieldsBorderColor ?? "")
        
        if let defaultCountry = CoreDataService.getAppConfiguration().first {
            requestTipObject.senderCountryId = defaultCountry.countryId
            btnCountryCode.setTitle(defaultCountry.codeWithName, for: .normal)
        }
        else{
            requestTipObject.senderCountryId = "\(countries.first?.id ?? -1)"
            btnCountryCode.setTitle(countries.first?.codeWithName, for: .normal)
        }
        
        //        requestTipObject?.senderCountryId = "\(countries.first?.id ?? -1)"
        //        btnCountryCode.setTitle(countries.first?.codeWithName, for: .normal)
        
        tfPhoneNumber.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
        tfPhoneNumber.delegate = self
        
        tfAmountOfTips.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
        tfAmountOfTips.delegate = self
        
        tfDescription.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
        tfDescription.delegate = self
        
        tfPin.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: true)
        tfPin.delegate = self
        
        let configColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimary ?? "")
        btnGetPushNotification.setup(selectedBGColor: configColor, deselectedBGColor: UIColor.white, checkColor: UIColor.white, borderColor: configColor, selected: false)
        btnGetPushNotification.delegate = self
        //        btnGetPushNotification.tag = 0
        
        tfAmountOfTips.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
        tfDescription.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
        tfPin.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: true)
    }
    
    func resetFields(){
        tfPhoneNumber.text = ""
        tfAmountOfTips.text = ""
        tfDescription.text = ""
        tfPin.text = ""
        
//        requestTipObject.senderCountryId = ""
    }
    
    func openProfile(){
        self.performSegueIfPossible(identifier: "requestTipsToProfile")
    }
    
    // MARK: Button Handlers
    @IBAction func btnBuyTipsAction(_ sender: Any) {
        
    }
    
    // MARK: CustomCheckBox Methods
    func checkBoxChanged(checkBox: CustomCheckBox, checked: Bool) {
        switch checkBox.tag {
        case 0:
            //            registerObject.notificationsCheck = checked
            break
            
        default:
            break
        }
    }
    
    // MARK: Button Handlers
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCountryCodeAction(_ sender: Any) {
        selectCountryCode()
    }

    @IBAction func btnRequestTipsAction(_ sender: Any) {
        if let phoneNumber = tfPhoneNumber.text, phoneNumber != "",
           let amountOfTips = tfAmountOfTips.text, amountOfTips != "",
           let description = tfDescription.text, description != "",
           let countryIdTemp = requestTipObject.senderCountryId
        {
            showProgressBar()
            WalletStore.shared.requestTips(delegate: self,
                                           countryCodeId: countryIdTemp,
                                           phoneNumber: phoneNumber,
                                           amount: amountOfTips,
                                           description: description)
        }
        else{
            showAlertWithCompletion(message: Constants.Errors.ERROR_FILL_ALL_FIELDS, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
    }
}

// MARK: Contact Selection Methods
extension RequestTipsVC: CNContactPickerDelegate {
    
    func setNumberFromContact(countryCode: String?, phoneNumber: String) {

        var phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
                
        guard phoneNumber.count >= 7 else {
            dismiss(animated: true) {
                self.showAlertWithCompletion(message: "Selected contact does not have a valid number", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
            return
        }
        
        tfPhoneNumber.text = phoneNumber // String(phoneNumber.suffix(10))
        
        if countryCode != nil, countryCode != "" {
            var countryCodeTemp = countryCode?.replacingOccurrences(of: "\\p{Cf}", with: "", options: .regularExpression)
            if countryCodeTemp != nil, countryCodeTemp!.contains("+"){
                countryCodeTemp = countryCodeTemp?.replacingOccurrences(of: "+", with: "")
            }
            if let country = DataHelper.getcountry(for: countryCodeTemp!) {
                requestTipObject.senderCountryId = "\(country.id)"
                btnCountryCode.setTitle(country.codeWithName, for: .normal)
            }
        }
    }
    
    //MARK: Contact picker
    func onClickPickContact(){
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys = [CNContactGivenNameKey, CNContactPhoneNumbersKey]
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let phoneNumberCount = contact.phoneNumbers.count

        guard phoneNumberCount > 0 else {
            dismiss(animated: true)
            showAlertWithCompletion(message: "Selected contact does not have a number!", okTitle: "OK", cancelTitle: nil) {
                self.contactPickerDidCancel(picker)
            }
            return
        }
        
//        let digits = contact.phoneNumbers.first?.value.value(forKey: "digits") as! String //+971505400314 --- 03368245
//        let formattedInternationalStringValue = contact.phoneNumbers.first?.value.value(forKey: "formattedInternationalStringValue") //+971 50 540 0314 --- +961 3 368 245
//        let formattedStringValue = contact.phoneNumbers.first?.value.value(forKey: "formattedStringValue") as! String //+971 50 540 0314 --- 03 368 245
        
        if let formattedStringTemp = contact.phoneNumbers.first?.value.value(forKey: "formattedInternationalStringValue") as? String, formattedStringTemp != ""  {
            var formattedString = formattedStringTemp
            if formattedString.contains("+") {
                //Should Contain Country Code
                if let countryCode = formattedString.split(separator: " ").first, countryCode != "" {
                    formattedString = formattedString.replacingOccurrences(of: countryCode, with: "")
                    setNumberFromContact(countryCode: String(countryCode), phoneNumber: formattedString)
                }
            }
            
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
    
    @IBAction func btnSelectFromContactsAction(_ sender: Any) {
        onClickPickContact()
    }

}

// MARK: CountryDropDown Methods
extension RequestTipsVC: CustomCountryDropDownDelegate {
    
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
            requestTipObject.senderCountryId = "\(country.id)"
            countryId = Int(country.id)
            btnCountryCode.setTitle(country.codeWithName, for: .normal)
        }
    }
    
    @objc func selectCountryCode(){
        openDropDown(title: "Select Country", data: DataHelper.countries, tag: -1)
    }
}

// MARK: UIPicker Methods
extension RequestTipsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK : UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row].codeWithName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        btnCountryCode.setTitle("\(countries[row].codeWithName ?? "N/A")", for: .normal)
        requestTipObject.senderCountryId = "\(countries[row].id)"
        countryId = Int(countries[row].id)
    }
    
    // MARK : Custom Methods
    
    func initPicker(){
        if(!picker.isKind(of: CustomPickerView.self)){
            picker = CustomPickerView()
            picker.delegate = self
            picker.dataSource = self
            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - Constants.UIElements.pickerHeight, width: UIScreen.main.bounds.size.width, height: Constants.UIElements.pickerToolbarHeight))
            toolBar.barStyle = .default
            let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            
            toolBar.items = [flexButton, UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        }
        
        showPicker()
    }
    
    func showPicker(){
        self.tabBarController?.tabBar.isHidden = true
        self.view.addSubview(picker)
        self.view.addSubview(toolBar)
    }
    
    func hidePicker(){
        self.tabBarController?.tabBar.isHidden = false
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    @objc func onDoneButtonTapped() {
        hidePicker()
    }
}

//An Extension for all the UITextfield stuff
extension RequestTipsVC : UITextFieldDelegate {
    
    // MARK: TextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        hidePicker()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

//An extension for Requests
extension RequestTipsVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        hideProgressBar()
        
        if status == .HTTPSuccess {
            var messageTemp = message
            
            if messageTemp == "" {
                messageTemp = "Success"
            }
            lblRequestResponse.text = messageTemp
            
            resetFields()
            
            showAlertWithCompletion(message: messageTemp, okTitle: "Ok", cancelTitle: "") {
                WalletHelper.reloadWallets(vc: self)
            }
        }
        else if status == .didNotLoadRemoteData {
            showAlertWithCompletion(message: message, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
        else if status == .idFetchFailure {
            var messageTemp = message

            if messageTemp == ""{
                messageTemp = "Id not available!"
            }
            showAlertWithCompletion(message: messageTemp, okTitle: "Go to Profile", cancelTitle: "Cancel") {
                self.openProfile()
            }
        }
        
    }
    
    func hasFinishedLoadingDataWithError(error: Error?) {
        hideProgressBar()
    }
}
