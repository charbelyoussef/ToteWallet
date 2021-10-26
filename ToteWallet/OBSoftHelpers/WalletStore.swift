//
//  User.swift
//  EyeQLab
//
//  Created by Nadim Henoud on 5/1/19.
//  Copyright © 2019 OBSoft. All rights reserved.
//

import Foundation
import AuthenticationServices

class WalletStore:OBSRemoteData {
    static private var instance:WalletStore?;
    
    var loyaltyProgramIdStored:String?
    var walletIdStored:String?
    var programRegistrationIdStored:String?
    
    static var shared:WalletStore{
        get {
            if instance==nil{
                instance=WalletStore()
            }
            return instance!
        }
    }
    
    
    public func sendTips(delegate: OBSRemoteDataDelegate? = nil,
                        senderWalletId: String,
                        countryCodeId: String,
                        phoneNumber: String,
                        amount:String,
                        description: String,
                        pinCode: String){
        
        self.delegate = delegate
        var data : [String: String] = [:]
        data["form[sender]"] = senderWalletId
        data["form[receiver][country]"] = countryCodeId
        data["form[receiver][number]"] = phoneNumber
        data["form[amount]"] = amount
        data["form[description]"] = description
        data["form[pinCode]"] = "\(pinCode)"

        self.postData(command: Config.sendTipsUrl, data: data, headers: nil, useQueue: false)
    }
    
    public func buyTips(delegate: OBSRemoteDataDelegate? = nil,
                        walletId: String,
                        subAmount: String,
                        amount: String,
                        ozowFee:String){
        
        self.delegate = delegate
        var data : [String: String] = [:]
        data["form[wallet]"] = walletId
        data["form[subAmount]"] = subAmount
        data["form[amount]"] = amount
        data["form[gateway]"] = "ozow"
        data["form[ozowFee]:2"] = ozowFee
    
        self.postData(command: Config.buyTipsUrl, data: data, headers: nil, useQueue: false)
    }
    
    public func requestTips(delegate: OBSRemoteDataDelegate? = nil,
                        countryCodeId: String,
                        phoneNumber: String,
                        amount:String,
                        description: String){
        
        self.delegate = delegate
        var data : [String: String] = [:]
//        data["form[sender]"] = senderWalletId
        data["form[sender][country]"] = countryCodeId
        data["form[sender][number]"] = phoneNumber
        data["form[amount]"] = amount
        data["form[description]"] = description
//        data["form[pinCode]"] = "\(pinCode)"

        self.postData(command: Config.requestTipsUrl, data: data, headers: nil, useQueue: false)
    }

        
        

        
    public func purchaseLoyaltyProgram(delegate: OBSRemoteDataDelegate? = nil,
                                       countryId:String,
                                       phoneNumber:String,
                                       pinCode: String,
                                       loyaltyProgramId: String,
                                       sender: String,
                                       quantity:String){
        
        self.delegate = delegate
        var data : [String: String] = [:]
        data["form[pinCode]"] = pinCode
        data["form[agent][country]"] = countryId
        data["form[agent][number]"] = phoneNumber
        data["form[id]"] = "\(loyaltyProgramId)"
        data["form[sender]"] = sender
        data["form[quantity]"] = quantity
        

        loyaltyProgramIdStored = loyaltyProgramId
        let purchaseLoyaltyUrl = Config.purchaseLoyaltyUrl.replacingOccurrences(of: "(id)", with: "\(loyaltyProgramId)")
        self.postData(command: purchaseLoyaltyUrl, data: data, headers: nil, useQueue: false)
    }
    
    public func registerProgram(delegate: OBSRemoteDataDelegate? = nil,
                                countryId:String,
                                phoneNumber:String,
                                pinCode: String,
                                id: String,
                                sender: String,
                                quantity:String){
        
        self.delegate = delegate
        var data : [String: String] = [:]
        data["form[pinCode]"] = pinCode
        data["form[agent][country]"] = countryId
        data["form[agent][number]"] = phoneNumber
        data["form[id]"] = "\(id)"
        data["form[sender]"] = sender
        data["form[quantity]"] = quantity
        
        programRegistrationIdStored = id
        let url =  Config.programRegistrationUrl.replacingOccurrences(of: "(id)", with: "\(id)")
        self.postData(command: url, data: data, headers: nil, useQueue: false)
    }
    
