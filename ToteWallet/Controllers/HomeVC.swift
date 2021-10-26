//
//  RegisterVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import SideMenu

class HomeVC : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UITabBarControllerDelegate {
 
    // MARK: Class Outlets
    @IBOutlet weak var lblBalanceTitle: UILabel!
    @IBOutlet weak var lblBalanceValue: UILabel!
    @IBOutlet weak var cvContent: UICollectionView!
    
    // MARK: Class Variables
    public enum CVSections:Int {
        case BuyTips
        case Marketplace
        case RequestTips
        case SendTips
        case Join
        case GetGrowGain
        case Count
    }
    
    var rowHeight:CGFloat = 100
    var contentArray = NSMutableArray()
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = CoreDataService.getLogin(), let country = DataHelper.getcountry(for: "\(user.countryCode)"), let phoneNumber = user.tel {
            UserDefaults.standard.set("\(country.id)", forKey: "lastLoggedInlastCountryId")
            UserDefaults.standard.set("\(phoneNumber)", forKey: "lastLoggedInlastPhoneNumber")
        }
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        registerForKeyboardNotifications()
        setupDismissOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadConvenientView()
        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerToRegistrationSuccessful" {
//            let vc = segue.destination as? UIViewController
//            if vc != nil{
////                if let indexPath = tvContent.indexPathForSelectedRow{
////                    // set presented view controller data
////                }
//            }
        }
    }
    // MARK: UICollectionView Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
//        let heightPerItem = widthPerItem
        
        if Enums.DeviceType.IS_IPHONE_5{
            rowHeight = 90
        }
        else if Enums.DeviceType.IS_IPHONE_6 {
            rowHeight = 90
        }
        else if Enums.DeviceType.IS_IPHONE_7 {
            rowHeight = 90
        }
        else if Enums.DeviceType.IS_IPHONE_8 {
            rowHeight = 90
        }
        else{
            rowHeight = 125
        }
        
        return CGSize(width:widthPerItem, height:rowHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CVSections.Count.rawValue
    }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeVCMenuCell", for: indexPath as IndexPath) as! HomeVCMenuCell
        
        cell.configureCell(index: indexPath.item)
        return cell
     }
     
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case CVSections.BuyTips.rawValue:
            performSegueIfPossible(identifier: "homeToBuyTips")
            
            
        case CVSections.Marketplace.rawValue:
            performSegueIfPossible(identifier: "homeToMarketplace")
            
        case CVSections.RequestTips.rawValue:
            performSegueIfPossible(identifier: "homeToRequestTips")
        
        case CVSections.SendTips.rawValue:
            performSegueIfPossible(identifier: "homeToSendTips")
        
        case CVSections.Join.rawValue:
            performSegueIfPossible(identifier: "homeToMembership")
            break
//            sideMenuController?.setContentViewController(storyboardIdentifier: "")
//            performSegueIfPossible(identifier: "homeToJoin")
        
        case CVSections.GetGrowGain.rawValue:
            performSegueIfPossible(identifier: "homeToPrograms")
