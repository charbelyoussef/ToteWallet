//
//  ViewController.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import ContactsUI

class SendTipsVC: UIViewController,UINavigationControllerDelegate {
    //        btnNotifications.setup(selectedBGColor: configColor, deselectedBGColor: UIColor.white, checkColor: UIColor.white, borderColor: configColor, selected: false)

    // MARK: Class Outlets
    @IBOutlet weak var lblBalanceTitle: UILabel!
    @IBOutlet weak var lblBalanceValue: UILabel!

    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tvContent: UITableView!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var btnSelectWallet: CustomSelectionButton!
    @IBOutlet weak var btnSendTips: RoundedButton!
    @IBOutlet weak var vSeparator: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblRequestResponse: UILabel!

    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfAmountOfTips: CustomTextField!
    @IBOutlet weak var tfDescription: CustomTextField!
    @IBOutlet weak var tfPin: CustomTextField!
    
    // MARK: Class Variables
    
    var contentArray = NSMutableArray()
    
    var picker = UIPickerView()
    var toolBar  = UIToolbar()
    
    var countryId = -1
    
    var countries = DataHelper.countries
    var wallets = CoreDataService.getWallets()
    
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
//            let keyboardY = self.view.frame.size.height - keyboardHeight
            let keyboardY = UIScreen.main.bounds.size.height - keyboardHeight
            
            let btnMaxY = self.btnSendTips.convert(btnSendTips.bounds, to: self.view).maxY
            if keyboardY < btnMaxY {
                self.view.frame.origin.y = keyboardY - btnMaxY - 10
            }
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    // MARK: Custom Methods
    func initViews() {
        lblBalanceTitle.text = "TOTAL BALANCE:"
        lblBalanceValue.text = "\(CoreDataService.getWallets().first?.roundedBalance ?? 0)"

        ConfigurationManager.setSecondaryLighterThemeBGColorForViews(views: [btnSendTips])
                
        vSeparator.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().textFieldsBorderColor ?? "")
        
        if let defaultCountry = CoreDataService.getAppConfiguration().first {
            countryId = Int("\(defaultCountry.countryId ?? "-1")") ?? -1
            btnCountryCode.setTitle(defaultCountry.codeWithName, for: .normal)
        }
        else {
            countryId = Int(countries[0].id)
            btnCountryCode.setTitle(countries.first?.codeWithName, for: .normal)
        }

//        countryId = Int(countries[0].id)
//        btnCountryCode.setTitle(countries.first?.codeWithName, for: .normal)

        btnSelectWallet.setTitle(wallets.first?.alias, for: .normal)
        
        tfPhoneNumber.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
        tfPhoneNumber.delegate = self
        
        tfAmountOfTips.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
        tfAmountOfTips.delegate = self
        
        tfDescription.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .done, isPassword: false)
        tfDescription.delegate = self
        
        tfPin.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: true)
        tfPin.delegate = self
    }
    
    func resetFields(){
        tfPhoneNumber.text = ""
        tfAmountOfTips.text = ""
        tfDescription.text = ""
        tfPin.text = ""
        
//        countryId = -1
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
    
    // MARK: Button Handlers
    @IBAction func btnSendTipsAction(_ sender: Any) {

        if let phoneNumber = tfPhoneNumber.text, phoneNumber != "",
            let amountOfTips = tfAmountOfTips.text, amountOfTips != "",
            let description = tfDescription.text, description != "",
            let pin = tfPin.text, pin != "",
            countryId > -1,
            let walletId = wallets.first?.walletId, walletId != ""
        {
            showProgressBar()
            WalletStore.shared.sendTips(delegate: self,
                                        senderWalletId: walletId,
                                        countryCodeId: "\(countryId)",
                                        phoneNumber: phoneNumber,
                                        amount: amountOfTips,
                                        description: description,
                                        pinCode: pin)
        }
        else{
            showAlertWithCompletion(title: "", message: Constants.Errors.ERROR_FILL_ALL_FIELDS, okTitle: "Ok", cancelTitle: nil, completionBlock: nil)
        }
    }
    
    @IBAction func btnSelectWalletAction(_ sender: Any) {
//        initPicker(tag: Enums.Pickers.Wallet.rawValue)
    }
    
    @IBAction func btnCountryCodeAction(_ sender: Any) {
//        initPicker(tag: Enums.Pickers.Country.rawValue)
        selectCountryCode()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        revealMenu()
    }

    @IBAction func btnCloseAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: Contact Selection Methods
extension SendTipsVC: CNContactPickerDelegate {
    
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
                countryId = Int(country.id)
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
extension SendTipsVC: CustomCountryDropDownDelegate {
    
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
            btnCountryCode.setTitle("\(country.codeWithName ?? "N/A")", for: .normal)
            countryId = Int(country.id)
        }
    }
    
    @objc func selectCountryCode(){
        openDropDown(title: "Select Country", data: DataHelper.countries, tag: -1)
    }
}

// MARK: UIPicker Methods
extension SendTipsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch picker.tag {
        case Enums.Pickers.Wallet.rawValue:
            return wallets.count

        case Enums.Pickers.Country.rawValue:
            return countries.count

        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch picker.tag {
        case Enums.Pickers.Wallet.rawValue:
            return wallets[row].alias

        case Enums.Pickers.Country.rawValue:
            return countries[row].codeWithName

        default:
            return ""
        }
    }
    
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch picker.tag {
        case Enums.Pickers.Wallet.rawValue:
            btnSelectWallet.setTitle("\(wallets[row].alias ?? "N/A")", for: .normal)

        case Enums.Pickers.Country.rawValue:
            btnCountryCode.setTitle("\(countries[row].codeWithName ?? "N/A")", for: .normal)
            countryId = Int(countries[row].id)
            
        default:
            break
        }
        
    }
    
    // MARK: Custom Methods
    func initPicker(tag: Int){

        if(!picker.isKind(of: CustomPickerView.self)){
            picker = CustomPickerView()
            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - Constants.UIElements.pickerHeight, width: UIScreen.main.bounds.size.width, height: Constants.UIElements.pickerToolbarHeight))
            toolBar.barStyle = .default
            let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

            toolBar.items = [flexButton, UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
            picker.tag = tag
            picker.delegate = self
            picker.dataSource = self
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
extension SendTipsVC : UITextFieldDelegate {
    
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
extension SendTipsVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        hideProgressBar()

        if status == .HTTPSuccess {
            var messageTemp = message
            
            if messageTemp == "" {
                messageTemp = "Success"
            }
            
            resetFields()
            
            showAlertWithCompletion(message: messageTemp, okTitle: "Ok", cancelTitle: "") {
                WalletHelper.reloadWallets(vc: self)
            }

        }
        else if status == .didNotLoadRemoteData {
            showAlertWithCompletion(message: message, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
    }
    
    func hasFinishedLoadingDataWithError(error: Error?) {
    }
}
