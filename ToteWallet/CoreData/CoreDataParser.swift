//
//  CoreDataParser.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//


import UIKit

extension Login {
    func parseProfileDetails(profileDetailsObject: NSDictionary){
        self.id = profileDetailsObject["id"] as? String
        
        if let imageUrl = profileDetailsObject["profilePicFile"] as? String {
            self.imageUrl = "\(Constants.urlPrefix)\(imageUrl)"
        }
        else{
            self.imageUrl = ""
        }
        
        if let imageUrl = profileDetailsObject["details.idImageFile"] as? String {
            self.idImageUrl = "\(Constants.urlPrefix)\(imageUrl)"
        }
        else{
            self.idImageUrl = ""
        }
        
        self.firstName = profileDetailsObject["firstName"] as? String
        self.lastName = profileDetailsObject["lastName"] as? String
        
        if let gender = profileDetailsObject["gender"] as? Bool{
            self.gender = gender == true ? 1 : 0
        }
        self.genderName = profileDetailsObject["genderName"] as? String
        
        
        self.email = profileDetailsObject["email"] as? String
        self.username = profileDetailsObject["username"] as? String

        if let phoneObject = profileDetailsObject["phone"] as? NSDictionary {
            if let countryCode = phoneObject["country"] as? Int64{
                self.countryCode = countryCode
            }
            if let number = phoneObject["number"] as? Int64{
                self.tel = String(number)
            }

//            if let countryObject = phoneObject["countryObject"] as? NSDictionary {
//                
//            }
        }
        if let detailsIdTypeId = profileDetailsObject["idTypeId"] as? Int64{
            self.detailsIdTypeId = detailsIdTypeId
        }
        
        self.detailsIdTypeName = profileDetailsObject["idTypeName"] as? String
        
        
        if let detailsIdNationalityId = profileDetailsObject["idNationalityId"] as? Int64{
            self.detailsIdNationalityId = detailsIdNationalityId
        }

        if let detailsIdNumber = profileDetailsObject["details.idNumber"] as? Int64{
            self.detailsIdNumber = detailsIdNumber
        }
        if let birthdateObject = profileDetailsObject["details.birthdate"] as? NSDictionary {
            self.birthdate = birthdateObject["date"] as? String
        }
        
        if let detailsCountryId = profileDetailsObject["countryId"] as? Int64{
            self.detailsCountryId = detailsCountryId
        }
        self.countryName = profileDetailsObject["countryName"] as? String
        
        if let detailsCityId = profileDetailsObject["cityId"] as? Int64{
            self.detailsCityId = String(detailsCityId)
        }
        self.cityName = profileDetailsObject["cityName"] as? String
//        self.cityName = "Beqaa"
        
        self.detailsAddress = profileDetailsObject["details.address"] as? String
        
        if let addresses = detailsAddress?.split(separator: "|"), addresses.count > 0 {
            let address1Temp = String(addresses[0])
            if address1Temp != "" {
                self.address1 = address1Temp
            }
            
            let index1 = 1
            if index1 < addresses.count {
                let address2Temp = String(addresses[index1])
                if address2Temp != "" {
                    self.address2 = address2Temp
                }
            }

            let index2 = 2
            if index2 < addresses.count {
                let address3Temp = String(addresses[index2])
                if address3Temp != "" {
                    self.address3 = address3Temp
                }
            }

            let index3 = 3
            if index3 < addresses.count {
                let address4Temp = String(addresses[index3])
                if address4Temp != "" {
                    self.address4 = address4Temp
                }
            }
        }
    }
    
    func parse(id:String, wsse:String, loginObject: NSDictionary){
        self.id = id
        self.email = loginObject["email"] as? String
        self.fullName = loginObject["name"] as? String

        if let phoneObject = loginObject["phone"] as? NSDictionary {
            if let countryCode = phoneObject["country"] as? Int64{
                self.countryCode = countryCode
            }
            if let number = phoneObject["number"] as? Int64{
                self.tel = String(number)
            }

//            if let countryObject = phoneObject["countryObject"] as? NSDictionary {
//                
//            }
        }
        
        self.wsse = wsse

//        self.imageUrl = "https://i.pinimg.com/originals/0e/c6/6b/0ec66b439eb296c4f69cc261e44a785b.jpg"
    }
}


