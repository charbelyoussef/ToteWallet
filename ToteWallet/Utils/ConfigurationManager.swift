//
//  ConfigurationManager.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/23/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class ConfigurationManager: NSObject {
    
    class func getAppConfiguration() -> Structs.AppConfiguration {
//        if let savedConfiguration = CoreDataService.getConfiguration() {
//            
//            return Structs.AppConfiguration(bgURL: savedConfiguration.backgroundUrl,
//                                            themeBGColorHex: savedConfiguration.colour,
//                                            themeTextColorHex: savedConfiguration.tint,
//                                            font: savedConfiguration.font,
//                                            logoUrl: savedConfiguration.logoUrl,
//                                            defaultBGImageName: Constants.defaultBGName,
//                                            defaultLogoImageName: "",
//                                            privacyPolicyUrl: savedConfiguration.privacyPolicyUrl)
//        }
//        else {
        return Structs.AppConfiguration(readOnlyBackgroundColor: "e7eaee",
                                        bgURL: "",
                                        bgColor: "ebebe9",
                                        textFieldsBorderColor: "e6e9ec",
                                        themeBGColorHexPrimary: "091b3a",
                                        themeBGColorHexPrimaryLighter: "254e8c",
                                        themeBGColorHexSecondary: "510a0e",
                                        themeBGColorHexSecondaryLighter: "9d1c1c",
                                        themeBGColorHexSecondaryExtraLight: "e64343",
                                        themeTextColorHex: "FFFFFF",
                                        font: "",
                                        logoUrl: "",
                                        defaultBGImageName: "",
                                        defaultLogoImageName: "logo",
                                        privacyPolicyUrl: "")
        
        }
//    }
    
    class func removeAppConfiguration() {
//        CoreDataService.clearConfiguration()
    }
    
//    class func saveAppConfiguration(config: Structs.AppConfiguration) {
//        let userDefaults = UserDefaults.standard
//        userDefaults.set(config.bgURL, forKey: "configuration_bgURL")
//        userDefaults.set(config.themeBGColorHex, forKey: "configuration_themeBGColorHex")
//        userDefaults.set(config.themeTextColorHex, forKey: "configuration_themeTextColorHex")
//        userDefaults.set(config.defaultBGImageName, forKey: "configuration_defaultBGImageName")
//        userDefaults.set(config.defaultLogoImageName, forKey: "configuration_defaultLogoImageName")
//        userDefaults.set(true, forKey: "configuration_set")
//    }
    
//    class func getAppConfiguration() -> Structs.AppConfiguration {
//        let userDefaults = UserDefaults.standard
//        if userDefaults.bool(forKey: "configuration_set") {
//            let bgURL = userDefaults.object(forKey: "configuration_bgURL") as? String
//            let themeBGColorHex = userDefaults.object(forKey: "configuration_themeBGColorHex") as? String
//            let themeTextColorHex = userDefaults.object(forKey: "configuration_themeTextColorHex") as? String
//            let defaultBGImageName = userDefaults.object(forKey: "configuration_defaultBGImageName") as? String
//            let defaultLogoImageName = userDefaults.object(forKey: "configuration_defaultLogoImageName") as? String
//            return Structs.AppConfiguration(bgURL: bgURL, themeBGColorHex: themeBGColorHex, themeTextColorHex: themeTextColorHex, defaultBGImageName: defaultBGImageName, defaultLogoImageName: defaultLogoImageName)
//        }
//        else {
//            return Structs.AppConfiguration(bgURL: "", themeBGColorHex: "F9C647", themeTextColorHex: "000000", defaultBGImageName: Constants.defaultBGName, defaultLogoImageName: Constants.defaultLogoName)
//        }
//    }
    
//    class func removeAppConfiguration() {
//        for key in UserDefaults.standard.dictionaryRepresentation().keys {
//            if key.hasPrefix("configuration_") {
//                UserDefaults.standard.removeObject(forKey: key)
//            }
//        }
//    }
    
    class func setPrimaryThemeBGColorForViews(views: [UIView]) {
        for view in views {
            view.backgroundColor = UIColor.init(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimary ?? "")
        }
    }
    
    class func setPrimaryLighterThemeBGColorForViews(views: [UIView]) {
        for view in views {
            view.backgroundColor = UIColor.init(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimaryLighter ?? "")
        }
    }
    
    class func setSecondaryThemeBGColorForViews(views: [UIView]) {
        for view in views {
            view.backgroundColor = UIColor.init(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexSecondary ?? "")
        }
    }
    
    class func setSecondaryLighterThemeBGColorForViews(views: [UIView]) {
        for view in views {
            view.backgroundColor = UIColor.init(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexSecondaryLighter ?? "")
        }
    }
    
    class func setSecondaryExtraLightThemeBGColorForViews(views: [UIView]) {
        for view in views {
            view.backgroundColor = UIColor.init(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexSecondaryExtraLight ?? "")
        }
    }
    
    class func setTextColorAsBGForViews(views: [UIView]) {
        for view in views {
            view.backgroundColor = UIColor.init(hexString: ConfigurationManager.getAppConfiguration().themeTextColorHex ?? "")
        }
    }
    
    class func setPrimaryThemeBGColorAsTextForObjects(objects: [AnyObject]) {
        setColorForTextObjects(objects: objects, color: UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimary ?? ""))
    }
    
    class func setPrimaryLighterThemeBGColorAsTextForObjects(objects: [AnyObject]) {
        setColorForTextObjects(objects: objects, color: UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimaryLighter ?? ""))
    }
    
    class func setThemeTextColorForObjects(objects: [AnyObject]) {
        setColorForTextObjects(objects: objects, color: UIColor(hexString: ConfigurationManager.getAppConfiguration().themeTextColorHex ?? ""))
    }
    
    private class func setColorForTextObjects(objects: [AnyObject], color: UIColor) {
        for object in objects {
            if let obj = object as? UIButton {
                obj.setTitleColor(color, for: .normal)
                continue
            }
            if let obj = object as? UILabel {
                obj.textColor = color
                continue
            }
            if let obj = object as? UITextView {
                obj.textColor = color
                continue
            }
        }
    }

}

