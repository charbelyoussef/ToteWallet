//
//  RegisterVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import SideMenu

class WalletsVC : UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Class Outlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var lblBalanceTitle: UILabel!
    @IBOutlet weak var lblBalanceValue: UILabel!

    @IBOutlet weak var tvContent: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    // MARK: Class Variables
    var rowHeight:CGFloat = 120
    var wallets:[Wallet]?
    var selectedWallet:Wallet?
    
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
        showProgressBar()
        User.shared.getWallets(delegate: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK : TableView Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WalletsVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "WalletsVCDefaultCell", for: indexPath) as! WalletsVCDefaultCell

        cell.configureCell(wallet: wallets?[indexPath.row])
        cell.btnTransactions.addTarget(self, action:#selector(goToTransactionsAction), for: .touchUpInside)
        cell.btnLimits.tag = indexPath.row
        cell.btnLimits.addTarget(self, action:#selector(goToLimitsAction(sender:)), for: .touchUpInside)

        return cell
    }
    
    // MARK: Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "walletsToLimits" {
            if let vc = segue.destination as? LimitsVC {
                vc.wallet = selectedWallet
            }
        }
    }
    
    // MARK: Custom Methods

    func initViews(){
        self.tabBarController?.tabBar.isHidden = false
        lblBalanceTitle.text = "TOTAL BALANCE:"
        lblBalanceValue.text = "\(CoreDataService.getWallets().first?.roundedBalance ?? 0)"
        ConfigurationManager.setPrimaryLighterThemeBGColorAsTextForObjects(objects: [lblBalanceTitle, lblBalanceValue])
    }
    
    @objc func goToTransactionsAction(){
        performSegueIfPossible(identifier: "walletsToTransactions")
    }
    
    @objc func goToLimitsAction(sender: UIButton!){
        selectedWallet = wallets?[sender.tag]
        performSegueIfPossible(identifier: "walletsToLimits")
    }
    
    // MARK: Button Handlers
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        revealMenu()
        CustomTabBarController.indexToOpen = Enums.TabBarSections.Wallets.rawValue
    }
}

//An Extension for all the SideMenu Stuff
extension WalletsVC : SideMenuNavigationControllerDelegate {

    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
    }

    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
    }

    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        switch CustomTabBarController.indexToOpen {
            
        case Enums.TabBarSections.Home.rawValue:
            self.tabBarController?.selectedIndex = Enums.TabBarSections.Home.rawValue

        case Enums.TabBarSections.Settings.rawValue:
            self.tabBarController?.selectedIndex = Enums.TabBarSections.Settings.rawValue

        case Enums.TabBarSections.Wallets.rawValue:
            self.tabBarController?.selectedIndex = Enums.TabBarSections.Wallets.rawValue
        
        case Enums.TabBarSections.Notifications.rawValue:
            self.tabBarController?.selectedIndex = Enums.TabBarSections.Notifications.rawValue

        case Enums.TabBarSections.Profile.rawValue:
            self.tabBarController?.selectedIndex = Enums.TabBarSections.Profile.rawValue
    
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

//An extension for Requests
extension WalletsVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        if status == .walletsFetchSucceeded {
            wallets = CoreDataService.getWallets()
            initViews()
            tvContent.reloadData()
            hideProgressBar()
        }
        else if status == .HTTPSuccess {
//            wallets = CoreDataService.getWallets()
//            tvContent.reloadData()
//            hideProgressBar()
        }
    }
    
    func hasFinishedLoadingDataWithError(error: Error?) {
        hideProgressBar()
        showAlertWithCompletion(message: "Failed To Get Wallets", okTitle: "Retry", cancelTitle: "Cancel") {
            self.showProgressBar()
            User.shared.getWallets(delegate: self)
        }
    }
    
}
