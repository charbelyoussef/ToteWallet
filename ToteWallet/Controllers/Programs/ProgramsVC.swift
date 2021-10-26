//
//  RegisterVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import WebKit

class ProgramsVC : UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Class Outlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tvContent: UITableView!
    
    // MARK: Class Variables
    var rowHeight:CGFloat = 440
    var contentArray:[Program]?
    
    var selectedProgram:Program?
    var selectedRowIndex = -1

    var isFlipped = false

    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        showProgressBar()
        User.shared.getProgramsList(delegate: self)
        tvContent.layer.cornerRadius = 10
        tvContent.clipsToBounds = true
        tvContent.customRegisterForCell(identifiers: ["ProgramsVCDefaultCell"])

        registerForKeyboardNotifications()
        setupDismissOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let cell:ProgramsVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "ProgramsVCDefaultCell", for: indexPath) as! ProgramsVCDefaultCell

        cell.configureCell(indexPath:indexPath, programObject: contentArray?[indexPath.row])
        cell.btnBuyAsset.tag = indexPath.row
        
//        let tapGetGrowGrainTop = CustomUITapGestureRecognizer(target: self, action: #selector(self.flipCardAction(_:)))
//        tapGetGrowGrainTop.tag = indexPath.row
//        cell.vTopLayer.addGestureRecognizer(tapGetGrowGrainTop)
//
//        let tapGetGrowGrainBottom = CustomUITapGestureRecognizer(target: self, action: #selector(self.flipCardAction(_:)))
//        tapGetGrowGrainBottom.tag = indexPath.row
//        cell.vBottomLayer.addGestureRecognizer(tapGetGrowGrainBottom)

        
        cell.btnBuyAsset.addTarget(self, action:#selector(btnBuyAssetAction(sender:)), for: .touchUpInside)

        cell.btnMoreDetails.tag = indexPath.row
        cell.btnMoreDetails.addTarget(self, action:#selector(btnMoreDetailsAction(sender:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegueIfPossible(identifier: "programsToDetails")
    }

    // MARK: Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "programsToDetails" {
            let vc = segue.destination as? ProgramsDetailsVC
            if vc != nil{
                if selectedRowIndex != -1 {
                    if let detailsUrl = contentArray?[selectedRowIndex].detailsUrl {
                        vc?.url = detailsUrl
                    }
                    else{
                        showAlertWithCompletion(message: "Details url not available", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
                    }
                }
            }
        }
        else if segue.identifier == "programsToPurchase" {
            let vc = segue.destination as? ProgramRegistrationVC
            if vc != nil{
                vc?.program = selectedProgram
            }
        }
    }
    
    // MARK: Custom Methods
    @objc func flipCardAction(_ sender: CustomUITapGestureRecognizer) {
        let tag = sender.tag
        if tag != -1 {
            if let cell = tvContent.cellForRow(at: IndexPath(row: tag, section: 0)) as? ProgramsVCDefaultCell{
                guard let displayView = isFlipped ? cell.vBottomLayer : cell.vTopLayer else { return }
        
                UIView.transition(with: cell.contentView, duration: 2.0,
                                  options: isFlipped ? .transitionFlipFromRight : .transitionFlipFromLeft,
                                  animations: { () -> Void in
                                    //5
                                    cell.contentView.insertSubview(displayView, at: 0)
                                  }, completion: { (completed) in
        
                })

                isFlipped = !isFlipped
            }
        }
    }
    
    @objc func btnMoreDetailsAction(sender: UIButton!){
        selectedRowIndex = sender.tag
        performSegueIfPossible(identifier: "programsToDetails")
    }

    @objc func btnBuyAssetAction(sender: UIButton!){
        if let selectedProgramTemp = contentArray?[sender.tag] {
            selectedProgram = selectedProgramTemp
            performSegueIfPossible(identifier: "programsToPurchase")
        }
        else{
            showAlertWithCompletion(message: "Program Id not avaiable", okTitle: "Ok", cancelTitle: "", completionBlock: nil)
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

//An extension for Requests
extension ProgramsVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        hideProgressBar()

        if status == .HTTPSuccess {
            contentArray = CoreDataService.getPrograms()
            tvContent.reloadData()
        }
        if status == .didNotLoadRemoteData {
            showAlertWithCompletion(message: message, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
    }
    
    func hasFinishedLoadingDataWithError(error: Error?) {
        hideProgressBar()
    }
}

class CustomUITapGestureRecognizer: UITapGestureRecognizer {
    var tag = -1
}
