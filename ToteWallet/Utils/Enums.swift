//
//  Enums.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/12/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class Enums: NSObject {

    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }

    struct DeviceType
    {
        static let IS_IPHONE            = UIDevice.current.userInterfaceIdiom == .phone
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPHONE_7          = IS_IPHONE_6
        static let IS_IPHONE_7P         = IS_IPHONE_6P
        static let IS_IPHONE_8          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPHONE_8P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
        static let IS_IPHONE_11Pro      = IS_IPHONE_X
        static let IS_IPHONE_XsMax      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
        static let IS_IPHONE_11ProMax   = IS_IPHONE_XsMax
        static let IS_IPHONE_12Mini     = IS_IPHONE_X
    }
    
    struct Version{
        static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
        static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
        static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
        static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
        static let iOS10 = (Version.SYS_VERSION_FLOAT >= 10.0 && Version.SYS_VERSION_FLOAT < 11.0)
    }
    
    enum SideMenuTipsRows {
        case BuyTips
        case RequestTips
        case SendTips
        case Marketplace
    }
    
    enum TabBarSections:Int {
        case Home
        case Settings
        case Wallets
        case Notifications
        case Profile
        case Logout
    }
    
    enum HomeSubSection:Int {
        case Home = -1
        case BuyTips
        case Marketplace
        case RequestTips
        case SendTips
        case Membership
        case GetGrowGrain
    }

    
    enum Pickers: Int {
        case Wallet
        case Country
    }
    
    enum PurchaseProductPickers: Int {
        case Wallet
        case Country
    }
    
    enum PendingRequestStatus: Int64 {
        case Canceled = -2
        case SentRequest = 0
        case Confirmed = 1
        case Other
    }
}
