//
//  ViewController.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class PurchaseVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Class Outlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var lblRequestResponse: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var tvContent: UITableView!
    
    // MARK: Class Variables
    
    fileprivate enum TVSections:Int {
        case ProductName
        case Wallet
        case Amount
        case Number
        case TotalCost
        case PinCode
        case Country
        case City
        case Address
        case Buttons
    }
    
    struct PurchaseObject {
        var productName:String?
        var walletId:String?
        var amount:String?
        var number:String?
        var totalCost:String?
        var pinCode:String?
        var country:String?
        var city:String?
        var address:String?
    }
    
    var wallets = CoreDataService.getWallets()
    var countries = DataHelper.countries
    var cities = [City]()
    var selectedCountryCode:String?
    var selectedCityId:String?

    var buyObject = PurchaseObject()
    var marketPlaceProductObject:MarketplaceProduct?
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    var rowHeight:CGFloat = 70

    var user:Login?
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        setupDismissOnTap()
        addDoneButtonOnKeyboard()
        tvContent.customRegisterForCell(identifiers: ["ProductPurchaseVCDefaultCell", "ProductPurchaseVCSelectionCell", "ProductPurchaseVCButtonCell"])

        user = CoreDataService.getLogin()

        buyObject.address = user?.detailsAddress?.replacingOccurrences(of: "||", with: ", ")
        buyObject.number = "1"
        if let numberDouble = Double(buyObject.number ?? "0.0"), let settingPriceDouble = marketPlaceProductObject?.settingsPrice {
            let totalCost = numberDouble*settingPriceDouble
            buyObject.totalCost = "\(totalCost)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: UITableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let product = marketPlaceProductObject, product.isDeliverable {
            return 10
        }
        else{
            return 7
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case TVSections.Country.rawValue:
            if let product = marketPlaceProductObject, product.isDeliverable {
                return rowHeight
            }
            else{
                return 0
            }
        case TVSections.City.rawValue:
            if let product = marketPlaceProductObject, product.isDeliverable {
                return rowHeight
            }
            else{
                return 0
            }

        case TVSections.Address.rawValue:
            if let product = marketPlaceProductObject, product.isDeliverable {
                return rowHeight
            }
            else{
                return 0
            }

        default:
            return rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case TVSections.ProductName.rawValue:
            let cell:ProductPurchaseVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "ProductPurchaseVCDefaultCell", for: indexPath) as! ProductPurchaseVCDefaultCell
            
            cell.lblTitle.text = "Product Name"
            cell.tfValue.isUserInteractionEnabled = false
            cell.tfValue.tag = TVSections.ProductName.rawValue
            cell.tfValue.text = marketPlaceProductObject?.name
            cell.tfValue.backgroundColor =  cell.tfValue.isUserInteractionEnabled ? .clear : UIColor(hexString: ConfigurationManager.getAppConfiguration().readOnlyBackgroundColor ?? "")
            cell.tfValue.delegate = self
            cell.tfValue.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
            
            return cell

        case TVSections.Wallet.rawValue:
            let cell:ProductPurchaseVCSelectionCell = tableView.dequeueReusableCell(withIdentifier: "ProductPurchaseVCSelectionCell", for: indexPath) as! ProductPurchaseVCSelectionCell
            
            cell.lblTitle.text = "Choose Wallet"
            cell.btnSelection.tag = TVSections.Wallet.rawValue
            cell.btnSelection.setTitle(wallets.first?.alias, for: .normal)
