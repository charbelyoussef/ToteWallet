//
//  DataHelper.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/23/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import JGProgressHUD

class DataHelper: NSObject {
    
    static var countries : [Country] {
        return CoreDataService.getAllCountries(ascending: true)
    }
    
    static var countriesName: [String] {
        var countryNames = [String]()
        for country in countries {
            if let name = country.codeWithName { countryNames.append(name) }
        }
        return countryNames
    }
    
    class func getcountry(for countryCode: String) -> Country? {
        return DataHelper.countries.filter {
            let phoneCodeStr = "\($0.phoneCode)"
            if phoneCodeStr != "", phoneCodeStr.contains(countryCode){
                return true
            }
            return false
        }.first
    }
    
    class func getcountryForId(countryId: String) -> Country? {
        return DataHelper.countries.filter {
            let countryIdStr = "\($0.id)"
            if countryIdStr != "", countryIdStr.contains(countryId){
                return true
            }
            return false
        }.first
    }
    
}

class WalletHelper: OBSRemoteDataDelegate {
    static var viewController:UIViewController?
    
    class func reloadWallets(vc:UIViewController){
        viewController = vc
        vc.showProgressBar()
        User.shared.getWallets(delegate: WalletHelper.init())
    }
    
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        WalletHelper.viewController?.hideProgressBar()
    }
    
    func hasFinishedLoadingDataWithError(error: Error?) {
        WalletHelper.viewController?.hideProgressBar()
    }
    
}
