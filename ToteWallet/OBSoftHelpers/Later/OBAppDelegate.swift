//
//  OBAppDelagate.swift
//  SADER UNIPRO
//
//  Created by Obsoft on 6/11/20.
//  Copyright © 2020 OBSoft. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    
    func initLogoutListener(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogout(_:)), name: .userLoggedOut, object: nil)
    }
    
    @objc
    func handleLogout(_ notification: Notification){
        //MARK: List stores that needs validify resets
//        NewsStore.shared.resetValidity()
    }
}
