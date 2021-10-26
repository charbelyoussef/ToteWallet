//
//  ViewController.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit


class ConfirmPendingRequestVC: UIViewController,UINavigationControllerDelegate {
    //        btnNotifications.setup(selectedBGColor: configColor, deselectedBGColor: UIColor.white, checkColor: UIColor.white, borderColor: configColor, selected: false)

    // MARK: Class Outlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tvContent: UITableView!
//    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var btnSelectWallet: CustomSelectionButton!
    @IBOutlet weak var btnConfirmRequest: RoundedButton!
//    @IBOutlet weak var vSeparator: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblRequestResponse: UILabel!

//    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfAmountOfTips: CustomTextField!
    @IBOutlet weak var tfDescription: CustomTextField!
    @IBOutlet weak var tfPin: CustomTextField!
    @IBOutlet weak var tfSendTo: CustomTextField!
    
    // MARK: Class Variables
    
    var contentArray = NSMutableArray()
    var selectedPendingRequest:PendingRequest?
    
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
            let keyboardY = UIScreen.main.bounds.size.height - keyboardHeight
            
            let btnMaxY = self.btnConfirmRequest.convert(btnConfirmRequest.bounds, to: self.view).maxY
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
        ConfigurationManager.setSecondaryLighterThemeBGColorForViews(views: [btnConfirmRequest])
//        vSeparator.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().textFieldsBorderColor ?? "")
        
//        countryId = Int(countries[0].id)
//        btnCountryCode.setTitle(countries.first?.codeWithName, for: .normal)
        
        btnSelectWallet.setTitle(wallets.first?.alias, for: .normal)
        
//        tfPhoneNumber.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
//        tfPhoneNumber.delegate = self
        
        tfSendTo.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .done, isPassword: false)
        tfSendTo.text = selectedPendingRequest?.receiverOwnerName
        tfSendTo.delegate = self

        tfAmountOfTips.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
        tfAmountOfTips.text = selectedPendingRequest?.baseAmount
        tfAmountOfTips.delegate = self
        
        tfDescription.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .done, isPassword: false)
        tfDescription.text = selectedPendingRequest?.desc
        tfDescription.delegate = self
        
        tfPin.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: true)
        tfPin.delegate = self
    }
        
    // MARK: Button Handlers
    @IBAction func btnConfirmRequestAction(_ sender: Any) {

        if let recipient = tfSendTo.text, recipient != "",
            let amountOfTips = tfAmountOfTips.text, amountOfTips != "",
            let description = tfDescription.text, description != "",
            let pin = tfPin.text, pin != "",
            let pendingRequestId = selectedPendingRequest?.pendingRequestId,
            let walletId = wallets.first?.walletId, walletId != ""
        {
            showProgressBar()
            User.shared.confirmPendingRequest(delegate:self,
                                              id: pendingRequestId,
                                              senderWalletId: walletId,
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
        initPicker(tag: Enums.Pickers.Country.rawValue)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        revealMenu()
    }

}

//An Extension for all the UIPicker stuff
extension ConfirmPendingRequestVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
//            btnCountryCode.setTitle("\(countries[row].codeWithName ?? "N/A")", for: .normal)
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
        self.view.addSubview(picker)
        self.view.addSubview(toolBar)
    }
    
    func hidePicker(){
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    @objc func onDoneButtonTapped() {
        hidePicker()
    }
}

//An Extension for all the UITextfield stuff
extension ConfirmPendingRequestVC : UITextFieldDelegate {
    
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
extension ConfirmPendingRequestVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        hideProgressBar()

        if status == .didConfirmPendingRequest {
            var messageTemp = message
            
            if messageTemp == "" {
                messageTemp = "Success"
            }
            
            showAlertWithCompletion(message: messageTemp, okTitle: "Ok", cancelTitle: "") {
                WalletHelper.reloadWallets(vc: self)
            }

        }
        else if status == .didNotLoadRemoteData {
            showAlertWithCompletion(message: message, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
    }
    
    func hasFinishedLoadingDataWithError(error: Error?) {
        if error != nil, let errorMessage = error?.localizedDescription, errorMessage != "" {
            showAlertWithCompletion(message: errorMessage, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
        else{
            showAlertWithCompletion(message: "Failed to complete your request", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
    }
}