extension ProfileSettings {
    func parse(profileSettingsObject: NSDictionary){
        
        self.primaryWalletId = profileSettingsObject["settings.primaryWallet.id"] as? String
        
        if let preferredCurrencyIdTemp = profileSettingsObject["settings.preferredCurrency.id"] as? Int64{
            self.preferredCurrencyId = preferredCurrencyIdTemp
        }
        
        if let smsNotificationTemp = profileSettingsObject["settings.smsNotification"] as? Bool {
            self.smsNotification = smsNotificationTemp
        }

        if let calculatedFeesObject = profileSettingsObject["settings.calculatedFees"] as? NSDictionary {
            
            if let feesObject = calculatedFeesObject["fees"] as? NSDictionary {
                if let feesValueTemp = feesObject["value"] as? Int64 {
                    self.feesValue = feesValueTemp
                }
                self.feesSymbol = feesObject["symbol"] as? String
            }
            
            if let commissionObject = calculatedFeesObject["commission"] as? NSDictionary {
                if let commissionValueTemp = commissionObject["value"] as? Int64 {
                    self.commissionValue = commissionValueTemp
                }
                self.commissionSymbol = commissionObject["symbol"] as? String
            }

            if let pointsObject = calculatedFeesObject["points"] as? NSDictionary {
                if let pointsValueTemp = pointsObject["value"] as? Int64 {
                    self.pointsValue = pointsValueTemp
                }
                self.pointsSymbol = pointsObject["symbol"] as? String
            }

            if let cashbackObject = calculatedFeesObject["cashback"] as? NSDictionary {
                if let cashbackValueTemp = cashbackObject["value"] as? Int64 {
                    self.cashbackValue = cashbackValueTemp
                }
                self.cashbackSymbol = cashbackObject["symbol"] as? String
            }
            
            if let registrationObject = calculatedFeesObject["fees"] as? NSDictionary {
                if let registrationValueTemp = registrationObject["value"] as? Int64 {
                   self.registrationValue = registrationValueTemp
                }
                self.registrationSymbol = registrationObject["symbol"] as? String
            }
            
            if let smsObject = calculatedFeesObject["sms"] as? NSDictionary {
                if let smsValueTemp = smsObject["value"] as? Int64 {
                    self.smsValue = smsValueTemp
                }
                self.smsSymbol = smsObject["symbol"] as? String
            }

            if let creditLimitObject = calculatedFeesObject["creditLimit"] as? NSDictionary {
                if let creditLimitValueTemp = creditLimitObject["value"] as? Int64 {
                    self.creditLimitValue = creditLimitValueTemp
                }
                self.creditLimitSymbol = creditLimitObject["symbol"] as? String
            }

            if let creditInterestObject = calculatedFeesObject["creditInterest"] as? NSDictionary {
                if let creditInterestValueTemp = creditInterestObject["value"] as? Int64 {
                    self.creditInterestValue = creditInterestValueTemp
                }
                self.creditInterestSymbol = creditInterestObject["symbol"] as? String
            }
        }
    }
}

extension Wallet {
    
    func parse(walletObject: NSDictionary){
        self.walletId = walletObject["id"] as? String
        self.alias = walletObject["alias"] as? String
        
        if let balance = walletObject["balance"] as? Double{
            self.balance = balance
            self.roundedBalance = Double(round(1000*balance)/1000)
        }
        if let dailyLimit = walletObject["dailyLimit"] as? Double{
            self.dailyLimit = dailyLimit
        }
        if let dailyBalance = walletObject["dailyBalance"] as? Double{
            self.dailyBalance = dailyBalance
        }
        if let monthlyLimit = walletObject["monthlyLimit"] as? Double{
            self.monthlyLimit = monthlyLimit
        }
        if let monthlyBalance = walletObject["monthlyBalance"] as? Double{
            self.monthlyBalance = monthlyBalance
        }
        if let adminDailyLimit = walletObject["adminDailyLimit"] as? Double{
            self.adminDailyLimit = adminDailyLimit
        }
        if let adminDailyBalance = walletObject["adminDailyBalance"] as? Double{
            self.adminDailyBalance = adminDailyBalance
        }
        if let adminMonthlyLimit = walletObject["adminMonthlyLimit"] as? Double{
            self.adminMonthlyLimit = adminMonthlyLimit
        }
        
        if let adminMonthlyBalance = walletObject["adminMonthlyBalance"] as? Double{
            self.adminMonthlyBalance = adminMonthlyBalance
        }
        if let adminYearlyLimit = walletObject["adminYearlyLimit"] as? Double{
            self.adminYearlyLimit = adminYearlyLimit
        }
        if let adminYearlyBalance = walletObject["adminYearlyBalance"] as? Double{
            self.adminYearlyBalance = adminYearlyBalance
        }
        if let isRemovable = walletObject["isRemovable"] as? Bool{
            self.isRemovable = isRemovable
        }
        
        if let statusCode = walletObject["status.code"] as? String {
            self.statusCode = statusCode
            self.type = statusCode == "P" ? "Primary" : "Secondary"
        }
        else{
            self.type = "N/A"
        }
        
        if let adminYearlyBalance = walletObject["creditLimit"] as? Double{
            self.creditLimit = adminYearlyBalance
        }
        
        
        self.currencyIsoCode = walletObject["currencyIsoCode"] as? String
        
        print(Utils.toJSON(object: walletObject))
//        if let createdObject = walletObject["created"] as? NSDictionary {
//            let creationDate = createdObject["date"] as? String
//        }
//        
//        if let modificationObject = walletObject["modified"] as? NSDictionary {
//            let modificationDate = modificationObject["date"] as? String
//        }
    }
}

