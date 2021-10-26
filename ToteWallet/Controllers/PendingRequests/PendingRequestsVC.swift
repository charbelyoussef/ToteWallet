//
//  RegisterVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import ContactsUI

class PendingRequestsVC : UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, CalendarPickerDelegate {
    
    // MARK: Class Outlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tvContent: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnFilter: RoundedButton!
    @IBOutlet weak var btnClear: RoundedButton!
    @IBOutlet weak var vSeparatorSender: UIView!
    @IBOutlet weak var vSeparatorReceiver: UIView!
    @IBOutlet weak var vFromDate: UIView!
    @IBOutlet weak var vToDate: UIView!
    @IBOutlet weak var lblFromDate: UILabel!
    @IBOutlet weak var lblToDate: UILabel!
    @IBOutlet weak var tfSenderPhoneNumber: UITextField!
    @IBOutlet weak var tfrecipientPhoneNumber: UITextField!
    @IBOutlet weak var btnSenderCountryCode: UIButton!
    @IBOutlet weak var btnReceiverCountryCode: UIButton!

    // MARK: Class Variables
    var rowHeight:CGFloat = 150
    var contentArray:[PendingRequest]?
    var selectedPendingRequestTag = -1
    var selectedFromDate:Date?
    var selectedToDate:Date?

    var defaultDescriptionLines = 2

    
    struct FilterObject {
        var walletId:String?
        var senderCountryId:String?
        var senderPhoneNumber:String?
        var receiverCountryId:String?
        var receiverPhoneNumber:String?
    }
    
    enum TextFieldsTags:Int{
        case senderPhoneNumber
        case receiverPhoneNumber
    }
    
    fileprivate enum PickersSelection:Int {
        case SenderCountryCode
        case ReceiverCountryCode
    }
    
    var filterObject = FilterObject()

    var wallet:Structs.Wallet?
    var countries = DataHelper.countries
    
    var picker = UIPickerView()
    var toolBar  = UIToolbar()
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tvContent.customRegisterForCell(identifiers: ["PendingRequestsVCDefaultCell"])

        let fromDate = Date.daysFromNowWithoutTime(days: -20)
        let toDate = Date.getTodayWithoutTime()

        selectedFromDate = fromDate
        selectedToDate = toDate

