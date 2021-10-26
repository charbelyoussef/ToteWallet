//
//  ViewController.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class BuyTipsVC: UIViewController {

    // MARK: Class Outlets
    @IBOutlet weak var lblBalanceTitle: UILabel!
    @IBOutlet weak var lblBalanceValue: UILabel!

    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tvContent: UITableView!
    
    @IBOutlet weak var lblRequestResponse: UILabel!
    @IBOutlet weak var btnSelectWallet: UIButton!
    @IBOutlet weak var tfAmount: CustomTextField!
    @IBOutlet weak var tfOnlineFees: CustomTextField!
    @IBOutlet weak var tfTotalAmount: CustomTextField!
    
    @IBOutlet weak var btnBuyTips: RoundedButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    // MARK: Class Variables
   
    enum TextFieldsTags:Int {
        case amount
    }
    
    struct BuyObject {
        var walletId:String?
        var amount:String?
        var onlineFees:String?
        var totalAmount:String?
    }
    
    var ozowFeesDetails:OzowFee?
    var returnedBuyTipsObject:BuyTips?
    var wallets = [Wallet]()
    var buyObject = BuyObject()
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgressBar()
        User.shared.getOzowFees(delegate: self)
        
        wallets = CoreDataService.getWallets()
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
            
            let btnMaxY = self.btnBuyTips.convert(btnBuyTips.bounds, to: self.view).maxY
            if keyboardY < btnMaxY {
                self.view.frame.origin.y = keyboardY - btnMaxY - 10
            }
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    
    // MARK: Custom Methods
    func initViews(){
        
        lblBalanceTitle.text = "TOTAL BALANCE:"
        lblBalanceValue.text = "\(CoreDataService.getWallets().first?.roundedBalance ?? 0)"

        ConfigurationManager.setSecondaryLighterThemeBGColorForViews(views: [btnBuyTips])
        
        buyObject.walletId = wallets.first?.walletId
        btnSelectWallet.setTitle(wallets.first?.alias, for: .normal)
        
        tfAmount.delegate = self
        tfAmount.tag = TextFieldsTags.amount.rawValue
        tfAmount.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .done, isPassword: false)
    }
    
    func openProfile(){
        self.performSegueIfPossible(identifier: "buyTipsToProfile")
    }
    
    //MARK: Navigation Controller Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "buytipsToPayment" {
            if let vc = segue.destination as? PaymentWebviewVC {
                vc.paymentUrl = returnedBuyTipsObject?.paymentUrl
                vc.successUrl = returnedBuyTipsObject?.successUrl
                vc.failureUrl = returnedBuyTipsObject?.errorUrl
            }
        }
    }
    
    // MARK: Button Handlers
    @IBAction func btnSelectWalletAction(_ sender: Any) {
//        initPicker()
    }
    
    @IBAction func btnBuyTipsAction(_ sender: Any) {
        
        showProgressBar()
        WalletStore.shared.buyTips(delegate: self,
                                   walletId: wallets.first?.walletId ?? "N/A",
                                   subAmount: tfAmount.text ?? "N/A",
                                   amount: tfTotalAmount.text ?? "N/A",
                                   ozowFee: tfOnlineFees.text ?? "N/A")
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

//An Extension for all the UIPicker stuff
extension BuyTipsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wallets.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return wallets[row].alias
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        btnSelectWallet.setTitle("\(wallets[row].alias ?? "Select a wallet")", for: .normal)
        buyObject.walletId = wallets[row].walletId
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
    
    @objc func onDoneButtonTapped() {
        hidePicker()
    }
}

//An Extension for all the UITextfield stuff
extension BuyTipsVC : UITextFieldDelegate {
    
    // MARK: TextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        hidePicker()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case TextFieldsTags.amount.rawValue:
            if let subAmount = textField.text, subAmount != "", let onlineFees = tfOnlineFees.text, onlineFees != "", let subAmountInt = Int(subAmount), let onlineFeesInt = Int(onlineFees) {
                let totalAmount = Int(subAmountInt) + Int(onlineFeesInt)
                tfTotalAmount.text = "\(totalAmount)"
            }
            return true
        default:
            return true
        }
    }
    
}

//An extension for Requests
extension BuyTipsVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        hideProgressBar()

        if status == .ozowFeesFetchedSucceeded {
            ozowFeesDetails = CoreDataService.getOzowFees().first
            tfOnlineFees.text = ozowFeesDetails?.ozowFees
        }
        
        if status == .HTTPSuccess {
            returnedBuyTipsObject = CoreDataService.getBuyTips().first
            
            if returnedBuyTipsObject?.paymentUrl != nil, returnedBuyTipsObject?.paymentUrl != "" {
                if returnedBuyTipsObject?.successUrl != nil, returnedBuyTipsObject?.successUrl != "", returnedBuyTipsObject?.errorUrl != nil, returnedBuyTipsObject?.errorUrl != "" {
                    performSegueIfPossible(identifier: "buytipsToPayment")
                }
                else{
                    showAlertWithCompletion(message: "Success/Failure Url not available", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
                }
            }
            else {
                //                lblRequestResponse.text = message
                showAlertWithCompletion(message: "Payment Url not available", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
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
        
        else if status == .didNotLoadRemoteData {
            showAlertWithCompletion(message: message, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
    }
    
    func hasFinishedLoadingDataWithError(error: Error?) {
        hideProgressBar()
    }
}
