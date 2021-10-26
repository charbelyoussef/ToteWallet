//
//  RegisterVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import WebKit

class ProgramsDetailsVC : UIViewController, UINavigationControllerDelegate, WKNavigationDelegate {
    
    // MARK: Class Outlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var wkWebview: WKWebView!
    
    // MARK: Class Variables
    var url:String?
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tempUrl = url {

            let link = URL(string:tempUrl)!
            let request = URLRequest(url: link)
            wkWebview.load(request)
            wkWebview.navigationDelegate = self
        }
        else{
            showAlertWithCompletion(title: "Warning!", message: "The url is empty", okTitle: "Ok", cancelTitle: "") {
                self.navigationController?.popViewController(animated: true)
            }
        }
        

        registerForKeyboardNotifications()
        setupDismissOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: WKWebview Methods
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showProgressBar()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgressBar()
    }
    
    // MARK: Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "" {
//            let vc = segue.destination as? UIViewController
//            if vc != nil{
//            }
        }
    }
    
    // MARK: Custom Methods
    
    
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
