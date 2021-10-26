//
//  ViewController.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import SideMenu

class ProfileVC: UIViewController {

    // MARK: Class Outlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tvContent: UITableView!
    @IBOutlet weak var lblBalanceTitle: UILabel!
    @IBOutlet weak var lblBalanceValue: UILabel!

    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMembershipType: UILabel!
    
    // MARK: Class Variables
    var contentArray = NSMutableArray()
    var user:Login?
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        initViews()
        user = CoreDataService.getLogin()
        
        if user != nil{
            lblFullName.text = "\(user?.fullName ?? "N/A")"
            lblEmail.text = "\(user?.email ?? "N/A")"
            lblMembershipType.text = "\(user?.membershipType ?? "N/A")"
            
            ivProfile.layer.cornerRadius = ivProfile.frame.width/2
//            ivProfile.layer.borderWidth =  2.0
//            ivProfile.layer.borderColor = UIColor.white.cgColor

            if let imageUrl = user?.imageUrl {
                ivProfile.sd_setImage(with: URL(string: imageUrl.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "user"))
            }
            else {
                ivProfile.image = UIImage(named: "user")
            }
        }
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
    
    // MARK: Custom Methods
    func initViews() {
        self.tabBarController?.tabBar.isHidden = false
        lblBalanceTitle.text = "TOTAL BALANCE:"
        lblBalanceValue.text = "\(CoreDataService.getWallets().first?.roundedBalance ?? 0)"
        ConfigurationManager.setPrimaryLighterThemeBGColorAsTextForObjects(objects: [lblBalanceTitle, lblBalanceValue])
    }
    
    // MARK: Button Handlers
    @IBAction func btnProfileAction(_ sender: Any) {
        performSegueIfPossible(identifier: "profileToEditProfile")
    }
    
    @IBAction func btnSettingsAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = Enums.TabBarSections.Settings.rawValue
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        revealMenu()
//        CustomTabBarController.indexToOpen = Enums.TabBarSections.Profile.rawValue
    }
}

//An Extension for all the SideMenu Stuff
extension ProfileVC : SideMenuNavigationControllerDelegate {

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