//            cell.tfValue.text = user?.lastName
//            cell.tfValue.delegate = self
//            cell.tfValue.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
            
            return cell

            
        case TVSections.Amount.rawValue:
            let cell:ProductPurchaseVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "ProductPurchaseVCDefaultCell", for: indexPath) as! ProductPurchaseVCDefaultCell
            
            cell.lblTitle.text = "Amount"
            cell.tfValue.isUserInteractionEnabled = false
            cell.tfValue.tag = TVSections.Amount.rawValue
            cell.tfValue.backgroundColor =  cell.tfValue.isUserInteractionEnabled ? .clear : UIColor(hexString: ConfigurationManager.getAppConfiguration().readOnlyBackgroundColor ?? "")
            cell.tfValue.text = "\(marketPlaceProductObject?.settingsPrice ?? 0.0)"
            cell.tfValue.delegate = self
            cell.tfValue.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
            
            return cell

        case TVSections.Number.rawValue:
            let cell:ProductPurchaseVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "ProductPurchaseVCDefaultCell", for: indexPath) as! ProductPurchaseVCDefaultCell
            
            cell.lblTitle.text = "Number"
            
            cell.tfValue.tag = TVSections.Number.rawValue
            cell.tfValue.text = buyObject.number
            cell.tfValue.delegate = self
            cell.tfValue.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
            
            return cell

        case TVSections.TotalCost.rawValue:
            let cell:ProductPurchaseVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "ProductPurchaseVCDefaultCell", for: indexPath) as! ProductPurchaseVCDefaultCell
            
            cell.lblTitle.text = "Total Cost"
            cell.tfValue.isUserInteractionEnabled = false
            cell.tfValue.tag = TVSections.TotalCost.rawValue
            cell.tfValue.text = buyObject.totalCost
            cell.tfValue.backgroundColor =  cell.tfValue.isUserInteractionEnabled ? .clear : UIColor(hexString: ConfigurationManager.getAppConfiguration().readOnlyBackgroundColor ?? "")
            cell.tfValue.delegate = self
            cell.tfValue.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
            
            return cell

        case TVSections.PinCode.rawValue:
            let cell:ProductPurchaseVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "ProductPurchaseVCDefaultCell", for: indexPath) as! ProductPurchaseVCDefaultCell
            
            cell.lblTitle.text = "Pin Code"
            cell.tfValue.tag = TVSections.PinCode.rawValue
//            cell.tfValue.text = user?.lastName
            cell.tfValue.delegate = self
            cell.tfValue.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
            
            return cell

        case TVSections.Country.rawValue:
            let cell:ProductPurchaseVCSelectionCell = tableView.dequeueReusableCell(withIdentifier: "ProductPurchaseVCSelectionCell", for: indexPath) as! ProductPurchaseVCSelectionCell
            
            cell.lblTitle.text = "Country"