class Config {
    static let useCoreData = true
    static let delegateRole = "ROLE_USER"
    static let modelName = "" //place the model name
    
    static let _reachabilityURL:[String:String] = [
        "default":"",
    ]
    static var reachabilityURL: String {
        get {
            return UserDefaults.standard.string(forKey: "savedReachability") ?? "https://totewallet.com"
        }
    }

    static var serverBaseURL: String {
        get {
            return UserDefaults.standard.string(forKey: "savedServerBase") ?? "https://totewallet.com"
        }
    }
    
    static var serverAPIURL: String {
        get {
            return "\(Config.serverBaseURL)/"
        }
    }
    
    
    static var serverDf:DateFormatter {
        get {
            let d = DateFormatter()
            d.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            return d
        }
    }
    static var serverDOnlyf:DateFormatter {
        get {
            let d = DateFormatter()
            d.dateFormat = "yyyy-MM-dd"
            return d
        }
    }
    
    static var imageDf:DateFormatter {
        get {
            let d = DateFormatter()
            d.dateFormat = "yyyyMMdd-HHmmss"
            return d
        }
    }
    
    static let defaultFontSize = 100
    static let defaultFontSizeAddend = 25
    
    static let colorPrimaryAccent = UIColor(hex: "#D81B60")
    static let colorPrimaryDark = UIColor(hex: "#910033")
    static let colorPrimaryDarker = UIColor(hex: "#761525")
    
    static let appVersion = "1.0"
    static let enableAutoLogin = true
    static let registerForPushAfterLogin = false
    
    //declare needed urls here
    static let versionVerifyingURL = "version/ios"
    static let versionCheckURL = ""
    static let loginCheckURL = ""
//    static let loginURL = ""
    static let registerPushURL = ""
    
    //User
    static let registrationURL = "platform/apiregister"
    static let profileDetailsUrl = "api/profile"
    static let loginUrl = "platform/apilogin"
    static let editProfileUrl = "api/profile/edit"
    static let requestResetPasswordURL = "platform/apireset/request_password_reset"
    static let requestResetPasswordLoggedInURL = "api/reset/request_password_reset"    
    static let requestResetPinURL = "api/reset/request_pincode_reset"
    static let profileSettings = "api/settings"
    static let verifyEmailUrl = "platform/apiverification/email"
    static let verifyPhoneUrl = "platform/apiverification/phone"
    static let getWalletsUrl = "api/wallet/list"
    static let getTransactionsUrl = "api/tx/list"
    static let getPendingRequestsUrl = "api/request/tx/list"
    static let cancelPendingRequestUrl = "api/wallet/(id)/rejectrequesttx"
    static let confirmPendingRequestUrl = "api/wallet/(id)/verifyrequesttx"
    static let getCountriesUrl = "platform/apicountry/list"
    static let getAppConfigurationUrl = "platform/apiconfiguration/list"
    static let getCitiesUrl = "platform/apicountry/(id)/city/list"
    static let getAlertsUrl = "api/alert/list"
    static let getFaqsUrl = "api/faq/list"

    //Marketplace
    static let getMarketplaceProviders = "api/shop/category/marketPlace" //was "api/shop/category/list"
    static let getMarketplaceCategories = "api/shop/category/(id)/list"
    static let getMarketplaceProducts = "api/shop/category/(id)/products/list"
    static let purchaseMarketplaceProduct = "api/shop/product/(id)/purchase"
    
    //Wallet
    static let buyTipsUrl = "api/buy/tips"
    static let sendTipsUrl = "api/wallet/send"
    static let requestTipsUrl = "api/wallet/requesttx"
    static let purchaseLoyaltyUrl = "api/invest/(id)/register"
    static let editWalletUrl = "api/wallet/(id)/edit"
    static let programRegistrationUrl = "api/invest/(id)/register"

    //Misc
    static let getProgramsUrl = "api/shop/category/investprograms/products"
    static let getMyProgramsUrl = "api/invest_user/list"
    static let sellProgramUrl = "api/invest_user/(id)/sell"
    static let getLoyaltyProgramsUrl = "api/shop/category/membership/products"
    static let getOzowFees = "api/ozow/fees"

}
