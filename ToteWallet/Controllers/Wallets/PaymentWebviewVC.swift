//
//  RegisterVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import WebKit

class PaymentWebviewVC : UIViewController, UINavigationControllerDelegate, WKNavigationDelegate {
    
    // MARK: Class Outlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var wkWebview: WKWebView!
    
    // MARK: Class Variables
    var paymentUrl:String?
    var successUrl:String?
    var failureUrl:String?
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wkWebview.addObserver(self, forKeyPath: "URL", options: .new, context: nil)

        if let tempUrl = paymentUrl {

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
        addDoneButtonOnKeyboard()
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
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        decisionHandler(.allow)
//        guard let urlAsString = navigationAction.request.url?.absoluteString else {
//            return
//        }
//        
//        print(urlAsString)
//        
//        if urlAsString.range(of: "customaction://returnHome") != nil {
//            // do something
//            print(urlAsString)
//        }
//    }
    
    // MARK: Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "" {
//            let vc = segue.destination as? UIViewController
//            if vc != nil{
//               
//            }
        }
    }
    
    // MARK: Custom Methods
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = change?[NSKeyValueChangeKey.newKey] {            
            if let keyUrl = key as? NSURL, let keyStr = keyUrl.absoluteString, keyStr != "" {
                print("KeyStr : \(keyStr)")
                let successUrlStr = "\(successUrl ?? "N/A")"
                let failureUrlStr = "\(failureUrl ?? "N/A")"

                if(keyStr.lowercased().contains(successUrlStr)){
                    showAlertWithCompletion(message: "Success", okTitle: "Ok", cancelTitle: "") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else if(keyStr.lowercased().contains(failureUrlStr)){
                     showAlertWithCompletion(message: "Failure", okTitle: "Ok", cancelTitle: "") {
                         self.navigationController?.popViewController(animated: true)
                     }
                }
            }
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
