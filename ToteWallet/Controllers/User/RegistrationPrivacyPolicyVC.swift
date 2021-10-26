//
//  PrivacyPolicyVC.swift
//  White Labelled App
//
//  Created by Charbel Helou on 10/7/19.
//  Copyright © 2019 Charbel Helou. All rights reserved.
//

import UIKit
import WebKit

class RegistrationPrivacyPolicyVC: UIViewController, WKNavigationDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var wvPrivacyPolicy: WKWebView!
    @IBOutlet weak var btnBack: UIButton!
    
    
    // MARK: Class Variables
    var urlToLoad:String?

    // MARK: Class Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDismissOnTap()
        self.wvPrivacyPolicy.navigationDelegate = self

        if let urlStr = urlToLoad {
            if let url = URL(string: urlStr) {
                wvPrivacyPolicy.load(URLRequest(url: url))
                showProgressBar()
                wvPrivacyPolicy.layer.cornerRadius = 10
            }
            else {
                self.showAlertWithCompletion(title: "Error", message: "The URL is invalid.", okTitle: "Ok", cancelTitle: nil) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else {
            self.showAlertWithCompletion(title: "Error", message: "Could not fetch privacy policy URL.", okTitle: "Ok", cancelTitle: nil) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    // MARK Class Methods
    
    
    // MARK : WKWebView Delegate Methods
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgressBar()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressBar()
        self.showAlertWithCompletion(title: "Error", message: "The URL failed to load.", okTitle: "Ok", cancelTitle: nil) {
            self.navigationController?.popViewController(animated: true)
        }

    }
    
    // MARK Button Handlers
    @IBAction func btnBackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