//            let country = DataHelper.getcountryForId(countryId: "\(user?.detailsCountryId ?? -1)")
//            cell.btnSelection.setTitle(country?.name, for: .normal)
            cell.btnSelection.tag = TVSections.Country.rawValue
            cell.btnSelection.addTarget(self, action: #selector(selectCountryAction), for: .touchDown)
            
            return cell
            
        case TVSections.City.rawValue:
            let cell:ProductPurchaseVCSelectionCell = tableView.dequeueReusableCell(withIdentifier: "ProductPurchaseVCSelectionCell", for: indexPath) as! ProductPurchaseVCSelectionCell
            
            cell.lblTitle.text = "City"
//            cell.btnSelection.setTitle(user?.cityName, for: .normal)
            cell.btnSelection.tag = TVSections.City.rawValue
            cell.btnSelection.addTarget(self, action: #selector(selectCityAction), for: .touchDown)
            
            return cell

        case TVSections.Address.rawValue:
            let cell:ProductPurchaseVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "ProductPurchaseVCDefaultCell", for: indexPath) as! ProductPurchaseVCDefaultCell
            
            cell.lblTitle.text = "Address"
            cell.tfValue.tag = TVSections.Address.rawValue
            cell.tfValue.text = buyObject.address
            cell.tfValue.delegate = self
            cell.tfValue.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
            
            return cell

        case TVSections.Buttons.rawValue:
            let cell:ProductPurchaseVCButtonCell = tableView.dequeueReusableCell(withIdentifier: "ProductPurchaseVCButtonCell", for: indexPath) as! ProductPurchaseVCButtonCell
            
//            cell.btnSelection.setTitle(user?.cityName, for: .normal)
//            cell.btnSelection.tag = TextfieldsTags.Province.rawValue
            cell.btnCancel.addTarget(self, action: #selector(cancelAction), for: .touchDown)
            cell.btnPurchase.addTarget(self, action: #selector(purchaseAction), for: .touchDown)
            
            return cell

            
        default:
            return UITableViewCell()
        }
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
            let keyboardHeight = keyboardFrame.cgRectValue.height
            tvContent.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 20, right: 0)
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        tvContent.contentInset = .zero
    }
    
    // MARK: Custom Methods
    
    @objc func selectCountryAction(){
//        initPicker(tag: TVSections.Country.rawValue)
        selectCountryCode()
    }
    
    @objc func selectCityAction(){
        if let selectedCountry = DataHelper.getcountry(for: selectedCountryCode ?? "N/A") {
            showProgressBar()
            User.shared.getCitiesForCountry(delegate: self, countryId: selectedCountry.id)
        }
        else{
            showAlertWithCompletion(message: "Kindly select a country first", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
    }
    
    // MARK: Button Handlers
    @IBAction func btnSelectWalletAction(_ sender: Any) {
//        initPicker(tag: PurchaseProductPickers.Wallet.rawValue)
    }
    
    @IBAction func btnSelectCountryAction(_ sender: Any) {
        initPicker(tag: TVSections.Country.rawValue)
    }
        
    @objc func purchaseAction(){

        if selectedCountryCode == nil || selectedCountryCode == "" {
            showAlertWithCompletion(message: "Kindly select a country first", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            return
        }
        
        if selectedCityId == nil ||  selectedCityId == "" {
            showAlertWithCompletion(message: "Kindly select a city first", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            return
        }
        
        let selectedCountry = DataHelper.getcountry(for: selectedCountryCode ?? "N/A")

        
        if let addressStr = buyObject.address, addressStr != "", let pinCodeStr = buyObject.pinCode, pinCodeStr != "" {
            showProgressBar()

            MarketplaceStore.shared.purchaseProduct(delegate: self,
                                                    pinCode: pinCodeStr,
                                                    id: "\(marketPlaceProductObject?.id ?? -1)",
                                                    sender: wallets.first?.walletId ?? "N/A",
                                                    address: addressStr,
                                                    countryId: "\(selectedCountry?.id ?? -1)",
                                                    cityId: selectedCityId ?? "N/A",
                                                    quantity: buyObject.number ?? "-1")
        }
    }
    
    @objc func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHomeAction(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: CustomTabBarController.self)
    }
    
}

// MARK: CountryDropDown Methods
extension PurchaseVC: CustomCountryDropDownDelegate {
    
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
//                registerObject.countryCode = "\(country.id)"
            if let cell = tvContent.cellForRow(at: IndexPath(row: TVSections.Country.rawValue, section: 0)) as? ProductPurchaseVCSelectionCell {
                selectedCountryCode = "\(country.phoneCode)"
                cell.btnSelection.setTitle(country.codeWithName, for: .normal)
                tvContent.reloadData()
            }
        }
    }
    
    @objc func selectCountryCode(){
        openDropDown(title: "Select Country", data: DataHelper.countries, tag: -1)
    }
}

// MARK: CityDropDown Methods
extension PurchaseVC: CustomCityDropDownDelegate {
    
    // MARK: CustomDropDown Methods
    @objc func openCityDropDown(title: String, data:[City], tag:Int){
        resignFirstResponder()
        CustomCityDropDown.open(title:"Select City",
                        data: data,
                        selectedItems: nil,
                        delegate: self,
                        multipleSelection: false,
                        tag:tag)
    }
    
    func dropDownCityDidSelect(contentReturned: [City], tag: Int) {
        if let city = contentReturned.first {
//                registerObject.countryCode = "\(country.id)"
            if let cell = tvContent.cellForRow(at: IndexPath(row: TVSections.City.rawValue, section: 0)) as? ProductPurchaseVCSelectionCell {
                cell.btnSelection.setTitle(city.name, for: .normal)
                tvContent.reloadData()
            }
        }
    }
    
    @objc func selectCity(){
        openCityDropDown(title: "Select City", data: cities, tag: -1)
    }
}

extension PurchaseVC : UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK : UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch picker.tag {
        case TVSections.Wallet.rawValue:
            return wallets.count

        case TVSections.Country.rawValue:
            return countries.count
            