extension Transaction {

    func parse(transactionObject: NSDictionary){
        if let idTemp = transactionObject["id"] as? Int64 {
            self.transactionId = idTemp
        }
        self.ref = transactionObject["ref"] as? String
        self.senderOwnerName = transactionObject["sender.ownername"] as? String
        self.receiverOwnerName = transactionObject["receiver.ownername"] as? String
        self.desc = transactionObject["description"] as? String
        
        if let baseAmount = transactionObject["baseAmount"] as? Int64 {
            self.baseAmount = baseAmount
        }
        
        if let dateObject = transactionObject["date"] as? NSDictionary {
            if let dateStr = dateObject["date"] as? String, dateStr != "" {
                let dateStrTemp = String(dateStr.split(separator: ".")[0])
                
                if let timeZoneCodeStr = dateObject["timezone"] as? String, timeZoneCodeStr != "" {
                    self.timeZoneCode = timeZoneCodeStr
                    self.date = Utils.dateStringToLocal(dateStr: dateStrTemp, timeZone: timeZoneCodeStr)
                }
                else{
                    self.date = Utils.dateStringToLocal(dateStr: dateStrTemp)
                }
            }
        }
        
        self.senderCurrencySymbol = transactionObject["senderCurrency.symbol"] as? String
        
        if let balance = transactionObject["balance"] as? Int64 {
            self.balance = balance
        }
    }
    
}

extension PendingRequest {

    func parse(pendingRequestObject: NSDictionary){
        if let idTemp = pendingRequestObject["id"] as? Int64 {
            self.pendingRequestId = "\(idTemp)"
        }
        
        if let dateObject = pendingRequestObject["date"] as? NSDictionary {
            if let dateStr = dateObject["date"] as? String, dateStr != "" {
                
                let dateStrTemp = String(dateStr.split(separator: ".")[0])

                if let timeZoneCodeStr = dateObject["timezone"] as? String, timeZoneCodeStr != "" {
                    self.timeZoneCode = timeZoneCodeStr
                    self.date = Utils.dateStringToLocal(dateStr: dateStrTemp, timeZone: timeZoneCodeStr)
                }
                else{
                    self.date = Utils.dateStringToLocal(dateStr: dateStrTemp)
                }
            }
        }

        
        self.senderPhoneNumber = pendingRequestObject["sender.phoneNumber"] as? String
        self.receiverOwnerUsername = pendingRequestObject["receiver.owner.username"] as? String
        self.receiverOwnerName = pendingRequestObject["receiver.ownername"] as? String
        self.token = pendingRequestObject["token"] as? String
        self.desc = pendingRequestObject["description"] as? String

        if let baseAmount = pendingRequestObject["baseAmount"] as? Int64 {
            self.baseAmount = "\(baseAmount)"
        }
        if let statusTemp = pendingRequestObject["status"] as? Int64 {
            self.status = statusTemp
        }
        
        if self.status == Enums.PendingRequestStatus.Canceled.rawValue {
            self.statusName = "Canceled"
        }
        else if self.status == Enums.PendingRequestStatus.SentRequest.rawValue, self.receiverOwnerUsername == CoreDataService.getLogin()?.username {
            self.statusName = "Sent Request"
        }
        else if self.status == Enums.PendingRequestStatus.Confirmed.rawValue {
            self.statusName = "Confirmed"
        }
        else {
            self.statusName = "Other"
        }
           
    }
    
}

extension Alert {

