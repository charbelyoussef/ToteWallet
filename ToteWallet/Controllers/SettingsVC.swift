//
//  RegisterVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import SideMenu

class SettingsVC : UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, CustomCheckBoxDelegate {
    
    // MARK: Class Outlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tvContent: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnSelectWallet: UIButton!
    @IBOutlet weak var lblBalanceTitle: UILabel!
    @IBOutlet weak var lblBalanceValue: UILabel!

    @IBOutlet weak var btnUpdateSettings: RoundedButton!
    
    @IBOutlet weak var btnReceiveNotificationsBySms: CustomCheckBox!
    @IBOutlet weak var btnReceiveSmsOnMoneySent: CustomCheckBox!
    @IBOutlet weak var btnReceiveSmsOnMoneyReceived: CustomCheckBox!
    @IBOutlet weak var btnReceiveSmsOnPurchase: CustomCheckBox!
    
    // MARK: Class Variables
    
    enum CheckBoxes:Int {
        case ReceiveNotificationBySms
        case SmsMoneySent
        case SmsMoneyReceived
        case SmsProductPurchased
    }
    
    fileprivate struct SettingsObject {
        var walletId:String?
        var receiveNotificationsBySms:Bool?
        var receiveSmsOnMoneySent:Bool?
        var receiveSmsOnMoneyReceived:Bool?
        var receiveSmsOnPurchase:Bool?
    }
    
    var userSettings = CoreDataService.getUserSettings()
    let context = CoreDataManager.shared.context

    var wallets = [Wallet]()
    fileprivate var settingsObject = SettingsObject()
    
    var toolBar = UIToolbar()
    var picker:UIPickerView?
    var profileSettings = CoreDataService.getProfileSettings()
    
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
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
    
    // MARK: CustomCheckBox Methods
    func checkBoxChanged(checkBox: CustomCheckBox, checked: Bool) {
        switch checkBox.tag {
        case CheckBoxes.ReceiveNotificationBySms.rawValue:
            userSettings?.receiveNotificationBySms = checked
            CoreDataManager.shared.saveContext(context)
            break
       
        case CheckBoxes.SmsMoneySent.rawValue:
            userSettings?.sms_money_sent = checked
            CoreDataManager.shared.saveContext(context)
            break

        case CheckBoxes.SmsMoneyReceived.rawValue:
            userSettings?.sms_money_received = checked
            CoreDataManager.shared.saveContext(context)
            break
            
        case CheckBoxes.SmsProductPurchased.rawValue:
            userSettings?.sms_product_purchased = checked
            CoreDataManager.shared.saveContext(context)
            break
            
        default:
            break
        }
    }
    
    
    // MARK: Custom Methods

    func initViews(){
        self.tabBarController?.tabBar.isHidden = false

        wallets = CoreDataService.getWallets()

        lblBalanceTitle.text = "TOTAL BALANCE:"
        lblBalanceValue.text = "\(wallets.first?.roundedBalance ?? 0)"

        let configColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimary ?? "")
        
        settingsObject.walletId = wallets.first?.walletId
        btnSelectWallet.setTitle(wallets.first?.alias, for: .normal)
        
        btnReceiveNotificationsBySms.setup(selectedBGColor: configColor, deselectedBGColor: UIColor.white, checkColor: UIColor.white, borderColor: configColor, selected: userSettings?.receiveNotificationBySms ?? false)
        btnReceiveNotificationsBySms.delegate = self
        btnReceiveNotificationsBySms.tag = CheckBoxes.ReceiveNotificationBySms.rawValue
        
        btnReceiveSmsOnMoneySent.setup(selectedBGColor: configColor, deselectedBGColor: UIColor.white, checkColor: UIColor.white, borderColor: configColor, selected: userSettings?.sms_money_sent ?? false)
        btnReceiveSmsOnMoneySent.delegate = self
        btnReceiveSmsOnMoneySent.tag = CheckBoxes.SmsMoneySent.rawValue
        