    public func editWallet(delegate: OBSRemoteDataDelegate? = nil,
                           id:String,
                           alias: String,
                           currency: String,
                           dailyLimit:String,
                           monthlyLimit: String,
                           creditLimit: String){
        
        self.delegate = delegate
        var data : [String: String] = [:]
        data["form[alias]"] = alias
        data["form[currency]"] = "1"
        data["form[dailyLimit]"] = dailyLimit
        data["form[monthlyLimit]"] = monthlyLimit
        data["form[creditLimit]"] = creditLimit
    
        walletIdStored = id
        let url =  Config.editWalletUrl.replacingOccurrences(of: "(id)", with: "\(id)")
        self.postData(command: url, data: data, headers: nil, useQueue: false)
    }
    
    public override func parseResponse(data: Data?, response: URLResponse?, error: Error?, command: String) {
        guard let jsonResponse = parseJSON(data: data!) else {
            self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Server Error: JSON Empty")
            return
        }
        
        let status = jsonResponse["status"] as? Int
        if status != nil && (status == 200 || status == 700 || status == 900 || status == 901) {
            
            let purchaseLoyaltyUrl =  Config.purchaseLoyaltyUrl.replacingOccurrences(of: "(id)", with: "\(loyaltyProgramIdStored ?? "N/A")")
            let editWalletUrl =  Config.editWalletUrl.replacingOccurrences(of: "(id)", with: "\(walletIdStored ?? "N/A")")
            let programRegistrationUrl =  Config.programRegistrationUrl.replacingOccurrences(of: "(id)", with: "\(programRegistrationIdStored ?? "N/A")")

            if command.contains(Config.buyTipsUrl) {
                
                if data != nil {
                    CoreDataManager.shared.context.rollback()
                    CoreDataService.clearBuyTips()
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataObj = responseDic["data"] as? NSDictionary {
                            let context = CoreDataManager.shared.context

                            let buyTips = BuyTips(context: context)
                            buyTips.parse(buyTipsObject: dataObj)
                            CoreDataManager.shared.saveContext(context)
                        }
                        self.delegate?.hasFinishedLoadingData(status: .HTTPSuccess, message: "Buy Tips fetched successfully")
                    }
                    else{
                        self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: responseDic["message"] as? String ?? "Failed To fetch Buy Tips")
                    }
                }
                else{
                    self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Server Error: JSON Empty")
                }
                return
            }
            
            else if command.contains(Config.sendTipsUrl) {
                
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
            else if command.contains(Config.requestTipsUrl) {
                
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
            else if command.contains(purchaseLoyaltyUrl){
                loyaltyProgramIdStored = ""
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
                
            else if command.contains(programRegistrationUrl){
                programRegistrationIdStored = ""
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
            
            else if command.contains(editWalletUrl){
                walletIdStored = ""
                if data != nil {
                    CoreDataManager.shared.context.rollback()
                    CoreDataService.clearWallets()
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataObj = responseDic["data"] as? NSDictionary {
                            let context = CoreDataManager.shared.context

                            let wallet = Wallet(context: context)
                            wallet.parse(walletObject: dataObj)
                            CoreDataManager.shared.saveContext(context)
                        }
                        self.delegate?.hasFinishedLoadingData(status: .HTTPSuccess, message: "Wallet updated successfully")
                    }
                    else{
                        self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Failed To update wallet")
                    }
                }
                else{
                    self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Server Error: JSON Empty")
                }
            }
        }
        else {
            if(status == 409){
                self.delegate?.hasFinishedLoadingData(status: .idFetchFailure, message: jsonResponse["message"] as? String ?? "")
            }
            if command.contains(Config.registrationURL){
                self.delegate?.hasFinishedLoadingData(status: .didNotRegister, message: jsonResponse["message"] as? String ?? "")
            }
            else{
                self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: jsonResponse["message"] as? String ?? "Error occured! Please try again later.")
            }
        }
    }
}