        registerForKeyboardNotifications()
        setupDismissOnTap()
        addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initViews()
        fetchPendingRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK : TableView Methods
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return rowHeight
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PendingRequestsVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "PendingRequestsVCDefaultCell", for: indexPath) as! PendingRequestsVCDefaultCell
        
        cell.configureCell(indexPath:indexPath, pendingRequest: contentArray?[indexPath.row])
        
        cell.btnExpand.tag = indexPath.row
        cell.btnExpand.addTarget(self, action: #selector(expandDescription), for: .touchUpInside)
        cell.btnExpand.isHidden = cell.maxDescriptionLines <= defaultDescriptionLines

        if cell.maxDescriptionLines <= defaultDescriptionLines {
            cell.lblDescription.numberOfLines = cell.maxDescriptionLines
            cell.btnExpand.isHidden = true
            cell.cstrBtnExpandHeight.constant = 0
        }
        else {
            cell.btnExpand.isHidden = false
            cell.cstrBtnExpandHeight.constant = 20
            cell.lblDescription.numberOfLines = cell.notificationsOpen ? cell.maxDescriptionLines : defaultDescriptionLines
        }
        cell.btnCancel.tag = indexPath.row
        cell.btnConfirm.tag = indexPath.row

        cell.btnCancel.addTarget(self, action: #selector(cancelPendingRequest), for: .touchUpInside)
        cell.btnConfirm.addTarget(self, action: #selector(confirmPendingRequest), for: .touchUpInside)

        return cell
    }
    
    // MARK: Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pendingRequestToConfirmPendingRequest" {
            let vc = segue.destination as? ConfirmPendingRequestVC
            if vc != nil{
                if let selectedPendingRequestTemp = contentArray?[selectedPendingRequestTag] {
                    vc?.selectedPendingRequest = selectedPendingRequestTemp
                }
            }
        }
    }
    
    // MARK: CalendarPicker Delegate Methods
    func datesSelected(firstDate: Date, lastDate: Date) {
        selectedFromDate = firstDate
        selectedToDate = lastDate
        
        lblFromDate.text = selectedFromDate?.toString(format: "MMM dd, YYYY")
        lblToDate.text = selectedToDate?.toString(format: "MMM dd, YYYY")
        
        lblFromDate.text = firstDate.toString(format: "MMM dd, YYYY")
        lblToDate.text = lastDate.toString(format: "MMM dd, YYYY")
    }
    
    // MARK: Custom Methods
    func initViews(){
        vFromDate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCalendarPicker)))
        vToDate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCalendarPicker)))
        
        lblFromDate.text = selectedFromDate?.toString(format: "MMM dd, YYYY")
        lblToDate.text = selectedToDate?.toString(format: "MMM dd, YYYY")
        
        ConfigurationManager.setPrimaryLighterThemeBGColorForViews(views: [btnFilter])
        vSeparatorSender.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().textFieldsBorderColor ?? "")
        vSeparatorReceiver.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().textFieldsBorderColor ?? "")

        tfSenderPhoneNumber.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
        tfSenderPhoneNumber.tag = TextFieldsTags.senderPhoneNumber.rawValue
        
        if let defaultCountry = CoreDataService.getAppConfiguration().first {
            filterObject.senderCountryId = defaultCountry.countryId
            btnSenderCountryCode.setTitle(defaultCountry.codeWithName, for: .normal)
        }
        else{
            filterObject.senderCountryId = "\(countries.first?.id ?? -1)"
            btnSenderCountryCode.setTitle(countries.first?.codeWithName, for: .normal)
        }
        tfSenderPhoneNumber.delegate = self
        
        if let defaultCountry = CoreDataService.getAppConfiguration().first {
            filterObject.receiverCountryId = defaultCountry.countryId
            btnReceiverCountryCode.setTitle(defaultCountry.codeWithName, for: .normal)
        }
        else{
            filterObject.receiverCountryId = "\(countries.first?.id ?? -1)"
            btnReceiverCountryCode.setTitle(countries.first?.codeWithName, for: .normal)
        }
        tfrecipientPhoneNumber.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
        tfrecipientPhoneNumber.tag = TextFieldsTags.receiverPhoneNumber.rawValue
        tfrecipientPhoneNumber.delegate = self
    }
    
    @objc func openCalendarPicker() {
        CalendarPickerVC.open(firstDate: selectedFromDate,
                              lastDate: selectedToDate,
                              delegate: self,
                              multipleSelection: true)
    }

    @objc func expandDescription(sender: UIButton!) {
    
        let tag = sender.tag
        let indexPath = IndexPath(row: tag, section: 0)
        
        if let cell = tvContent.cellForRow(at: indexPath) as? PendingRequestsVCDefaultCell {
            cell.notificationsOpen = !cell.notificationsOpen
            
            cell.btnExpand.setTitle(cell.notificationsOpen ? "Read Less" : "Read More", for: .normal)
            cell.maxDescriptionLines = cell.lblDescription.getActualLineNumber()
            
            cell.editingAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 5))
            cell.editingAccessoryView?.backgroundColor = UIColor.green
        }
        self.tvContent.reloadData()
    }

    @objc func cancelPendingRequest(sender: UIButton!) {
        showProgressBar()
        let tag = sender.tag
        
        let pendingRequest = contentArray?[tag]
        if pendingRequest != nil, pendingRequest?.pendingRequestId != "" {
            User.shared.cancelPendingRequest(delegate: self, id: pendingRequest?.pendingRequestId ?? "N/A")
        }
        else{
            showAlertWithCompletion(message: "Pendind request id not available", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
    }

    @objc func confirmPendingRequest(sender: UIButton!) {
    
        let tag = sender.tag
        selectedPendingRequestTag = tag
        performSegueIfPossible(identifier: "pendingRequestToConfirmPendingRequest")
    }
    
    func fetchPendingRequest(){
        showProgressBar()
        contentArray?.removeAll()
        tvContent.reloadData()
        User.shared.getPendingRequestsWithFilter(delegate: self,
                                                 senderCountryId: filterObject.senderCountryId ?? "N/A",
                                                 senderPhoneNumber: filterObject.senderPhoneNumber ?? "N/A",
                                                 receiverCountryId: filterObject.receiverCountryId ?? "N/A",
                                                 receiverPhoneNumber: filterObject.receiverPhoneNumber ?? "N/A",
                                                 fromDate: selectedFromDate ?? Date(),
                                                 toDate: selectedToDate ?? Date())
    }
    
    func resetTableView() {
        contentArray?.removeAll()
        CoreDataService.clearPendingRequests()
        tvContent.reloadData()
    }
    
    // MARK: Button Handlers
    @IBAction func btnFilterAction(_ sender: Any) {
        resetTableView()
        fetchPendingRequest()
    }
    
    @IBAction func btnClearAction(_ sender: Any) {
        resetTableView()
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
    
    @IBAction func btnSenderCountryCodeAction(_ sender: Any) {
//        initPicker(tag: PickersSelection.SenderCountryCode.rawValue)
        selectCountryCode(tag: PickersSelection.SenderCountryCode.rawValue)

    }
    
    @IBAction func btnReceiverCountryCode(_ sender: Any) {
//        initPicker(tag: PickersSelection.ReceiverCountryCode.rawValue)
        selectCountryCode(tag: PickersSelection.ReceiverCountryCode.rawValue)
    }
    
    
}

// MARK: Contact Selection Methods
extension PendingRequestsVC: CNContactPickerDelegate {
    
    func setNumberFromContact(countryCode: String?, phoneNumber: String, picker:CNContactPickerViewController) {

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
        
        switch picker.accessibilityLabel {
        case "\(PickersSelection.SenderCountryCode.rawValue)":
            tfSenderPhoneNumber.text = phoneNumber // String(phoneNumber.suffix(10))
            filterObject.senderPhoneNumber = phoneNumber
            if countryCode != nil, countryCode != "" {
                var countryCodeTemp = countryCode?.replacingOccurrences(of: "\\p{Cf}", with: "", options: .regularExpression)
                if countryCodeTemp != nil, countryCodeTemp!.contains("+"){
                    countryCodeTemp = countryCodeTemp?.replacingOccurrences(of: "+", with: "")
                }
                if let country = DataHelper.getcountry(for: countryCodeTemp!) {
                    filterObject.senderCountryId = "\(country.id)"
                    btnSenderCountryCode.setTitle(country.codeWithName, for: .normal)
                }
            }
            break
            
        case "\(PickersSelection.ReceiverCountryCode.rawValue)":
            tfrecipientPhoneNumber.text = phoneNumber // String(phoneNumber.suffix(10))
            filterObject.receiverPhoneNumber = phoneNumber
            if countryCode != nil, countryCode != "" {
                var countryCodeTemp = countryCode?.replacingOccurrences(of: "\\p{Cf}", with: "", options: .regularExpression)
                if countryCodeTemp != nil, countryCodeTemp!.contains("+"){
                    countryCodeTemp = countryCodeTemp?.replacingOccurrences(of: "+", with: "")
                }
                if let country = DataHelper.getcountry(for: countryCodeTemp!) {
                    filterObject.receiverCountryId = "\(country.id)"
                    btnReceiverCountryCode.setTitle(country.codeWithName, for: .normal)
                }
            }
            break
            
        default:
            break
        }
        
    }
    
    //MARK: Contact picker
    func onClickPickContact(tag: Int){
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.accessibilityLabel = "\(tag)"
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
                    setNumberFromContact(countryCode: String(countryCode), phoneNumber: formattedString, picker: picker)
                }
            }
            
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
    
    @IBAction func btnSelectSenderFromContactsAction(_ sender: Any) {
        onClickPickContact(tag: PickersSelection.SenderCountryCode.rawValue)
    }

    @IBAction func btnSelectReceiverFromContactsAction(_ sender: Any) {
        onClickPickContact(tag: PickersSelection.ReceiverCountryCode.rawValue)
    }
}

// MARK: CountryDropDown Methods
extension PendingRequestsVC: CustomCountryDropDownDelegate {
    
    // MARK: CustomDropDown Methods
    @objc func openDropDown(title: String, data:[Country], tag:Int){
        resignFirstResponder()
        switch tag {
        case PickersSelection.SenderCountryCode.rawValue:
            CustomCountryDropDown.open(title:"Select Country",
                            data: data,
                            selectedItems: nil,
                            delegate: self,
                            multipleSelection: false,
                            tag:tag)
            break
            
        case PickersSelection.ReceiverCountryCode.rawValue:
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
        case PickersSelection.SenderCountryCode.rawValue:
            if let country = contentReturned.first {
                btnSenderCountryCode.setTitle("\(country.codeWithName ?? "N/A")", for: .normal)
                filterObject.senderCountryId = "\(country.id)"
            }
            break
            
        case PickersSelection.ReceiverCountryCode.rawValue:
            if let country = contentReturned.first {
                btnReceiverCountryCode.setTitle("\(country.codeWithName  ?? "N/A")", for: .normal)
                filterObject.receiverCountryId = "\(country.id)"
            }
            break
            
        default:
            break
        }

    }
    
    func selectCountryCode(tag: Int){
        openDropDown(title: "Select Country", data: DataHelper.countries, tag: tag)
    }
}

// MARK: UIPicker Methods
extension PendingRequestsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch picker.tag {
        case PickersSelection.SenderCountryCode.rawValue:
            return countries.count

        case PickersSelection.SenderCountryCode.rawValue:
            return countries.count

        default:
            return countries.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch picker.tag {
        case PickersSelection.SenderCountryCode.rawValue:
            return countries[row].codeWithName

        case PickersSelection.SenderCountryCode.rawValue:
            return countries[row].codeWithName

        default:
            return countries[row].codeWithName
        }

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch picker.tag {
        case PickersSelection.SenderCountryCode.rawValue:
            btnSenderCountryCode.setTitle("\(countries[row].codeWithName ?? "N/A")", for: .normal)
            filterObject.senderCountryId = "\(countries[row].id)"
            
        case PickersSelection.ReceiverCountryCode.rawValue:
            btnReceiverCountryCode.setTitle("\(countries[row].codeWithName  ?? "N/A")", for: .normal)
            filterObject.receiverCountryId = "\(countries[row].id)"

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
        }
        
        picker.reloadAllComponents()
        picker.tag = tag
        picker.delegate = self
        picker.dataSource = self
        picker.reloadAllComponents()
        picker.selectRow(0, inComponent: 0, animated: true)
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
extension PendingRequestsVC : UITextFieldDelegate {
    
    // MARK: TextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        hidePicker()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case TextFieldsTags.senderPhoneNumber.rawValue:
            filterObject.senderPhoneNumber = textField.text
            return true

        case TextFieldsTags.receiverPhoneNumber.rawValue:
            filterObject.receiverPhoneNumber = textField.text
            return true

        default:
            return true
        }
    }
    
}

//An extension for Requests
extension PendingRequestsVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        hideProgressBar()

        if status == .HTTPSuccess {
            contentArray = CoreDataService.getPendingRequests()
            tvContent.reloadData()
        }
    
        else if status == .didCancelPendingRequest {
            if message != "" {
                showAlertWithCompletion(message: message, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
            fetchPendingRequest()
        }
            
        else if status == .didNotLoadRemoteData {
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
        if error != nil, error?.localizedDescription != "" {
            showAlertWithCompletion(message: error?.localizedDescription ?? "N/A", okTitle: "Retry", cancelTitle: "Cancel") {
                self.showProgressBar()
                User.shared.getTransactions(delegate: self)
            }
        }
        else{
            showAlertWithCompletion(message: "Failed To Get Pending Requests", okTitle: "Retry", cancelTitle: "Cancel") {
                self.fetchPendingRequest()
            }
        }
    }
    
}
