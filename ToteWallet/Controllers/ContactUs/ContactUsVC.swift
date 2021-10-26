//
//  NotificationsVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import SideMenu
import MapKit
import MessageUI

class ContactUsVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var lblBalanceTitle: UILabel!
    @IBOutlet weak var lblBalanceValue: UILabel!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var mvLocation: MKMapView!
    
    // MARK: Class Variables
    
    // MARK: Class Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        showProgressBar()
//        User.shared.getAlerts(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    // MARK : MFMailComposeViewControllerDelegate Methods
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    // MARK: Custom Methods
    func initViews(){
        let initialLocation = CLLocation(latitude: -27.661697535508253, longitude: 30.316639604340487)
        mvLocation.centerToLocation(initialLocation)

//        lblBalanceTitle.text = "TOTAL BALANCE:"
//        lblBalanceValue.text = "\(CoreDataService.getWallets().first?.roundedBalance ?? 0)"
//        ConfigurationManager.setPrimaryLighterThemeBGColorAsTextForObjects(objects: [lblBalanceTitle, lblBalanceValue])
    }
    
    func sendEmail(email:String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setMessageBody("", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
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

    @IBAction func btnEmailAction(_ sender: Any) {
        let email = "asayde@hotmail.com"
        sendEmail(email: email)
//        openUrl(urlStr: networkUrl)
    }
    
    
    @IBAction func btnPhoneAction(_ sender: Any) {
        let phoneNumber = "+9613701709"
        if let tel = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(tel) {
             if #available(iOS 10.0, *) {
               UIApplication.shared.open(tel, options: [:], completionHandler: nil)
             } else {
               UIApplication.shared.openURL(tel)
             }
        }
    }
}

extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 2000) {
    
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

//An extension for Requests
//extension FaqVC : OBSRemoteDataDelegate {
//    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
//        hideProgressBar()
//
//        if status == .HTTPSuccess {
//            faqs = CoreDataService.getAlerts()
//            tvFaqs.reloadData()
//        }
//    }
//
//    func hasFinishedLoadingDataWithError(error: Error?) {
//        hideProgressBar()
//        showAlertWithCompletion(message: "Failed To Get Faqs", okTitle: "Retry", cancelTitle: "Cancel") {
//            self.showProgressBar()
//            User.shared.getAlerts(delegate: self)
//        }
//    }
//
//}
