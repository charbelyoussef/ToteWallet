//
//  CustomWebView.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 11/2/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import WebKit

class CustomWebView: WKWebView {
    
    override func load(_ request: URLRequest) -> WKNavigation? {
        guard let mutableRequest: NSMutableURLRequest = request as? NSMutableURLRequest else {
            return super.load(request)
        }
        let wsse = OBSUser.shared.wsse!.generateToken()
    
        mutableRequest.setValue(wsse, forHTTPHeaderField: "x-wsse")
        return super.load(mutableRequest as URLRequest)
    }

}