        btnReceiveSmsOnMoneyReceived.setup(selectedBGColor: configColor, deselectedBGColor: UIColor.white, checkColor: UIColor.white, borderColor: configColor, selected: userSettings?.sms_money_received ?? false)
        btnReceiveSmsOnMoneyReceived.delegate = self
        btnReceiveSmsOnMoneyReceived.tag = CheckBoxes.SmsMoneyReceived.rawValue
        
        btnReceiveSmsOnPurchase.setup(selectedBGColor: configColor, deselectedBGColor: UIColor.white, checkColor: UIColor.white, borderColor: configColor, selected: userSettings?.sms_product_purchased ?? false)
        btnReceiveSmsOnPurchase.delegate = self
        btnReceiveSmsOnPurchase.tag = CheckBoxes.SmsProductPurchased.rawValue
        
        ConfigurationManager.setSecondaryLighterThemeBGColorForViews(views: [btnUpdateSettings])
        ConfigurationManager.setPrimaryLighterThemeBGColorAsTextForObjects(objects: [lblBalanceTitle, lblBalanceValue])
    }
    
    // MARK: Button Handlers
    @IBAction func btnSelectWalletAction(_ sender: Any) {
//        initPicker()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        revealMenu()
        CustomTabBarController.indexToOpen = Enums.TabBarSections.Settings.rawValue
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUpdateSettingsAction(_ sender: Any) {
        
    }
    
}

//An Extension for all the UIPicker stuff
extension SettingsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        settingsObject.walletId = wallets[row].walletId
    }
    
    // MARK: Custom Methods
    func initPicker(){
        if(picker == nil){
            picker = UIPickerView()
            picker?.frame = CGRect.init(x: 0.0, y: self.view.frame.size.height - Constants.UIElements.pickerHeight, width: self.view.frame.size.width, height: Constants.UIElements.pickerHeight)
            picker?.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().bgColor ?? "")
            picker?.setValue(UIColor.black, forKey: "textColor")
            picker?.autoresizingMask = .flexibleWidth
            picker?.contentMode = .center
            
            picker?.delegate = self
            picker?.dataSource = self
            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: self.view.frame.size.height - Constants.UIElements.pickerHeight, width: self.view.frame.size.width, height: Constants.UIElements.pickerToolbarHeight))
            toolBar.barStyle = .default
            let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

            toolBar.items = [flexButton, UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        }
        
        showPicker()
    }
    
    func showPicker(){
        view.addSubview(self.picker!)
        view.addSubview(self.toolBar)
    }
    
    func hidePicker(){
        toolBar.removeFromSuperview()
        picker?.removeFromSuperview()
    }
    
    @objc func onDoneButtonTapped() {
        hidePicker()
    }
}

//An Extension for all the SideMenu Stuff
extension SettingsVC : SideMenuNavigationControllerDelegate {

    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
    }

    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
    }

    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        switch CustomTabBarController.indexToOpen {
            
        case Enums.TabBarSections.Home.rawValue:
            self.tabBarController?.selectedIndex = Enums.TabBarSections.Home.rawValue
            break

        case Enums.TabBarSections.Settings.rawValue:
            self.tabBarController?.selectedIndex = Enums.TabBarSections.Settings.rawValue
            break

        case Enums.TabBarSections.Wallets.rawValue:
            self.tabBarController?.selectedIndex = Enums.TabBarSections.Wallets.rawValue
            break

        case Enums.TabBarSections.Notifications.rawValue:
            self.tabBarController?.selectedIndex = Enums.TabBarSections.Notifications.rawValue
            break

        case Enums.TabBarSections.Profile.rawValue:
            self.tabBarController?.selectedIndex = Enums.TabBarSections.Profile.rawValue
            break

        case Enums.TabBarSections.Logout.rawValue:
            self.parent?.navigationController?.popToRootViewController(animated: true)
            break

        default:
            break
        }
    }

    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
    }
}