        case TVSections.City.rawValue:
            return cities.count

        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch picker.tag {
        case TVSections.Wallet.rawValue:
            return wallets[row].alias

        case TVSections.Country.rawValue:
            return countries[row].name
            
        case TVSections.City.rawValue:
            return cities[row].name

        default:
            return "N/A"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch picker.tag {
        case TVSections.Wallet.rawValue:
//            btnSelectWallet.setTitle("\(wallets[row].alias ?? "Select a wallet")", for: .normal)
//            buyObject.walletId = wallets[row].walletId ?? "N/A"
            break
            
        case TVSections.Country.rawValue:
            selectedCountryCode = "\(countries[row].phoneCode)"
            let country = countries[row]
            if let cell = tvContent.cellForRow(at: IndexPath(row: TVSections.Country.rawValue, section: 0)) as? ProductPurchaseVCSelectionCell {
//                user?.countryCode = country.phoneCode
//                cell.btnCountryCode.setTitle(country.codeWithName, for: .normal)
                cell.btnSelection.setTitle(country.codeWithName, for: .normal)
                tvContent.reloadData()
            }

//            btnSelectCountry.setTitle("\(countries[row].name ?? "N/A")", for: .normal)
//            btnSelectCity.setTitle("", for: .normal)
            selectedCityId = ""
            break
            
        case TVSections.City.rawValue:
            selectedCityId = "\(cities[row].id ?? "N/A")"
            let city = cities[row]

            if let cell = tvContent.cellForRow(at: IndexPath(row: TVSections.City.rawValue, section: 0)) as? ProductPurchaseVCSelectionCell {
//                user?.countryCode = country.phoneCode
//                cell.btnCountryCode.setTitle(country.codeWithName, for: .normal)
                cell.btnSelection.setTitle(city.name, for: .normal)
                tvContent.reloadData()
            }

//            selectedCityId = provinces[row].id
//            btnSelectCity.setTitle("\(provinces[row].name ?? "N/A")", for: .normal)
            break
            
        default:
            break
        }
        
    }
    
    // MARK : Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentingVCToPresentedVC" {
//            let vc = segue.destination as? UIViewController
//            if vc != nil{
//                //                if let indexPath = tvContent.indexPathForSelectedRow{
//                //                    // set presented view controller data
//                //                }
//            }
        }
    }
    
    // MARK : Custom Picker Methods
    func initPicker(tag: Int){
        if(!picker.isKind(of: CustomPickerView.self)){
            picker = CustomPickerView()
            picker.delegate = self
            picker.dataSource = self
            toolBar = CustomPickerToolbar()
            let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

            toolBar.items = [flexButton, UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        }
        
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
extension PurchaseVC : UITextFieldDelegate {
    
    // MARK: TextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        hidePicker()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case TVSections.Number.rawValue:
            buyObject.number = textField.text ?? "N/A"
            if let numberDouble = Double(buyObject.number ?? "0.0"), let settingPriceDouble = marketPlaceProductObject?.settingsPrice {
                let totalCost = numberDouble*settingPriceDouble
                buyObject.totalCost = "\(totalCost)"
                if let cell = tvContent.cellForRow(at: IndexPath(row: TVSections.TotalCost.rawValue, section: 0)) as? ProductPurchaseVCDefaultCell {
                    cell.tfValue.text = "\(buyObject.totalCost ?? "N/A")"
                    tvContent.reloadData()
                }
            }
            return true

        case TVSections.PinCode.rawValue:
            buyObject.pinCode = textField.text ?? "N/A"
            return true

        case TVSections.Address.rawValue:
            buyObject.address = textField.text
            return true

        default:
            return true
        }
    }
}

//An extension for Requests
extension PurchaseVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        hideProgressBar()
        
        if status == .HTTPSuccess {
//            lblRequestResponse.text = message
            if message != "" {
                showAlertWithCompletion(message: message.htmlToString, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
            else{
                showAlertWithCompletion(message: Constants.Errors.GENERAL_ERROR, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
        }
        else if status == .citiesFetchSucceeded {
            cities = CoreDataService.getAllCities(ascending: true)
            selectedCityId = cities.first?.id
            selectCity()
//            initPicker(tag: TVSections.City.rawValue)
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
            showAlertWithCompletion(message: error?.localizedDescription ?? Constants.Errors.GENERAL_ERROR, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
        else{
            showAlertWithCompletion(message: Constants.Errors.GENERAL_ERROR, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
    }
    
}