//            sideMenuController?.setContentViewController(storyboardIdentifier: "")
//            performSegueIfPossible(identifier: "homeToGetGrowGrain")
            
        default:
            break
        }
    }
    
    // MARK : Custom Methods
    func initMenuPreference(){
//        SideMenuController.preferences.basic.menuWidth = 400 //self.view.frame.size.width
////        SideMenuController.preferences.basic.statusBarBehavior = .hideOnMenu
////        SideMenuController.preferences.basic.
//        SideMenuController.preferences.basic.position = .under
//        SideMenuController.preferences.basic.direction = .right
//        SideMenuController.preferences.basic.enablePanGesture = false
//        SideMenuController.preferences.basic.supportedOrientations = .portrait
//        SideMenuController.preferences.basic.shouldRespectLanguageDirection = true
    }
    
    func initViews(){
        self.tabBarController?.tabBar.isHidden = false

        lblBalanceTitle.text = "TOTAL BALANCE:"
        lblBalanceValue.text = "\(CoreDataService.getWallets().first?.roundedBalance ?? 0)"
        ConfigurationManager.setPrimaryLighterThemeBGColorAsTextForObjects(objects: [lblBalanceTitle, lblBalanceValue])
    }
    
    func loadConvenientView(){
        switch CustomTabBarController.indexToOpen {
            
        case Enums.TabBarSections.Home.rawValue:
            CustomTabBarController.indexToOpen = Enums.TabBarSections.Home.rawValue

            switch CustomTabBarController.subIndexToOpen {
            
            case Enums.HomeSubSection.Home.rawValue:
                break

            case Enums.HomeSubSection.BuyTips.rawValue:
                CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.Home.rawValue
                performSegueIfPossible(identifier: "homeToBuyTips")
                break
                
            case Enums.HomeSubSection.Marketplace.rawValue:
                CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.Home.rawValue
                performSegueIfPossible(identifier: "homeToMarketplace")
                break
                
            case Enums.HomeSubSection.RequestTips.rawValue:
                CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.Home.rawValue
                performSegueIfPossible(identifier: "homeToRequestTips")
                break

            case Enums.HomeSubSection.SendTips.rawValue:
                CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.Home.rawValue
                performSegueIfPossible(identifier: "homeToSendTips")
                break

            case Enums.HomeSubSection.Membership.rawValue:
                CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.Home.rawValue
                performSegueIfPossible(identifier: "homeToMembership")
                break

            default:
                break
            }

            
        case Enums.TabBarSections.Settings.rawValue:
            break

        case Enums.TabBarSections.Wallets.rawValue:
            break

        case Enums.TabBarSections.Notifications.rawValue:
            break

        case Enums.TabBarSections.Profile.rawValue:
            break

        default:
            break
        }
    }
    
    @objc func registerAction(){
        performSegueIfPossible(identifier: "registerToRegistrationSuccessful")
    }
    
    // MARK: Button Handlers
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        revealMenu()
        CustomTabBarController.indexToOpen = Enums.TabBarSections.Home.rawValue
    }
}

//An Extension for all the SideMenu Stuff
extension HomeVC : SideMenuNavigationControllerDelegate {

    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
    }

    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
    }

    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        switch CustomTabBarController.indexToOpen {
            
        case Enums.TabBarSections.Home.rawValue:
            self.tabBarController?.selectedIndex = Enums.TabBarSections.Home.rawValue
            if CoreDataService.getLogin() == nil {
                self.navigationController?.popToRootViewController(animated: true)
            }

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
        switch CustomTabBarController.indexToOpen {
            
        case Enums.TabBarSections.Home.rawValue:
            CustomTabBarController.indexToOpen = Enums.TabBarSections.Home.rawValue

            switch CustomTabBarController.subIndexToOpen {
            
            case Enums.HomeSubSection.Home.rawValue:
                break

            case Enums.HomeSubSection.BuyTips.rawValue:
                CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.Home.rawValue
                performSegueIfPossible(identifier: "homeToBuyTips")
                break
                
            case Enums.HomeSubSection.Marketplace.rawValue:
                CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.Home.rawValue
                performSegueIfPossible(identifier: "homeToMarketplace")
                break
                
            case Enums.HomeSubSection.RequestTips.rawValue:
                CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.Home.rawValue
                performSegueIfPossible(identifier: "homeToRequestTips")
                break

            case Enums.HomeSubSection.SendTips.rawValue:
                CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.Home.rawValue
                performSegueIfPossible(identifier: "homeToSendTips")
                break

            case Enums.HomeSubSection.Membership.rawValue:
                CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.Home.rawValue
                performSegueIfPossible(identifier: "homeToMembership")
                break

            default:
                break
            }

            
        case Enums.TabBarSections.Settings.rawValue:
            break

        case Enums.TabBarSections.Wallets.rawValue:
            break

        case Enums.TabBarSections.Notifications.rawValue:
            break

        case Enums.TabBarSections.Profile.rawValue:
            break

        default:
            break
        }
    }
}
