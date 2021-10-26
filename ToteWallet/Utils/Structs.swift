//
//  Structs.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/23/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class Structs: NSObject {
    
    struct LandingScreenSection {
        let title:String?
        let segueIdentifier:String?
        let image:UIImage?
        let imageBack:UIImage?
    }

    struct RegisterObject {
        var title:String?
        var firstname:String?
        var lastname:String?
        var email:String?
        var password:String?
        var confirmPassword:String?
        var pinCode:String?
        var confirmPinCode:String?
        var phoneNumber:String?
       
        //Address
        var country:String?
        var countryCode:String?
        var province:String?
        var address1:String?
        var address2:String?
        var address3:String?
        var address4:String?
        
        var privacyPolicyCheck = false
    }
    
    struct FetchedContact {
        var firstName: String
        var lastName: String
        var telephone: String
        var phoneCode: String
    }
    
    struct LimitObject {
        var alias:String?
        var currency:String?
        var dailyLimit:Double
        var monthlyLimit:Double
        var creditLimit:Double
        //RO stands for "read only"
        var dailyLimitRO:Double
        var monthlyLimitRO:Double
        var yearlyLimitRO:Double
        var creditLimitRO:Double
    }
    
    struct ChangePasswordObject {
        var oldPassword:String?
        var newPassword:String?
    }
    
    struct AppConfiguration {
        let readOnlyBackgroundColor:String?
        let bgURL:String?
        let bgColor:String?
        let textFieldsBorderColor:String?
        let themeBGColorHexPrimary:String?
        let themeBGColorHexPrimaryLighter:String?
        let themeBGColorHexSecondary:String?
        let themeBGColorHexSecondaryLighter:String?
        let themeBGColorHexSecondaryExtraLight:String?
        let themeTextColorHex:String?
        let font:String?
        let logoUrl:String?
        let defaultBGImageName:String?
        let defaultLogoImageName:String?
        let privacyPolicyUrl:String?
    }
    
    struct ExpandableSectionHeader {
        let name:String
        let iconName:String
        var expandableNames:ExpandableNames
    }
    
    struct ExpandableNames {
        var isExpanded: Bool
        let names: [String]
        let iconNames:[String]
    }
    
    struct MarketplaceProvider {
        var id:Int
        var imageFile:String?
        var name:String?
        var hasChildren:Bool
        var parentId:Int
    }
    
    struct MarketplaceCategory {
        var id:Int
        var imageFile:String?
        var name:String?
        var hasChildren:Bool
        var parentId:Int
    }
    
    struct MarketplaceProduct {
        var id:Int
        var imageFile:String?
        var name:String?
        var hasChildren:Bool
        var parentId:Int
    }
    
    struct Wallet {
        let walletId:Int
        let name:String?
        let availableBalanceValue:Double?
        let type:String?
        let transactions:[WalletTransaction]?
        let limits:[WalletLimit]?
    }
    
    struct WalletTemp {
        let walletId:String?
        let alias:String?
        let balance:Double
        let dailyLimit:Double
        let dailyBalance:Double
        let monthlyLimit:Double
        let monthlyBalance:Double
        let adminDailyLimit:Double
        let adminDailyBalance:Double
        let adminMonthlyLimit:Double
        let adminMonthlyBalance:Double
        let adminYearlyLimit:Double
        let adminYearlyBalance:Double
        let isRemovable:Bool
        let statusCode:String?
        let type:String?
//        let limits:[WalletLimit]?
    }
    
    struct WalletTransaction {
        let name:String?
        let date:Date?
    }
    
    struct WalletLimit {
        let name:String?
    }
    
    struct Currency {
        let id:Int
        let name:String?
    }
    
    struct MyProgram {
        let name:String?
        let quantityPurchased:Int
        let balance:Int
        let referralLink:String?
        let detailsUrl:String?
    }
    
    struct Membership {
        var id:Int
        var name:String?
        var description:String?
        var color:String?
    }
    
    struct Hotel {
        let name:String?
        let description:String?
        let imageURL:String?
        let stars:Int?
        let minRate:Double?
        let rateCurrency:String?
        let amenities:[Amenity?]
        let rooms:[Room?]
    }
    
    struct Room {
        //        let serviceUsed:String?
        //        let roomTypeCode:String?
        //        let roomCode:String?
        let name:String?
        //        let sortOrder:Int?
        //        let quantity:Int?
        //        let description:String?
        let imageURLs:[String]?
        //        let mainImageURL:String?
        let minRate:Double?
        let rateCurrency:String?
        let hasMemberRate:Bool?
        let memberRate:Double?
        let memberRateCurrency:String?
        let rates:[Rate?]
    }
    
    struct Rate {
        let name:String?
        let code:String?
        let rate:Double?
        let isMemberRate:Bool?
        //        let rateCode:String?
        //        let roomTypeCode:String?
        //        let originalRate:Double?
        //        let discountedRate:Double?
        //        let tax:Double?
        //        let nightlyRates:[NightlyRate?]
    }
    
    struct NightlyRate {
        let rateCode:String?
        
    }
    
    struct Amenity {
        let title:String?
        let iconURL:String?
        let image:UIImage?
    }
    
    struct Vicinity {
        let title:String?
    }
    
    struct Notification {
        let id:Int?
        let title:String?
        let description:String?
    }
    
    struct Booking {
        let id:String?
        let hotelName:String?
        let address:String?
        let checInDate:String?
        let checkOutDate:String?
        let nights:Int?
        let rooms:Int?
        let adult:Int?
        let rate:Int?
    }
    
    struct RoomOffer {
        let neorchaHotelId:String?
        let hotelCode:String?
        let name:String?
        let code:String?
        let email:String?
        let tel:String?
        let fromDate:String?
        let toDate:String?
        let url:String?
        let description:String?
        let images:[String]?
        let enabled:Bool?
    }
    
    struct CityAttraction {
        let title:String?
        let description:String?
        let city:String?
        let country:String?
        let logo:String?
        let openingTime:String?
        let images:[String]?
        let networks:[Network]?
    }
    
    struct CityGuide {
        var items = [Item]()
        struct Item {
            let name:String?
            let content:String?
        }
    }
    
    struct Network {
        let name:String?
        let content:String?
        let imageUrl:String?
    }
    
    struct ExploreHotelDetails {
        let name:String?
        let subtitle:String?
        let description:String?
        let imageUrls:Array<String>
        let socialMedia:Array<Network>
        let contentList:Array<String>
    }
    
    struct Policy {
        let name:String?
        let content:String?
    }
}
