//
//  SideMenuVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/2/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class LoyaltyProgramsVC : UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    // MARK: Class Outlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tvContent: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lblFullname: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    // MARK: Class Variables
    enum TVSections:Int {
        case Bronze
        case Silver
        case Gold
        case Platinum
        case Count
    }
    
    var user:Login?
    
    var selectedMembership:LoyaltyProgram?
    fileprivate var memberships = [LoyaltyProgram]()
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgressBar()
        User.shared.getLoyaltyPrograms(delegate: self)
        
        tvContent.rowHeight = UITableView.automaticDimension
        tvContent.estimatedRowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberships.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MembershipVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "MembershipVCDefaultCell", for: indexPath) as! MembershipVCDefaultCell
        
        let membership = memberships[indexPath.row]
        
        if let imageUrl = membership.imageFile {
            cell.ivMembershipIcon.sd_setImage(with: URL(string: ("\(Constants.urlPrefix)\(imageUrl)").safeURL()), completed: nil)
//            cell.btnMembership.sd_setBackgroundImage(with: URL(string: ("\(Constants.urlPrefix)\(imageUrl)").safeURL()), for: .normal, completed: nil)
        }
        else {
            cell.ivMembershipIcon.image = UIImage(named: ConfigurationManager.getAppConfiguration().defaultLogoImageName ?? "")
//            cell.btnMembership.setBackgroundImage(UIImage(named: ConfigurationManager.getAppConfiguration().defaultLogoImageName ?? ""), for: .normal)
        }
        
//        cell.btnMembership.setTitle(membership.name, for: .normal)
        cell.btnMembership.backgroundColor = UIColor(hexString: membership.colorHex ?? "787878")
        cell.btnMembership.tag = indexPath.row
        cell.btnMembership.addTarget(self, action:#selector(membershipButtonAction(sender:)), for: .touchUpInside)

        cell.lblDescription.text = membership.desc?.htmlToString

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    
    // MARK: Custom Methods
    @objc func membershipButtonAction(sender: UIButton!){
        selectedMembership = memberships[sender.tag]
        performSegueIfPossible(identifier: "membershipToPurchase")
    }

    // MARK : Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "membershipToPurchase" {
            if let vc = segue.destination as? LoyaltyRegistrationVC {
                vc.membershipObject = selectedMembership
            }
        }
    }
    
    // MARK: Button Handlers
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

//An extension for Requests
extension LoyaltyProgramsVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        hideProgressBar()

        if status == .HTTPSuccess {
            memberships = CoreDataService.getLoyaltyPrograms()
            tvContent.reloadData()
        }
        else if status == .didNotLoadRemoteData {
            showAlertWithCompletion(message: message, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
    }
    
    func hasFinishedLoadingDataWithError(error: Error?) {
        hideProgressBar()
    }
}
