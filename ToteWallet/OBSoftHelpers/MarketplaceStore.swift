//
//  User.swift
//  EyeQLab
//
//  Created by Nadim Henoud on 5/1/19.
//  Copyright © 2019 OBSoft. All rights reserved.
//

import Foundation
import AuthenticationServices

class MarketplaceStore:OBSRemoteData {
    static private var instance:MarketplaceStore?;
    
    var marketplaceIdStored:Int64?
    
    static var shared:MarketplaceStore{
        get {
            if instance==nil{
                instance=MarketplaceStore()
            }
            return instance!
        }
    }
    
    public func getProviders(delegate: OBSRemoteDataDelegate? = nil){
        self.delegate = delegate
        self.getData(command: Config.getMarketplaceProviders, headers: nil, useQueue: false)
    }
    
    public func getCategories(delegate: OBSRemoteDataDelegate? = nil, id: Int64){
        self.delegate = delegate
        let url =  Config.getMarketplaceCategories.replacingOccurrences(of: "(id)", with: "\(id)")
        marketplaceIdStored = id
        self.getData(command: url, headers: nil, useQueue: false)
    }

    public func getProducts(delegate: OBSRemoteDataDelegate? = nil, id: Int64){
        self.delegate = delegate
        marketplaceIdStored = id
        let url =  Config.getMarketplaceProducts.replacingOccurrences(of: "(id)", with: "\(id)")
        self.getData(command: url, headers: nil, useQueue: false)
    }

    public func purchaseProduct(delegate: OBSRemoteDataDelegate? = nil,
                                pinCode: String,
                                id: String,
                                sender: String,
                                address: String,
                                countryId: String,
                                cityId: String,
                                quantity:String){
        
        self.delegate = delegate
        var data : [String: String] = [:]
        data["form[pinCode]"] = pinCode
        data["form[id]"] = "\(id)"
        data["form[sender]"] = sender
        data["form[address]"] = address
        data["form[quantity]"] = quantity
        data["form[country]"] = countryId
        data["form[city]"] = cityId

        marketplaceIdStored = Int64(id)
        let url =  Config.purchaseMarketplaceProduct.replacingOccurrences(of: "(id)", with: "\(id)")
        self.postData(command: url, data: data, headers: nil, useQueue: false)
    }
    
    public func logout() {
        OBSUser.shared.logout()
    }
    
    public override func parseResponse(data: Data?, response: URLResponse?, error: Error?, command: String) {
        guard let jsonResponse = parseJSON(data: data!) else {
            self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Server Error: JSON Empty")
            return
        }
        
        let status = jsonResponse["status"] as? Int
        if status != nil && (status == 200 || status == 700 || status == 900) {
        
            let getMarketplaceCategoriesUrl =  Config.getMarketplaceCategories.replacingOccurrences(of: "(id)", with: "\(marketplaceIdStored ?? -1)")
            let getMarketplaceProductsUrl =  Config.getMarketplaceProducts.replacingOccurrences(of: "(id)", with: "\(marketplaceIdStored ?? -1)")
            let purchaseMarketplaceProductsUrl =  Config.purchaseMarketplaceProduct.replacingOccurrences(of: "(id)", with: "\(marketplaceIdStored ?? -1)")

            
            if command.contains(Config.getMarketplaceProviders) {
                CoreDataService.clearMarketPlaceProviders()
                if data != nil {

                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataArray = responseDic["data"] as? NSArray {
                            for dataObj in dataArray {
                                
                                if let dataDict = dataObj as? NSDictionary {
                                    let context = CoreDataManager.shared.context

                                    let marketplaceProvider = MarketplaceProvider(context: context)
                                    marketplaceProvider.parse(providerObject: dataDict)
                                    CoreDataManager.shared.saveContext(context)
                                }
                            }
                        }
                        self.delegate?.hasFinishedLoadingData(status: .HTTPSuccess, message: "Data Loaded Successfully")
                    }
                    else{
                        self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Failed To Load Data")
                    }
                }
                else{
                    self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Server Error: JSON Empty")
                }
            }
            else if command.contains(getMarketplaceCategoriesUrl) {
                CoreDataService.clearMarketPlaceCategories()
                marketplaceIdStored = -1
                if data != nil {

                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataArray = responseDic["data"] as? NSArray {
                            for dataObj in dataArray {
                                
                                if let dataDict = dataObj as? NSDictionary {
                                    let context = CoreDataManager.shared.context

                                    let marketplaceCategory = MarketplaceCategory(context: context)
                                    marketplaceCategory.parse(categoryObject: dataDict)
                                    CoreDataManager.shared.saveContext(context)
                                }
                            }
                        }
                        self.delegate?.hasFinishedLoadingData(status: .HTTPSuccess, message: "Data Loaded Successfully")
                    }
                    else{
                        self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Failed To Load Data")
                    }
                }
                else{
                    self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Server Error: JSON Empty")
                }
            }
            else if command.contains(getMarketplaceProductsUrl) {
                CoreDataService.clearMarketPlaceProducts()
                marketplaceIdStored = -1
                if data != nil {

                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataArray = responseDic["data"] as? NSArray {
                            for dataObj in dataArray {
                                
                                if let dataDict = dataObj as? NSDictionary {
                                    let context = CoreDataManager.shared.context

                                    let marketplaceProduct = MarketplaceProduct(context: context)
                                    marketplaceProduct.parse(productObject: dataDict)
                                    CoreDataManager.shared.saveContext(context)
                                }
                            }
                        }
                        self.delegate?.hasFinishedLoadingData(status: .HTTPSuccess, message: "Data Loaded Successfully")
                    }
                    else{
                        self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Failed To Load Data")
                    }
                }
                else{
                    self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Server Error: JSON Empty")
                }
            }
            else if command.contains(purchaseMarketplaceProductsUrl) {
                
                if data != nil {
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let message = responseDic["message"] as? String, message != "" {
                            self.delegate?.hasFinishedLoadingData(status: .HTTPSuccess, message: message)
                        }
                        else{
                            self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "No Error Message Available")
                        }
                    }
                    else{
                        if let message = responseDic["message"] as? String, message != "" {
                            self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: message)
                        }
                        else{
                            self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Failed To Load Data")
                        }
                    }
                }
                else{
                    self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Server Error: JSON Empty")
                }
                return
            }
        }
        else {
            self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: jsonResponse["message"] as? String ?? "Error occured! Please try again later.")
        }
    }

}