    func parse(alertObject: NSDictionary){
        if let idTemp = alertObject["id"] as? Int64 {
            self.id = idTemp
        }
        
        self.title = alertObject["title"] as? String
        self.message = alertObject["message"] as? String
        self.targetName = alertObject["targetName"] as? String
        
        if let idTemp = alertObject["targetId"] as? Int64 {
            self.targetId = "\(idTemp)"
        }

    }
    
}

extension Faq {

    func parse(faqObject: NSDictionary){
        if let idTemp = faqObject["id"] as? Int64 {
            self.faqId = "\(idTemp)"
        }
        
        self.question = faqObject["question"] as? String
        self.answer = faqObject["answer"] as? String
    }
    
}

extension MarketplaceProvider {
    func parse(providerObject: NSDictionary){
        if let idTemp = providerObject["id"] as? Int64 {
            self.id = idTemp
        }
        self.imageFile = providerObject["imageFile"] as? String
        self.name = providerObject["name"] as? String
        
        if let hasChildren = providerObject["hasChildren"] as? Bool {
            self.hasChildren = hasChildren
        }
        
        if let parentId = providerObject["parentId"] as? Int64 {
            self.parentId = parentId
        }
    }
}

extension MarketplaceCategory {
    func parse(categoryObject: NSDictionary){
        if let idTemp = categoryObject["id"] as? Int64 {
            self.id = idTemp
        }
        self.imageFile = categoryObject["imageFile"] as? String
        self.name = categoryObject["name"] as? String
        
        if let hasChildren = categoryObject["hasChildren"] as? Bool {
            self.hasChildren = hasChildren
        }
        
        if let parentId = categoryObject["parentId"] as? Int64 {
            self.parentId = parentId
        }
    }
}


extension MarketplaceProduct {
    func parse(productObject: NSDictionary){
        if let idTemp = productObject["id"] as? Int64 {
            self.id = idTemp
        }
        self.imageFile = productObject["imageFile"] as? String
        self.name = productObject["name"] as? String
        self.desc = productObject["description"] as? String

        if let settingsPrice = productObject["settings.price"] as? Double {
            self.settingsPrice = settingsPrice
        }
        if let settingsDiscount = productObject["settings.discount"] as? Double {
            self.settingsDiscount = settingsDiscount
        }

        self.productTypeName = productObject["productType.name"] as? String
        
        if let isDeliverable = productObject["isDeliverable"] as? Bool {
            self.isDeliverable = isDeliverable
        }

        self.priceMode = productObject["priceMode"] as? String
        self.identifier = productObject["identifier"] as? String        
    }
}


extension Country {
    func parse(countryObject: NSDictionary){
        self.id = countryObject["id"] as! Int64
        self.name = countryObject["name"] as? String
        if let phoneCode = countryObject["phoneCode"] as? Int64{
            self.phoneCode = phoneCode
        }

        if let nameTemp = countryObject["name"] as? String, let phoneCodeTemp = countryObject["phoneCode"] as? Int64 {
            self.codeWithName = "\(nameTemp)(+\(phoneCodeTemp))"
        }
    }
}

extension AppConfiguration {
    func parse(countryObject: NSDictionary){
        if let idTemp = countryObject["id"] as? Int64 {
            self.countryId = "\(idTemp)"
        }
        if let phoneCountryCodeTemp = countryObject["phoneCode"] as? Int64 {
            self.phoneCountryCode = "\(phoneCountryCodeTemp)"
        }

        self.countryName = countryObject["name"] as? String
        if let nameTemp = countryObject["name"] as? String, let phoneCodeTemp = countryObject["phoneCode"] as? Int64 {
            self.codeWithName = "\(nameTemp)(+\(phoneCodeTemp))"
        }
    }
}

extension City {
    func parse(countryObject: NSDictionary){
        if let idTemp = countryObject["id"] as? Int64{
            self.id = String(idTemp)
        }
        self.name = countryObject["name"] as? String
        if let countryId = countryObject["country"] as? String{
            self.countryId = countryId
        }
    }
}

