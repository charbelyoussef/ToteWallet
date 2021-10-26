//
//  RegisterVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class LimitsVC : UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Class Outlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tvContent: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    // MARK: Class Variables
    fileprivate enum TVSections:Int {
        case FirstSection
        case SecondSection
    }
    
    fileprivate enum FirstSectionRows:Int {
        case Alias
        case Currency
        case DailyLimit
        case MonthlyLimit
        case CreditLimit
    }
    
    fileprivate enum SecondSectionRows:Int {
        //RO stands for "read only"
        case DailyLimitRO
        case MonthlyLimitRO
        case YearlyLimitRO
        case CreditLimitRO
        case Buttons
        case RowCount
    }
    
    fileprivate enum TextfieldsTags:Int {
        case Alias
        case Currency
        case DailyLimit
        case MonthlyLimit
        case CreditLimit
        //RO stands for "read only"
        case DailyLimitRO
        case MonthlyLimitRO
        case YearlyLimitRO
        case CreditLimitRO
        case Buttons
        case RowCount
    }
    
    var wallet:Wallet?
    var rowHeight:CGFloat = 65
    var contentArray = NSMutableArray()
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvContent.customRegisterForCell(identifiers: ["LimitsVCSimpleTextField", "LimitsVCSelectionCell", "LimitsVCDefaultCell", "LimitsVCButtonsCell"])
        registerForKeyboardNotifications()
        setupDismissOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wallet = CoreDataService.getWallets().first
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        wallet?.managedObjectContext?.rollback()
        wallet?.managedObjectContext?.reset()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK : TableView Methods
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case TVSections.FirstSection.rawValue:
            return 0
            
        case TVSections.SecondSection.rawValue://Read Only Fields With Buttons
            return 50
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case TVSections.FirstSection.rawValue:
            return UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 0))
            
        case TVSections.SecondSection.rawValue://Read Only Fields With Buttons
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            
            let label = UILabel()
            label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
            label.text = "The user cannot change these values"
            label.textAlignment = .left
            label.backgroundColor = .clear
            label.textColor = .lightGray
            label.font = UIFont.italicSystemFont(ofSize:UIFont.labelFontSize)
            
            headerView.addSubview(label)
            
            return headerView
            
        default:
            return UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 0))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case TVSections.FirstSection.rawValue:
            return 5
            
        case TVSections.SecondSection.rawValue://Read Only Fields With Buttons
            return 5
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case TVSections.FirstSection.rawValue:
            switch indexPath.row {
            case FirstSectionRows.Alias.rawValue:
                let cell:LimitsVCSimpleTextField = tableView.dequeueReusableCell(withIdentifier: "LimitsVCSimpleTextField", for: indexPath) as! LimitsVCSimpleTextField
                
                cell.lblTitle.text = "Alias"
                cell.tfValue.tag = TextfieldsTags.Alias.rawValue
                cell.tfValue.text = wallet?.alias
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .next, isPassword: false)
                
                return cell
                
            case FirstSectionRows.Currency.rawValue:
                let cell:LimitsVCSelectionCell = tableView.dequeueReusableCell(withIdentifier: "LimitsVCSelectionCell", for: indexPath) as! LimitsVCSelectionCell
                
                cell.lblTitle.text = "Currency"
                cell.btnSelection.setTitle(wallet?.currencyIsoCode, for: .normal)
                cell.btnSelection.addTarget(self, action: #selector(selectCurrencyAction), for: .touchDown)
                
                return cell
                
            case FirstSectionRows.DailyLimit.rawValue:
                let cell:LimitsVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "LimitsVCDefaultCell", for: indexPath) as! LimitsVCDefaultCell
                
                cell.lblTitle.text = "Daily Limit"
                cell.tfValue.tag = TextfieldsTags.DailyLimit.rawValue
                cell.tfValue.text = "\(wallet?.dailyLimit ?? 0.0)"
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .numbersAndPunctuation, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .next, isPassword: false)
                
                return cell
                
            case FirstSectionRows.MonthlyLimit.rawValue:
                let cell:LimitsVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "LimitsVCDefaultCell", for: indexPath) as! LimitsVCDefaultCell
                
                cell.lblTitle.text = "Monthly Limit"
                cell.tfValue.tag = TextfieldsTags.MonthlyLimit.rawValue
                cell.tfValue.text = "\(wallet?.monthlyLimit ?? 0.0)"
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .numbersAndPunctuation, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .next, isPassword: false)
                
                return cell
                
            case FirstSectionRows.CreditLimit.rawValue:
                let cell:LimitsVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "LimitsVCDefaultCell", for: indexPath) as! LimitsVCDefaultCell
                
                cell.lblTitle.text = "Credit Limit"
                cell.tfValue.tag = TextfieldsTags.CreditLimit.rawValue
                cell.tfValue.text = "\(wallet?.creditLimit ?? 0.0)"
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .numbersAndPunctuation, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .next, isPassword: false)
                
                return cell
            default:
                return UITableViewCell()
            }
            
        case TVSections.SecondSection.rawValue://Read Only Fields With Buttons
            switch indexPath.row {
            case SecondSectionRows.DailyLimitRO.rawValue:
                let cell:LimitsVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "LimitsVCDefaultCell", for: indexPath) as! LimitsVCDefaultCell
                
                cell.lblTitle.text = "Daily Limit"
                cell.vTfContainer.isUserInteractionEnabled = false
                cell.tfValue.tag = TextfieldsTags.DailyLimitRO.rawValue
                cell.tfValue.text = "\(wallet?.dailyLimit ?? 0.0)"
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .numbersAndPunctuation, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .next, isPassword: false)
                
                return cell
                
                
            case SecondSectionRows.MonthlyLimitRO.rawValue:
                let cell:LimitsVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "LimitsVCDefaultCell", for: indexPath) as! LimitsVCDefaultCell
                
                cell.lblTitle.text = "Monthly Limit"
                cell.vTfContainer.isUserInteractionEnabled = false
                cell.tfValue.tag = TextfieldsTags.MonthlyLimitRO.rawValue
                cell.tfValue.text = "\(wallet?.adminMonthlyLimit ?? 0.0)"
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .numbersAndPunctuation, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .next, isPassword: false)
                
                return cell
                
            case SecondSectionRows.YearlyLimitRO.rawValue:
                let cell:LimitsVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "LimitsVCDefaultCell", for: indexPath) as! LimitsVCDefaultCell
                
                cell.lblTitle.text = "Yearly Limit"
                cell.tfValue.tag = TextfieldsTags.YearlyLimitRO.rawValue
                cell.vTfContainer.isUserInteractionEnabled = false
                cell.tfValue.text = "\(wallet?.adminYearlyLimit ?? 0.0)"
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .numbersAndPunctuation, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .next, isPassword: false)
                
                return cell
                
            case SecondSectionRows.CreditLimitRO.rawValue:
                let cell:LimitsVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "LimitsVCDefaultCell", for: indexPath) as! LimitsVCDefaultCell
                
                cell.lblTitle.text = "Credit Limit"
                cell.tfValue.tag = TextfieldsTags.YearlyLimitRO.rawValue
                cell.vTfContainer.isUserInteractionEnabled = false
                cell.tfValue.text = "\(wallet?.creditLimit ?? 0.0)"
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .numbersAndPunctuation, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .next, isPassword: false)
                
                return cell
                
            case SecondSectionRows.Buttons.rawValue:
                let cell:LimitsVCButtonsCell = tableView.dequeueReusableCell(withIdentifier: "LimitsVCButtonsCell", for: indexPath) as! LimitsVCButtonsCell
                
                cell.btnCancel.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
                cell.btnSave.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
                
                return cell
                
            default:
                return UITableViewCell()
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    // MARK TextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
            
        default:
            return true
            
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        let section = (textField.tag < 5) ? TVSections.FirstSection.rawValue : TVSections.SecondSection.rawValue
        
        switch section {
        case TVSections.FirstSection.rawValue:
            switch textField.tag {
            case TextfieldsTags.Alias.rawValue:
                wallet?.alias = textField.text ?? ""
                return true
                
            case TextfieldsTags.Currency.rawValue:
                wallet?.currencyIsoCode = textField.text ?? ""
                return true
                
            case TextfieldsTags.DailyLimit.rawValue:
                if let value = Double(textField.text ?? "0.0") {
                    wallet?.dailyLimit = value
                }
                return true
                
            case TextfieldsTags.MonthlyLimit.rawValue:
                if let value = Double(textField.text ?? "0.0") {
                    wallet?.monthlyLimit = value
                }
                return true
                
            case TextfieldsTags.CreditLimit.rawValue:
                if let value = Double(textField.text ?? "0.0") {
                    wallet?.creditLimit = value
                }
                return true
                
            default:
                return true
            }
            
        case TVSections.SecondSection.rawValue:
            switch textField.tag {
                
            case TextfieldsTags.DailyLimitRO.rawValue:
                if let value = Double(textField.text ?? "0.0") {
                    wallet?.adminDailyLimit = value
                }
                return true
                
            case TextfieldsTags.MonthlyLimitRO.rawValue:
                if let value = Double(textField.text ?? "0.0") {
                    wallet?.adminMonthlyLimit = value
                }
                return true
                
            case TextfieldsTags.YearlyLimitRO.rawValue:
                if let value = Double(textField.text ?? "0.0") {
                    wallet?.adminYearlyLimit = value
                }
                return true
                
            case TextfieldsTags.CreditLimitRO.rawValue:
                if let value = Double(textField.text ?? "0.0") {
                    wallet?.creditLimit = value
                }
                return true
                
            default:
                return true
                
            }
        default:
            return true
        }
    }
    
    override func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            tvContent.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 20, right: 0)
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        tvContent.contentInset = .zero
    }
    
    // MARK : Navigation Methods
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
    
    @objc func cancelAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveAction(){
        showProgressBar()
        WalletStore.shared.editWallet(delegate: self,
                                      id: wallet?.walletId ?? "N/A",
                                      alias: wallet?.alias ?? "N/A",
                                      currency: wallet?.currencyIsoCode ?? "N/A",
                                      dailyLimit: "\(wallet?.dailyLimit ?? 0.0)",
                                      monthlyLimit: "\(wallet?.monthlyLimit ?? 0.0)",
                                      creditLimit: "\(wallet?.creditLimit ?? 0.0)")
    }
    
    @objc func registerAction(){
        if(checkIfAllFieldsAreFilled()){
            performSegueIfPossible(identifier: "registerToRegistrationSuccessful")
        }
        else{
            showAlertWithCompletion(title: "", message: Constants.Errors.ERROR_FILL_ALL_FIELDS, okTitle: "Okay", cancelTitle: nil, completionBlock: nil)
        }
    }
    
    @objc func selectCountryCode(){
        initPicker()
    }
    
    func checkIfAllFieldsAreFilled() -> Bool{

//        if(registerObject.firstname == nil || registerObject.firstname == ""){
//            return false
//        }
//        if(registerObject.lastname == nil || registerObject.lastname == ""){
//            return false
//        }
//        if(registerObject.email == nil || registerObject.email == ""){
//            return false
//        }
//        if(registerObject.phoneNumber == nil || registerObject.phoneNumber == "") {
//            return false
//        }
//        if(registerObject.password == nil || registerObject.password == "") {
//            return false
//        }
//        if(registerObject.confirmPassword == nil || registerObject.confirmPassword == "") {
//            return false
//        }
//        if(registerObject.pinCode == nil || registerObject.pinCode == 0) {
//            return false
//        }
//        if(registerObject.confirmPinCode == nil || registerObject.confirmPinCode == 0) {
//            return false
//        }
        return true
    }
    
    // MARK: Button Handlers
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

