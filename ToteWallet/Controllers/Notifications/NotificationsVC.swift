//
//  NotificationsVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import SideMenu

class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var tvNotifications: UITableView!
    @IBOutlet weak var lblBalanceTitle: UILabel!
    @IBOutlet weak var lblBalanceValue: UILabel!

    // MARK: Class Variables
    
    var defaultDescriptionLines = 1
    var notifications = [Alert]()

    // MARK: Class Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgressBar()
        User.shared.getAlerts(delegate: self)
        tvNotifications.customRegisterForCell(identifiers: ["NotificationsVCContentCell"])
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        tvNotifications.reloadData()
    }
    
    // MARK: TableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:NotificationsVCContentCell = tableView.dequeueReusableCell(withIdentifier: "NotificationsVCContentCell", for: indexPath) as! NotificationsVCContentCell
        
        cell.lblTitle.text = notifications[indexPath.row].title
        cell.lblDescription.text = notifications[indexPath.row].message
        cell.vContainerView.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().bgColor ?? "")
        cell.maxDescriptionLines = cell.lblDescription.getActualLineNumber()

        cell.btnExpand.tag = indexPath.row
        cell.btnExpand.addTarget(self, action: #selector(expandDescription), for: .touchUpInside)
        cell.btnExpand.isHidden = cell.maxDescriptionLines <= defaultDescriptionLines

        if cell.maxDescriptionLines <= defaultDescriptionLines {
            cell.lblDescription.numberOfLines = cell.maxDescriptionLines
            cell.btnExpand.isHidden = true
//            cell.constBtnReadMoreHeight.constant = 0
        }
        else {
            cell.btnExpand.isHidden = false
            cell.constBtnReadMoreHeight.constant = 20
            cell.lblDescription.numberOfLines = cell.notificationsOpen ? cell.maxDescriptionLines : defaultDescriptionLines
        }
        
        cell.btnExpand.isHidden = true

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegueIfPossible(identifier: "notificationToNotificationDetails")
    }
    
    // MARK: Custom Methods
    func initViews(){
        self.tabBarController?.tabBar.isHidden = false
        tvNotifications.estimatedRowHeight = 140
        lblBalanceTitle.text = "TOTAL BALANCE:"
        lblBalanceValue.text = "\(CoreDataService.getWallets().first?.roundedBalance ?? 0)"
        ConfigurationManager.setPrimaryLighterThemeBGColorAsTextForObjects(objects: [lblBalanceTitle, lblBalanceValue])
    }
    
    @objc func expandDescription(sender: UIButton!) {
    
        let tag = sender.tag
        let indexPath = IndexPath(row: tag, section: 0)
        
        if let cell = tvNotifications.cellForRow(at: indexPath) as? NotificationsVCContentCell {
            cell.notificationsOpen = !cell.notificationsOpen
            
            cell.btnExpand.setTitle(cell.notificationsOpen ? "Read Less" : "Read More", for: .normal)
            cell.maxDescriptionLines = cell.lblDescription.getActualLineNumber()
            
            cell.editingAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 5))
            cell.editingAccessoryView?.backgroundColor = UIColor.green
        }
        self.tvNotifications.reloadData()
    }
    
    // MARK: UINavigation Controller Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "notificationToNotificationDetails" {
            let vc = segue.destination as? NotificationDetailsVC
            if vc != nil{
                if let indexPath = tvNotifications.indexPathForSelectedRow{
                    print(indexPath)
                    vc?.notificationDetails = notifications[indexPath.row]
                }
            }
        }
    }
    
    // MARK: Button Handlers
    @IBAction func btnMenuAction(_ sender: Any) {
        revealMenu()
        CustomTabBarController.indexToOpen = Enums.TabBarSections.Notifications.rawValue
    }
    
}

//An Extension for all the SideMenu Stuff
extension NotificationsVC : SideMenuNavigationControllerDelegate {

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
extension NotificationsVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        hideProgressBar()

        if status == .HTTPSuccess {
            notifications = CoreDataService.getAlerts()
            tvNotifications.reloadData()
        }
    }
    
    func hasFinishedLoadingDataWithError(error: Error?) {
        hideProgressBar()
        showAlertWithCompletion(message: "Failed To Get Notifications", okTitle: "Retry", cancelTitle: "Cancel") {
            self.showProgressBar()
            User.shared.getAlerts(delegate: self)
        }
    }
    
}
