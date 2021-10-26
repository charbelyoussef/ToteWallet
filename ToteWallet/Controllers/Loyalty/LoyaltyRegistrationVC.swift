//
//  ViewController.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import ContactsUI

class LoyaltyRegistrationVC: UIViewController {
    //        btnNotifications.setup(selectedBGColor: configColor, deselectedBGColor: UIColor.white, checkColor: UIColor.white, borderColor: configColor, selected: false)

    // MARK: Class Outlets
    @IBOutlet weak var svScrollContainer: UIScrollView!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tvContent: UITableView!
    @IBOutlet weak var tfProgramName: CustomTextField!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var btnSelectWallet: CustomSelectionButton!
    @IBOutlet weak var vSeparator: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnPurchase: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var vButtonsContainer: UIView!
    @IBOutlet weak var tfTotalCost: CustomTextField!
    @IBOutlet weak var tfQuantity: CustomTextField!
    @IBOutlet weak var tfPin: CustomTextField!

    // MARK: Class Variables
    var programId = ""
    
    var picker = UIPickerView()
    var toolBar  = UIToolbar()
    
    var countries = DataHelper.countries
    var selectedCountryCode:String?

    var wallets = CoreDataService.getWallets()
    var membershipObject:LoyaltyProgram?
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        
        if Enums.DeviceType.IS_IPHONE_5 || Enums.DeviceType.IS_IPHONE_6 || Enums.DeviceType.IS_IPHONE_7 || Enums.DeviceType.IS_IPHONE_8 || Enums.DeviceType.IS_IPHONE_X || Enums.DeviceType.IS_IPHONE_XsMax || Enums.DeviceType.IS_IPHONE_11ProMax {
            registerForKeyboardNotifications()
        }

        setupDismissOnTap()
        addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: Custom Methods
    func initViews() {
        if let defaultCountry = CoreDataService.getAppConfiguration().first {
            selectedCountryCode = defaultCountry.phoneCountryCode
            btnCountryCode.setTitle(defaultCountry.codeWithName, for: .normal)
        }
        else{
            selectedCountryCode = "\(countries.first?.phoneCode ?? -1)"
            btnCountryCode.setTitle(countries.first?.codeWithName, for: .normal)
        }
        
//        selectedCountryCode = "\(countries.first?.phoneCode ?? -1)"
//        btnCountryCode.setTitle(countries.first?.codeWithName, for: .normal)

        btnSelectWallet.setTitle(wallets.first?.alias, for: .normal)
        
        vButtonsContainer.layer.cornerRadius = vButtonsContainer.frame.size.height/2
        vButtonsContainer.clipsToBounds = true
        
        tfProgramName.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
        tfProgramName.text = membershipObject?.name
        
        tfQuantity.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
        tfPin.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: true)
        tfPhoneNumber.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
        
        tfTotalCost.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
        tfTotalCost.text = membershipObject?.settingsPrice
        ConfigurationManager.setSecondaryThemeBGColorForViews(views: [btnPurchase])
        
        vSeparator.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().textFieldsBorderColor ?? "")
    }
    
    func openProfile(){
        self.performSegueIfPossible(identifier: "LoyaltyRegistrationTipsToProfile")
    }
    
    // MARK: Keyboard Methods
    override func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardHeight = keyboardFrame.cgRectValue.height
            if Enums.DeviceType.IS_IPHONE_5 {
                self.view.frame.origin.y = 0 - Constants.UIElements.iphone5Offset - 80
            }
            else if Enums.DeviceType.IS_IPHONE_6 {
                self.view.frame.origin.y = 0 - Constants.UIElements.iphone6Offset - 80
            }
            else if Enums.DeviceType.IS_IPHONE_7 {
                self.view.frame.origin.y = 0 - Constants.UIElements.iphone7Offset - 80
            }
            else if Enums.DeviceType.IS_IPHONE_8 {
                self.view.frame.origin.y = 0 - Constants.UIElements.iphone8Offset - 80
            }
            else if Enums.DeviceType.IS_IPHONE_X {
                self.view.frame.origin.y = 0 - Constants.UIElements.iphoneXOffset - 80
            }
            else if Enums.DeviceType.IS_IPHONE_XsMax {
                self.view.frame.origin.y = 0 - Constants.UIElements.iphoneXsMaxOffset - 80
            }
            else if Enums.DeviceType.IS_IPHONE_11ProMax {
                self.view.frame.origin.y = 0 - Constants.UIElements.iphone11ProMaxOffset - 80
            }

        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
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
    @IBAction func btnSelectWallet(_ sender: Any) {
//        initPicker(tag: Enums.Pickers.Wallet.rawValue)
    }
    
    @IBAction func btnCountryCodeAction(_ sender: Any) {
//        initPicker(tag: Enums.Pickers.Country.rawValue)
        selectCountryCode()
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        revealMenu()
    }

    @IBAction func btnPurchaseAction(_ sender: Any) {
        
        
        if let phoneNumber = tfPhoneNumber.text, phoneNumber != "",
           let pinCode = tfPin.text, pinCode != "",
           let quantity = tfQuantity.text, quantity != "" {
            let selectedCountry = DataHelper.getcountry(for: selectedCountryCode ?? "N/A")
            showProgressBar()
            WalletStore.shared.purchaseLoyaltyProgram(delegate: self,
                                               countryId: "\(selectedCountry?.id ?? -1)",
                                               phoneNumber: phoneNumber,
                                               pinCode: pinCode,
                                               loyaltyProgramId: membershipObject?.id ?? "N/A",
                                               sender: wallets.first?.walletId ?? "N/A",
                                               quantity: quantity)
        }
        else{
            showAlertWithCompletion(message: Constants.Errors.ERROR_FILL_ALL_FIELDS, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: Contact Selection Methods
extension LoyaltyRegistrationVC: CNContactPickerDelegate {
    
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
                selectedCountryCode = "\(country.phoneCode)"
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
extension LoyaltyRegistrationVC: CustomCountryDropDownDelegate {
    
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
            selectedCountryCode = "\(country.phoneCode)"
            btnCountryCode.setTitle(country.codeWithName, for: .normal)
        }
    }
    
    @objc func selectCountryCode(){
        openDropDown(title: "Select Country", data: DataHelper.countries, tag: -1)
    }
}

//An Extension for all the UIPicker stuff
extension LoyaltyRegistrationVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
            break

        case Enums.Pickers.Country.rawValue:
            selectedCountryCode = "\(countries[row].phoneCode)"
            btnCountryCode.setTitle("\(countries[row].codeWithName ?? "N/A")", for: .normal)
            break
            
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

//An extension for Requests
extension LoyaltyRegistrationVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        hideProgressBar()

        if status == .HTTPSuccess {
            if message != "" {
                showAlertWithCompletion(message: message.htmlToString, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
            else{
                showAlertWithCompletion(message: "Success", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
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
