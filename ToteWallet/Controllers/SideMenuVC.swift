//
//  SideMenuVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/2/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuVC : UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    // MARK: Class Outlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tvContent: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lblFullname: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var vProfileInfoContainer: UIView!
    @IBOutlet weak var vGetGrowGrain: UIView!
    @IBOutlet weak var lblGetGrowGrain: UILabel!
    
    // MARK: Class Variables
    fileprivate enum TVSections:Int {
        case Home
        case Tips
        case Wallets
        case Membership
        case PendingRequests
        case ReferToAFriend
        case Notifications
        case Settings
        case Faq
        case ContactUs
        case Logout
    }
    
    enum TVTipsRows:Int {
        case BuyTips
        case RequestTips
        case SendTips
        case Marketplace
    }
    
    var rowHeight:CGFloat = 40
    var headerHeight:CGFloat = 40
    
    let cellId = "cell"
    var contentArray = NSMutableArray()
    var user:Login?
    
    var twoDimensionalArray = [
        Structs.ExpandableSectionHeader(name: "Home",
                                        iconName: "menu-home",
                                        expandableNames: Structs.ExpandableNames(isExpanded: true, names: [], iconNames: [""])),
        
        Structs.ExpandableSectionHeader(name: "Tote Incintive Points(TIPS)",
                                        iconName: "menu-tips",
                                        expandableNames: Structs.ExpandableNames(isExpanded: true, names: ["Buy Tips", "Request Tips", "Send Tips", "Marketplace"],
                                                                                 iconNames: ["menu-buyTips", "menu-requestTips", "menu-sendTips", "menu-marketplace"])),
        Structs.ExpandableSectionHeader(name: "Wallets",
                                        iconName: "menu-wallet",
//                                        iconName: "menu-briefcase",
                                        expandableNames: Structs.ExpandableNames(isExpanded: true, names: [], iconNames: [""])),
        
        Structs.ExpandableSectionHeader(name: "Membership",
                                        iconName: "menu-membership",
                                        expandableNames: Structs.ExpandableNames(isExpanded: true, names: [], iconNames: [""])),
        
        Structs.ExpandableSectionHeader(name: "Pending Requests",
                                        iconName: "menu-pendingrequests",
                                        expandableNames: Structs.ExpandableNames(isExpanded: true, names: [], iconNames: [""])),

        Structs.ExpandableSectionHeader(name: "My Assets(Refer To A Friend)",
                                        iconName: "menu-briefcase",
                                        expandableNames: Structs.ExpandableNames(isExpanded: true, names: [], iconNames: [""])),
        
        Structs.ExpandableSectionHeader(name: "Notifications",
                                        iconName: "menu-notifications",
                                        expandableNames: Structs.ExpandableNames(isExpanded: true, names: [], iconNames: [""])),

        Structs.ExpandableSectionHeader(name: "Settings",
                                        iconName: "menu-settings",
                                        expandableNames: Structs.ExpandableNames(isExpanded: true, names: [], iconNames: [""])),
        
        Structs.ExpandableSectionHeader(name: "FAQ",
                                        iconName: "menu-faq",
                                        expandableNames: Structs.ExpandableNames(isExpanded: true, names: [], iconNames: [""])),

        Structs.ExpandableSectionHeader(name: "Contact Us",
                                        iconName: "menu-contactus",
                                        expandableNames: Structs.ExpandableNames(isExpanded: true, names: [], iconNames: [""])),

        Structs.ExpandableSectionHeader(name: "Logout",
                                        iconName: "menu-logout",
                                        expandableNames: Structs.ExpandableNames(isExpanded: true, names: [], iconNames: [""])),
    ]
    

    
    var showIndexPaths = false
    
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tvContent.customRegisterForCell(identifiers: ["SideMenuVCDefaultCell"])
        
        let tapGetGrowGrain = UITapGestureRecognizer(target: self, action: #selector(self.openGetGrowGrain(_:)))
        vGetGrowGrain.addGestureRecognizer(tapGetGrowGrain)

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.openProfile(_:)))
        vProfileInfoContainer.addGestureRecognizer(tap)

        let headerNib = UINib.init(nibName: "SideMenuHeader", bundle: Bundle.main)
        tvContent.register(headerNib, forHeaderFooterViewReuseIdentifier: "SideMenuHeader")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user = CoreDataService.getLogin()
        
        if user != nil {
            lblFullname.text = "\(user?.fullName ?? "N/A")"
            lblEmail.text = user?.email

            ivProfile.layer.cornerRadius = ivProfile.frame.width/2
            ivProfile.layer.borderWidth =  2.0
            ivProfile.layer.borderColor = UIColor.white.cgColor
            
            if let imageUrl = user?.imageUrl {
                ivProfile.sd_setImage(with: URL(string: imageUrl.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "user"))
            }
            else {
                ivProfile.image = UIImage(named: "user")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK : TableView Methods
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case TVSections.Home.rawValue:
            return initMenuSectionHeader(section: section)

        case TVSections.Tips.rawValue:
            return initMenuSectionHeader(section: section)

        case TVSections.Wallets.rawValue:
            return initMenuSectionHeader(section: section)

        case TVSections.Membership.rawValue:
            return initMenuSectionHeader(section: section)
            
        case TVSections.PendingRequests.rawValue:
            return initMenuSectionHeader(section: section)

        case TVSections.ReferToAFriend.rawValue:
            return initMenuSectionHeader(section: section)

        case TVSections.Notifications.rawValue:
            return initMenuSectionHeader(section: section)

        case TVSections.Settings.rawValue:
            return initMenuSectionHeader(section: section)

        case TVSections.Faq.rawValue:
            return initMenuSectionHeader(section: section)

        case TVSections.ContactUs.rawValue:
            return initMenuSectionHeader(section: section)

        case TVSections.Logout.rawValue:
            return initMenuSectionHeader(section: section)

        default:
             return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimensionalArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !twoDimensionalArray[section].expandableNames.isExpanded {
            return 0
        }
        
        return twoDimensionalArray[section].expandableNames.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SideMenuVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "SideMenuVCDefaultCell", for: indexPath) as! SideMenuVCDefaultCell

        let imageName = twoDimensionalArray[indexPath.section].expandableNames.iconNames[indexPath.row]
        cell.ivIcon.image = UIImage(named: imageName)?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 10))

        cell.lblTitle.text = twoDimensionalArray[indexPath.section].expandableNames.names[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
                    
            case TVSections.Home.rawValue:
                //Handled in Header View Action
                break
            
            case TVSections.Tips.rawValue:
                let row = indexPath.row
                switch row {
                    case TVTipsRows.BuyTips.rawValue:
                        CustomTabBarController.indexToOpen = Enums.TabBarSections.Home.rawValue
                        CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.BuyTips.rawValue
                        dismiss(animated: true, completion: nil)
//                        performSegueIfPossible(identifier: "sideMenuToBuyTips")
                        break
                    
                    case TVTipsRows.RequestTips.rawValue:
                        CustomTabBarController.indexToOpen = Enums.TabBarSections.Home.rawValue
                        CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.RequestTips.rawValue
                        dismiss(animated: true, completion: nil)

//                        performSegueIfPossible(identifier: "sideMenuToRequestTips")
                        break

                    case TVTipsRows.SendTips.rawValue:
                        CustomTabBarController.indexToOpen = Enums.TabBarSections.Home.rawValue
                        CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.SendTips.rawValue
                        dismiss(animated: true, completion: nil)

//                        performSegueIfPossible(identifier: "sideMenuToSendTips")
                        break

                    case TVTipsRows.Marketplace.rawValue:
                        CustomTabBarController.indexToOpen = Enums.TabBarSections.Home.rawValue
                        CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.Marketplace.rawValue
                        dismiss(animated: true, completion: nil)

//                        performSegueIfPossible(identifier: "sideMenuToMarketplace")
                        break

                    default:
                        break
                }
                break
            
            case TVSections.Wallets.rawValue:
            //Handled in Header View Action
                break
            
            case TVSections.Membership.rawValue:
            //Handled in Header View Action
                break
            
            case TVSections.ReferToAFriend.rawValue:
            //Handled in Header View Action
                break
            
            case TVSections.Settings.rawValue:
            //Handled in Header View Action
                break
                
            default:
                break
        }
    }
    // MARK : Custom Methods
    
    @objc func openProfile(_ sender: UITapGestureRecognizer? = nil) {
        CustomTabBarController.indexToOpen = Enums.TabBarSections.Profile.rawValue
        dismiss(animated: true, completion: nil)
    }
    
    @objc func openGetGrowGrain(_ sender: UITapGestureRecognizer? = nil) {
        CustomTabBarController.indexToOpen = Enums.TabBarSections.Home.rawValue
        CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.GetGrowGrain.rawValue
        dismiss(animated: true, completion: nil)
//        performSegueIfPossible(identifier: "sideMenuToGetGrowGrain")
    }
    
    func initMenuSectionHeader(section:Int) -> UIView{
        
        let headerView = tvContent.dequeueReusableHeaderFooterView(withIdentifier: "SideMenuHeader") as! SideMenuHeader
//        headerView.tintColor = .white
        
        headerView.ivIcon.image = UIImage(named: twoDimensionalArray[section].iconName)
        headerView.ivIcon.tintColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimaryLighter ?? "")

        headerView.btnAction.setTitle(twoDimensionalArray[section].name, for: .normal)
        headerView.btnAction.setTitleColor(.black, for: .normal)
        headerView.btnAction.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        headerView.btnAction.backgroundColor = .white
        headerView.btnAction.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        headerView.btnAction.contentHorizontalAlignment = .left
        headerView.btnAction.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        
        headerView.btnAction.tag = section
        
        return headerView
    }
    
    func logoutFunction() {
        if let country = DataHelper.getcountry(for: "\(user?.countryCode ?? -1)"), let phoneNumber = self.user?.tel {
            UserDefaults.standard.set("\(country.id)", forKey: "lastLoggedInlastCountryId")
            UserDefaults.standard.set("\(phoneNumber)", forKey: "lastLoggedInlastPhoneNumber")
        }
        CoreDataService.clearAll()
    }
    
    @objc func handleExpandClose(button: UIButton) {
        let section = button.tag
        switch section {
            
            case TVSections.Home.rawValue:
                CustomTabBarController.indexToOpen = Enums.TabBarSections.Home.rawValue
                CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.Home.rawValue
                dismiss(animated: true, completion: nil)
                break
            
            case TVSections.Tips.rawValue:
                // we'll try to close the section first by deleting the rows
                var indexPaths = [IndexPath]()
                for row in twoDimensionalArray[section].expandableNames.names.indices {
                    let indexPath = IndexPath(row: row, section: section)
                    indexPaths.append(indexPath)
                }
                
                let isExpanded = twoDimensionalArray[section].expandableNames.isExpanded
                twoDimensionalArray[section].expandableNames.isExpanded = !isExpanded
                
                if isExpanded {
                    tvContent.deleteRows(at: indexPaths, with: .fade)
                } else {
                    tvContent.insertRows(at: indexPaths, with: .fade)
                }
                break
            
            case TVSections.Wallets.rawValue:
                CustomTabBarController.indexToOpen = Enums.TabBarSections.Wallets.rawValue
                dismiss(animated: true, completion: nil)
//                performSegueIfPossible(identifier: "sideMenuToWallets")
                break
            
            case TVSections.Membership.rawValue:
                CustomTabBarController.indexToOpen = Enums.TabBarSections.Home.rawValue
                CustomTabBarController.subIndexToOpen = Enums.HomeSubSection.Membership.rawValue
                dismiss(animated: true, completion: nil)
//                performSegueIfPossible(identifier: "sideMenuToMembership")
                break
            
            case TVSections.PendingRequests.rawValue:
                performSegueIfPossible(identifier: "sideMenuToPendingRequests")
                break

            case TVSections.ReferToAFriend.rawValue:
                performSegueIfPossible(identifier: "sideMenuToReferToAFriend")
                break
            
            case TVSections.Notifications.rawValue:
                CustomTabBarController.indexToOpen = Enums.TabBarSections.Notifications.rawValue
                dismiss(animated: true, completion: nil)
                break

            case TVSections.Settings.rawValue:
                CustomTabBarController.indexToOpen = Enums.TabBarSections.Settings.rawValue
                dismiss(animated: true, completion: nil)
    //                performSegueIfPossible(identifier: "sideMenuToSettings")
                break
            
            case TVSections.Faq.rawValue:
                performSegueIfPossible(identifier: "sideMenuToFaq")
                break
            
            case TVSections.ContactUs.rawValue:
                performSegueIfPossible(identifier: "sideMenuToContactUs")
                break

            case TVSections.Logout.rawValue:
                logoutFunction()
                CustomTabBarController.indexToOpen = Enums.TabBarSections.Logout.rawValue
                dismiss(animated: true, completion: nil)
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
//                if let indexPath = tvContent.indexPathForSelectedRow{
//                    // set presented view controller data
//                }
//            }
        }
    }
    
    // MARK: Button Handlers
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
