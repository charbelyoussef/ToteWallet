//
//  NotificationsVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import SideMenu

class FaqVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var tvFaqs: UITableView!
    @IBOutlet weak var lblBalanceTitle: UILabel!
    @IBOutlet weak var lblBalanceValue: UILabel!

    // MARK: Class Variables
    var defaultDescriptionLines = 1
    
    var faqs = [Faq]()

    // MARK: Class Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgressBar()
        User.shared.getFaqs(delegate: self)
        tvFaqs.customRegisterForCell(identifiers: ["FaqVCContentCell"])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        tvFaqs.reloadData()
    }
    
    // MARK: TableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:FaqVCContentCell = tableView.dequeueReusableCell(withIdentifier: "FaqVCContentCell", for: indexPath) as! FaqVCContentCell
        
        cell.lblTitle.text = faqs[indexPath.row].question
        cell.lblDescription.text = faqs[indexPath.row].answer
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
            cell.lblDescription.numberOfLines = cell.faqOpen ? cell.maxDescriptionLines : defaultDescriptionLines
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegueIfPossible(identifier: "")
    }
    
    // MARK: Custom Methods
    func initViews(){
        tvFaqs.estimatedRowHeight = 140
        lblBalanceTitle.text = "TOTAL BALANCE:"
        lblBalanceValue.text = "\(CoreDataService.getWallets().first?.roundedBalance ?? 0)"
        ConfigurationManager.setPrimaryLighterThemeBGColorAsTextForObjects(objects: [lblBalanceTitle, lblBalanceValue])
    }
    
    @objc func expandDescription(sender: UIButton!) {
    
        let tag = sender.tag
        let indexPath = IndexPath(row: tag, section: 0)
        
        if let cell = tvFaqs.cellForRow(at: indexPath) as? FaqVCContentCell {
            cell.faqOpen = !cell.faqOpen
            
            cell.btnExpand.setTitle(cell.faqOpen ? "Read Less" : "Read More", for: .normal)
            cell.maxDescriptionLines = cell.lblDescription.getActualLineNumber()
            
            cell.editingAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 5))
            cell.editingAccessoryView?.backgroundColor = UIColor.green
        }
        self.tvFaqs.reloadData()
    }
    
    // MARK: UINavigation Controller Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "" {
        }
    }
    
    // MARK: Button Handlers
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnMenuAction(_ sender: Any) {
        revealMenu()
    }
}

//An extension for Requests
extension FaqVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        hideProgressBar()

        if status == .HTTPSuccess {
            faqs = CoreDataService.getFaqs()
            tvFaqs.reloadData()
        }
    }

    func hasFinishedLoadingDataWithError(error: Error?) {
        hideProgressBar()
        showAlertWithCompletion(message: "Failed To Get Faqs", okTitle: "Retry", cancelTitle: "Cancel") {
            self.showProgressBar()
            User.shared.getAlerts(delegate: self)
        }
    }

}
