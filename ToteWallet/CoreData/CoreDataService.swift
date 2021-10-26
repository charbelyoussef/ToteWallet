//
//  CoreDataService.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class CoreDataService {
    
    static func getUserSettings() -> Settings? {
        guard let arr = CoreDataManager.getAllObjects(entity: "Settings", predicate: nil) as? [Settings] else { return nil }
        return arr.first
    }
    
    static func clearUserSettings() {
        CoreDataManager.clearSavedObjects(entity: "Settings")
    }
    
    static func getLogin() -> Login? {
        guard let arr = CoreDataManager.getAllObjects(entity: "Login", predicate: nil) as? [Login] else { return nil }
        return arr.first
    }
    
    static func clearLogin() {
        CoreDataManager.clearSavedObjects(entity: "Login")
    }
    
    static func getProfileSettings() -> ProfileSettings? {
        guard let arr = CoreDataManager.getAllObjects(entity: "ProfileSettings", predicate: nil) as? [ProfileSettings] else { return nil }
        return arr.first
    }
    
    static func clearProfileSettings() {
        CoreDataManager.clearSavedObjects(entity: "ProfileSettings")
    }

    static func getLogin(with id: String?) -> Login? {
        if id == nil { return nil }
        let predicate = NSPredicate(format: "id == %@", id ?? "unset")
        guard let arr = CoreDataManager.getAllObjects(entity: "Login", predicate: predicate) as? [Login] else { return nil }
        return arr.first
    }
    
    static func getPrograms() -> [Program] {
        guard let arr = CoreDataManager.getAllObjects(entity: "Program", predicate: nil) as? [Program] else { return [] }
        return arr
    }

    static func clearPrograms()  {
        CoreDataManager.clearSavedObjects(entity: "Program")
    }

    static func getMyPrograms() -> [MyProgram] {
        guard let arr = CoreDataManager.getAllObjects(entity: "MyProgram", predicate: nil) as? [MyProgram] else { return [] }
        return arr
    }

    static func clearMyPrograms()  {
        CoreDataManager.clearSavedObjects(entity: "MyProgram")
    }

    static func getAlerts() -> [Alert] {
        guard let arr = CoreDataManager.getAllObjects(entity: "Alert", predicate: nil) as? [Alert] else { return [] }
        return arr
    }

    static func clearAlerts()  {
        CoreDataManager.clearSavedObjects(entity: "Alert")
    }
    
    static func getFaqs() -> [Faq] {
        guard let arr = CoreDataManager.getAllObjects(entity: "Faq", predicate: nil) as? [Faq] else { return [] }
        return arr
    }

    static func clearFaqs()  {
        CoreDataManager.clearSavedObjects(entity: "Faq")
    }
    
    static func getWallets() -> [Wallet] {
        guard let arr = CoreDataManager.getAllObjects(entity: "Wallet", predicate: nil) as? [Wallet] else { return [] }
        return arr
    }

    static func clearWallets() {
        CoreDataManager.clearSavedObjects(entity: "Wallet")
    }
    
    static func getBuyTips() -> [BuyTips] {
        guard let arr = CoreDataManager.getAllObjects(entity: "BuyTips", predicate: nil) as? [BuyTips] else { return [] }
        return arr
    }

    static func clearBuyTips() {
        CoreDataManager.clearSavedObjects(entity: "BuyTips")
    }
    
    static func getOzowFees() -> [OzowFee] {
        guard let arr = CoreDataManager.getAllObjects(entity: "OzowFee", predicate: nil) as? [OzowFee] else { return [] }
        return arr
    }

    static func clearFees() {
        CoreDataManager.clearSavedObjects(entity: "OzowFee")
    }
    
    static func getAppConfiguration() -> [AppConfiguration] {
        guard let arr = CoreDataManager.getAllObjects(entity: "AppConfiguration", predicate: nil) as? [AppConfiguration] else { return [] }
        return arr
    }

    static func clearAppConfiguration() {
        CoreDataManager.clearSavedObjects(entity: "AppConfiguration")
    }
    
    static func getTransactions() -> [Transaction] {
        guard let arr = CoreDataManager.getAllObjects(entity: "Transaction", predicate: nil) as? [Transaction] else { return [] }
        return arr
    }

    static func clearTransactions() {
        CoreDataManager.clearSavedObjects(entity: "Transaction")
    }

    static func getPendingRequests() -> [PendingRequest] {
        guard let arr = CoreDataManager.getAllObjects(entity: "PendingRequest", predicate: nil) as? [PendingRequest] else { return [] }
        return arr
    }

    static func clearPendingRequests() {
        CoreDataManager.clearSavedObjects(entity: "PendingRequest")
    }
    
    //Marketplace
    static func getMarketPlaceProviders() -> [MarketplaceProvider] {
        guard let arr = CoreDataManager.getAllObjects(entity: "MarketplaceProvider", predicate: nil) as? [MarketplaceProvider] else { return [] }
        return arr
    }

    static func clearMarketPlaceProviders() {
        CoreDataManager.clearSavedObjects(entity: "MarketplaceProvider")
    }
    
    static func getMarketPlaceCategories() -> [MarketplaceCategory] {
        guard let arr = CoreDataManager.getAllObjects(entity: "MarketplaceCategory", predicate: nil) as? [MarketplaceCategory] else { return [] }
        return arr
    }

    static func clearMarketPlaceCategories() {
        CoreDataManager.clearSavedObjects(entity: "MarketplaceCategory")
    }

    static func getMarketPlaceProducts() -> [MarketplaceProduct] {
        guard let arr = CoreDataManager.getAllObjects(entity: "MarketplaceProduct", predicate: nil) as? [MarketplaceProduct] else { return [] }
        return arr
    }
    
    static func clearMarketPlaceProducts() {
        CoreDataManager.clearSavedObjects(entity: "MarketplaceProduct")
    }

    static func getAllCountries(ascending: Bool?) -> [Country] {
        var sortDescriptors:[NSSortDescriptor] = []
        if ascending != nil {
            sortDescriptors = [NSSortDescriptor(key: "name", ascending: ascending!, selector:#selector(NSString.caseInsensitiveCompare(_:)))]
        }
        guard let arr = CoreDataManager.getAllObjects(entity: "Country", predicate: nil, sortDescriptors: sortDescriptors) as? [Country] else { return [] }
        return arr
    }

    static func clearCountries() {
        CoreDataManager.clearSavedObjects(entity: "Country")
    }
    
    static func getAllCities(ascending: Bool?) -> [City] {
        var sortDescriptors:[NSSortDescriptor] = []
        if ascending != nil {
            sortDescriptors = [NSSortDescriptor(key: "name", ascending: ascending!, selector:#selector(NSString.caseInsensitiveCompare(_:)))]
        }
        guard let arr = CoreDataManager.getAllObjects(entity: "City", predicate: nil, sortDescriptors: sortDescriptors) as? [City] else { return [] }
        return arr
    }

    static func clearCities() {
        CoreDataManager.clearSavedObjects(entity: "City")
    }
    
    static func getLoyaltyPrograms() -> [LoyaltyProgram] {
            guard let arr = CoreDataManager.getAllObjects(entity: "LoyaltyProgram", predicate: nil) as? [LoyaltyProgram] else { return [] }
            return arr
        }

    static func clearLoyaltyPrograms() {
        CoreDataManager.clearSavedObjects(entity: "LoyaltyProgram")
    }
    
    static func clearAll() {
        clearLogin()
        clearWallets()
        clearFaqs()
        clearFees()
        clearAlerts()
        clearPrograms()
        clearTransactions()
        clearProfileSettings()
        clearAppConfiguration()
    }

//    static func getAllTitles() -> [Title] {
//        guard let arr = CoreDataManager.getAllObjects(entity: "Title", predicate: nil) as? [Title] else { return [] }
//        return arr
//    }
//
//    static func clearTitles() {
//        CoreDataManager.clearSavedObjects(entity: "Title")
//    }
}