extension Program {
    func parse(programObject: NSDictionary){
        self.id = programObject["id"] as! Int64

        self.imageFile = programObject["imageFile"] as? String
        self.iconFile = programObject["iconFile"] as? String
        self.name = programObject["name"] as? String
        self.desc = programObject["description"] as? String
        self.detailsUrl = "https://totewallet.com/api/invest/\(self.id)/show"
        
        if let settingsPriceTemp = programObject["settings.price"] as? Int64 {
            self.settingsPrice = String(settingsPriceTemp)
        }
        
        if let totalInTemp = programObject["totalIn"] as? Int64 {
            self.totalIn = String(totalInTemp)
        }
        
        if let stockTemp = programObject["stock"] as? Int64 {
            self.stock = String(stockTemp)
        }

        if let growTemp = programObject["grow"] as? Int64 {
            self.grow = String(growTemp)
        }
        
        if let gainTemp = programObject["gain"] as? Int64 {
            self.gain = String(gainTemp)
        }

        if self.stock != nil, self.stock != "", self.totalIn != nil, self.totalIn != ""  {
            if self.stock == "0" || self.totalIn == "0" {
                self.percentage = 0
            }
            else{
                let percentageValue = (Float(Double(self.stock ?? "0") ?? 1)/Float(Double(self.totalIn ?? "0") ?? 1))*100
                self.percentage = Float(Int(percentageValue.rounded()))
            }
        }
    }
}

extension MyProgram {
    func parse(myProgramObject: NSDictionary){
        self.myProgramId = myProgramObject["id"] as! Int64
        
        if let productIdTemp = myProgramObject["product.id"] as? Int64 {
            self.productId = String(productIdTemp)
        }
        
        self.productName = myProgramObject["product.name"] as? String
        
        if let quantityTemp = myProgramObject["quantity"] as? Int64 {
            self.quantity = String(quantityTemp)
        }

        self.status = myProgramObject["status"] as? String
        
        if let levelTemp = myProgramObject["level"] as? Int64 {
            self.level = String(levelTemp)
        }
        
        if let balanceTemp = myProgramObject["balance"] as? Int64 {
            self.balance = String(balanceTemp)
        }

        
        if let lastInvitationObject = myProgramObject["lastInvitation"] as? NSDictionary {
            self.lastInvitationDate = lastInvitationObject["date"] as? String
        }
        
        if let joinDateObject = myProgramObject["joinDate"] as? NSDictionary {
            self.joinDate = joinDateObject["date"] as? String
        }

        if let activationDateObject = myProgramObject["activationDate"] as? NSDictionary {
            self.activationDate = activationDateObject["date"] as? String
        }
        
        self.isActive = myProgramObject["active"] as? String
        self.isSellable = myProgramObject["product.isSellable"] as? Bool ?? false 

        let myProgramIdStr = String(myProgramId)
        if myProgramIdStr != "" {
            self.urlDetails = "https://totewallet.com/api/invest_user/\(myProgramIdStr)/show"
        }
        
        if self.productId != "" {
            self.urlReferral = "https://totewallet.com/platform/invest/\(self.productId ?? "")/register?phone=\(CoreDataService.getLogin()?.tel ?? "")"
        }
    }
}

extension LoyaltyProgram {
    
    func parse(loyaltyProgramObject: NSDictionary) {
        if let idTemp = loyaltyProgramObject["id"] as? Int64 {
            self.id = String(idTemp)
        }

        self.imageFile = loyaltyProgramObject["iconFile"] as? String
        self.name = loyaltyProgramObject["name"] as? String
        self.desc = loyaltyProgramObject["description"] as? String
        if let settingsPriceTemp = loyaltyProgramObject["settings.price"] as? Int64 {
            self.settingsPrice = String(settingsPriceTemp)
        }

        self.settingsDiscount = loyaltyProgramObject["settings.discount"] as? String
        self.productTypeName = loyaltyProgramObject["productType.name"] as? String
        self.priceMode = loyaltyProgramObject["priceMode"] as? String
        self.identifier = loyaltyProgramObject["identifier"] as? String
        
        switch self.name {
            
            case "Bronze":
                self.colorHex = "B1763A"
            break
            case "Silver":
                self.colorHex = "787878"

            case "Gold":
                self.colorHex = "C39D3D"

            case "Platinum":
                self.colorHex = "A9ADBA"

        default:
            self.colorHex = "787878"
            break
        }
    }
}

extension BuyTips {
    func parse(buyTipsObject: NSDictionary) {
        self.paymentUrl = buyTipsObject["paymentUrl"] as? String
        self.successUrl = buyTipsObject["successUrl"] as? String
        self.errorUrl = buyTipsObject["errorUrl"] as? String

    }
}

extension OzowFee {
    func parse(ozowFeeObject: NSDictionary) {
        self.ozowFees = ozowFeeObject["ozow_fee"] as? String
    }
}