extension LimitsVC : UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK : UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //        return countries[row]
        return "Temp Text"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //        let countryCode = countries[row]
        //        registerObject.countryCode = countryCode
        //        if let cell = tvContent.cellForRow(at: IndexPath(row: TVSectionss.PhoneNumber.rawValue, section: 0)) as? RegisterVCPhoneCell {
        //            cell.btnCountryCode.setTitle(countryCode, for: .normal)
        //            tvContent.reloadData()
        //        }
    }
    
    // MARK: Custom Methods
    
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
    
    @objc func selectCurrencyAction(){
        
    }
    
    @objc func onDoneButtonTapped() {
        hidePicker()
    }
}


//An extension for Requests
extension LimitsVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        hideProgressBar()
        if status == .HTTPSuccess {
            if message != "" {
                showAlertWithCompletion(message: message, okTitle: "Ok", cancelTitle: "") {
                    self.showProgressBar()
                    User.shared.getWallets(delegate: self)
                }
            }
            else{
                showAlertWithCompletion(message: "Data updated Successfully", okTitle: "Ok", cancelTitle: "") {
                    self.showProgressBar()
                    User.shared.getWallets(delegate: self)
                }
            }
        }
        else if status == .didNotLoadRemoteData {
            if message != "" {
                showAlertWithCompletion(message: "Failed to update wallet information", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
        }
        else if status == .walletsFetchSucceeded {
            wallet = CoreDataService.getWallets().first
            tvContent.reloadData()
        }
    }
    
    func hasFinishedLoadingDataWithError(error: Error?) {
        hideProgressBar()
        showAlertWithCompletion(message: "Failed To Get Wallets", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
    }
    
}
