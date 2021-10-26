//
//  RegisterVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class MyProgramsVC : UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate {
    // MARK: Class Outlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tvContent: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var cstrHeaderLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var lblAlert: UILabel!
    
    // MARK: Class Variables
    
    fileprivate enum ProgramStatus:String {
        case Pending = "Pending"
        case Accepted = "Accepted"
        case Rejected = "Rejected"
        case Default = ""
    }

    
    var rowHeight:CGFloat = 120
    var contentArray:[MyProgram]?
    var selectedUrl:String?

    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgressBar()
        User.shared.getMyProgramsList(delegate: self)
        registerForKeyboardNotifications()
        setupDismissOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK : TableView Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray?.count ?? 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyProgramsVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "MyProgramsVCDefaultCell", for: indexPath) as! MyProgramsVCDefaultCell

        cell.configureCell(program: contentArray?[indexPath.row])
        
        cell.btnDetails.tag = indexPath.row
        cell.btnDetails.addTarget(self, action:#selector(goToDetailsScreen(sender:)), for: .touchUpInside)
//        cell.btnRefer.addTarget(self, action:#selector(copyLinkToCLipboard(sender:)), for: .touchUpInside)
        
        cell.btnRefer.tag = indexPath.row
        cell.btnRefer.addTarget(self, action:#selector(openShareOptions(sender:)), for: .touchUpInside)
        
        if let program = contentArray?[indexPath.row], program.isSellable {
            cell.btnSell.isHidden = false
            cell.btnSell.addTarget(self, action:#selector(sellAction(sender:)), for: .touchUpInside)

            switch program.status {
            case ProgramStatus.Pending.rawValue:
                cell.btnSell.isUserInteractionEnabled = false
                ConfigurationManager.setSecondaryExtraLightThemeBGColorForViews(views: [cell.btnSell])
                break

            case ProgramStatus.Accepted.rawValue:
                cell.btnSell.isUserInteractionEnabled = false
                ConfigurationManager.setSecondaryExtraLightThemeBGColorForViews(views: [cell.btnSell])
                break

            case ProgramStatus.Rejected.rawValue:
                break

            default:
                cell.btnSell.isHidden = false
                cell.btnSell.tag = indexPath.row
                break
            }
        }
        else{
            cell.btnSell.isHidden = true
        }

        return cell
    }
    
    // MARK : Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myProgramsToDetails" {
            if let vc = segue.destination as? MyProgramDetailsVC {
                vc.url = selectedUrl
            }
        }
    }
    
    // MARK: Custom Methods

    func initViews(){
        lblAlert.layer.cornerRadius = 5
        lblAlert.layer.masksToBounds = true
    }
    
    @objc func goToDetailsScreen(sender: UIButton!){
//        referralLink: "https://totewallet.com/platform/invest/414/show",
//        detailsUrl: "https://totewallet.com/platform/invest/414/show"),

        if let program = contentArray?[sender.tag], let url = program.urlDetails{
            selectedUrl = url
        }
        performSegueIfPossible(identifier: "myProgramsToDetails")
    }

    @objc func copyLinkToCLipboard(sender: UIButton!){
        if let program = contentArray?[sender.tag], let urlReferral = program.urlReferral {
            UIPasteboard.general.string = urlReferral
        }
        UIView.transition(with: lblAlert, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.lblAlert.isHidden = false
            self.cstrHeaderLabelHeight.constant = 35
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.lblAlert.isHidden = true
            self.cstrHeaderLabelHeight.constant = 0
        }
    }
    
    @objc func openShareOptions(sender: UIButton!){
        if let program = contentArray?[sender.tag], let urlReferral = program.urlReferral {
            let items = [URL(string: urlReferral)!]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(ac, animated: true)
        }
        else{
            showAlertWithCompletion(message: "Program url not available!", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
    }
    
    @objc func sellAction(sender: UIButton!){
        if let program = contentArray?[sender.tag] {
            self.showAlertWithCompletion(message: "Are you sure you want to sell?", okTitle: "Ok", cancelTitle: "Cancel") {
                self.showProgressBar()
                User.shared.sellProgram(delegate: self, programId: "\(program.myProgramId)")
            }
        }
        else{
            showAlertWithCompletion(message: Constants.Errors.GENERAL_ERROR, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
    }
    
    // MARK: Button Handlers
    @IBAction func btnMenuAction(_ sender: Any) {
        revealMenu()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//An extension for Requests
extension MyProgramsVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        hideProgressBar()

        if status == .HTTPSuccess {
            contentArray = CoreDataService.getMyPrograms()
            tvContent.reloadData()
        }
        
        if status == .programSellRequestSucceeded {
            showProgressBar()
            User.shared.getMyProgramsList(delegate: self)
//            showAlertWithCompletion(message: message, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }

        if status == .didNotLoadRemoteData {
            showAlertWithCompletion(message: message, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
    }
    
    func hasFinishedLoadingDataWithError(error: Error?) {
        hideProgressBar()
        showAlertWithCompletion(message: Constants.Errors.GENERAL_ERROR, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
    }
}
