//
//  User.swift
//  EyeQLab
//
//  Created by Nadim Henoud on 5/1/19.
//  Copyright © 2019 OBSoft. All rights reserved.
//

import Foundation
import AuthenticationServices

extension Notification.Name {
    static let userChanged = Notification.Name("UserChanged")
    static let appVersionExpired = Notification.Name("AppVersionExpired")
    static let appVersionObsolete = Notification.Name("AppVersionObsolete")
}

class User:OBSRemoteData {
    static private var instance:User?;
    
    var pendingRequestIdStored:String?
    var sellProgramIdStored:String?
    
    static var shared:User{
        get {
            if instance==nil{
                instance=User()
            }
            return instance!
        }
    }
    var isLoggedIn:Bool {
        get {
            return OBSUser.shared.isLoggedIn
        }
    }
    
    var username:String!
    var appVersionStatus:Int!
    var firstName:String!
    var lastName:String!
    var email:String!
    var phone:String!
    var imageFile:String!
    var cvFile:String!
    var country:String!
    var address:String!
    var profileLevel:Int!
    var storedCountryId:Int64?
    
//    var university:University!
//    var degree:Degree!
//    var courses:[Course] {
//        get {
//            return CourseStore.shared.list(userOnly: true)
//        }
//    }
    
    public func login(countryCode:Int64, phoneNumber: String, password: String, delegate: OBSRemoteDataDelegate? = nil) {
        
        self.username = "\(countryCode)\(phoneNumber)"
//        OBSUser.shared.delegate = self.delegate
        OBSUser.shared.delegate = delegate
        OBSUser.shared.login(username: username, password: password)
        updateUserDefaults()
    }
    
    private func updateUserDefaults(){
        if UserDefaults.standard.string(forKey: "savedUsername") != self.username {
            NotificationCenter.default.post(name: .userChanged, object: self)
        }
        
        UserDefaults.standard.set(username, forKey: "savedUsername")
        UserDefaults.standard.synchronize()
    }
    
    public func register(delegate: OBSRemoteDataDelegate? = nil,
                         fName: String,
                         lName: String,
                         email: String,
                         phoneCountry:String,
                         phone: String,
                         password: String,
                         confirmPassword: String,
                         pinCode: String,
                         confirmPinCode: String){
        
        self.delegate = delegate
        var data : [String: String] = [:]
        data["form[firstName]"] = fName
        data["form[lastName]"] = lName
        data["form[email]"] = email
        data["form[phone][country]"] = phoneCountry
        data["form[phone][number]"] = phone
        data["form[plainPassword][first]"] = password
        data["form[plainPassword][second]"] = confirmPassword
        data["form[plainPinCode][first]"] = pinCode
        data["form[plainPinCode][second]"] = confirmPinCode

        self.postData(command: Config.registrationURL, data: data, headers: nil, useQueue: false)
    }

    public func register(delegate: OBSRemoteDataDelegate? = nil, data:[String:String]){
        self.delegate = delegate
        self.postData(command: Config.registrationURL, data: data, headers: nil, useQueue: false)
    }
    

    
    public func editProfile(delegate: OBSRemoteDataDelegate? = nil,
                            gender:String,
                            phoneCountry:String,
                            phoneNumber:String,
                            email:String,
                            city:String,
                            countryId:String,
                            imageFile:String,
                            idNumber:String,
                            idNationality:String,
                            idType:String,
                            address1:String,
                            address2:String,
                            address3:String,
                            address4:String,
                            profilePicFile:String,
                            firstname:String,
                            lastname:String,
                            roles:String,
                            birthdate:String,
                            image:UIImage?,
                            imageName:String,
                            idImage:UIImage?,
                            idImageName:String){
        
        self.delegate = delegate
        var data : [String: String] = [:]
//        data["form[details__idImageFile][file]"] = imageFile
//        data["form[details__idNationality]"] = idNationality
//        data["form[details__idType]"] = idType
//        data["form[profilePicFile][file]"] = image
//        data["form[roles][0]"] = roles
//        data["form[details__birthdate]"] = birthdate
        data["gender"] = gender
        data["phone][country"] = phoneCountry
        data["phone][number"] = phoneNumber
        data["email"] = email
        data["details__city"] = city
        data["details__country"] = countryId //"422"
        data["details__idNumber"] = idNumber
        data["details__address][line1"] = address1
        data["details__address][line2"] = address2
        data["details__address][line3"] = address3
        data["details__address][line4"] = address4
        data["firstName"] = firstname
        data["lastName"] = lastname

//        if let imageToUse = image, imageName != "" {
        let convertedParams = convertParametersToEncodable(data: data, image: image, imageName: imageName, idImage: idImage, idImageName: idImageName)
            updateProfile(delegate: delegate,data: convertedParams)
//        }
//        else{
//            self.postData(command: Config.editProfileUrl, data: data, headers: nil, useQueue: false)
//        }
    }
    
    public func updateProfile(delegate: OBSRemoteDataDelegate? = nil, data: [HTMLEncodable]) {
        self.delegate = delegate
        let d:[Any?] = data
//        if let _index = data.firstIndex(where: {$0.key == "profilePicFile][file"}) {
//            var _cv = data[_index]
//            _cv.key = "file"
//            d[_index] = ["profilePicFile][file":_cv.value]
//
//        }
        
        let _data = self.getBodyData(data: d)
        self.postData(command: Config.editProfileUrl, data: [:], headers: nil, raw: _data, useQueue: true)
    }
    
    func convertParametersToEncodable(data:[String: String], image:UIImage?, imageName:String, idImage:UIImage?, idImageName:String) -> [HTMLEncodable]{
        var encodableArray:[HTMLEncodable] = []
        
        for item in data {
            var _datum:HTMLEncodableData?=nil
            _datum = HTMLEncodableData(key: item.key, value: item.value)
            if _datum != nil {
                encodableArray.append(_datum!)
            }
        }
        
        if image != nil, imageName != "" {
            var _datum1:HTMLEncodableData?=nil
            let name = imageName.sha512().hexEncodedString()
            (image!).save(name)
            _datum1 = HTMLEncodableData(key: "profilePicFile][file", value: name, type: .imageJPG)
            if _datum1 != nil {
                encodableArray.append(_datum1!)
            }
        }
        
        if idImage != nil, idImageName != "" {
            var _datum1:HTMLEncodableData?=nil
            let name = idImageName.sha512().hexEncodedString()
            (idImage!).save(name)
//            form[details__idImageFile][file]
            _datum1 = HTMLEncodableData(key: "details__idImageFile][file", value: name, type: .imageJPG)
            if _datum1 != nil {
                encodableArray.append(_datum1!)
            }
        }
        
        return encodableArray
    }
    
    public func phoneVerification(delegate: OBSRemoteDataDelegate? = nil,
                                  token: String,
                                  phoneCountry:String,
                                  phone: String){
        
        self.delegate = delegate
        var data : [String: String] = [:]
        data["form[token]"] = token
        data["form[phone][country]"] = phoneCountry
        data["form[phone][number]"] = phone

        self.postData(command: Config.verifyPhoneUrl, data: data, headers: nil, useQueue: false)
    }
    
    public func emailVerification(delegate: OBSRemoteDataDelegate? = nil,
                                  token: String,
                                  email:String){
        
        self.delegate = delegate
        var data : [String: String] = [:]
        data["form[token]"] = token
        data["form[email]"] = email

        self.postData(command: Config.verifyEmailUrl, data: data, headers: nil, useQueue: false)
    }
    
    public func requestResetPassword(delegate: OBSRemoteDataDelegate? = nil, email: String){
        self.delegate = delegate
        
        if email != "" {
            var data : [String:String] = [:]
            data["form[email]"] = email
            self.postData(command: Config.requestResetPasswordURL, data: data, headers: nil, useQueue: false)
        }
        else{
            let data : [String:String] = [:]
            self.postData(command: Config.requestResetPasswordLoggedInURL, data: data, headers: nil, useQueue: false)
        }
    }
    
    public func requestResetPin(delegate: OBSRemoteDataDelegate? = nil){
        self.delegate = delegate
        let data : [String:String] = [:]
        self.postData(command: Config.requestResetPinURL, data: data, headers: nil, useQueue: false)
    }

    public func getProgramsList(delegate: OBSRemoteDataDelegate? = nil){
        self.delegate = delegate
        self.getData(command: Config.getProgramsUrl, headers: nil, useQueue: false)
    }
   
    public func getMyProgramsList(delegate: OBSRemoteDataDelegate? = nil){
        self.delegate = delegate
        self.getData(command: Config.getMyProgramsUrl, headers: nil, useQueue: false)
    }

    public func sellProgram(delegate: OBSRemoteDataDelegate? = nil, programId:String){
        self.delegate = delegate
        
        let data : [String: String] = [:]
        
        sellProgramIdStored = programId
        let url =  Config.sellProgramUrl.replacingOccurrences(of: "(id)", with: "\(programId)")
        self.postData(command: url, data: data, headers: nil, useQueue: false)
    }

    public func getLoyaltyPrograms(delegate: OBSRemoteDataDelegate? = nil){
        self.delegate = delegate
        self.getData(command: Config.getLoyaltyProgramsUrl, headers: nil, useQueue: false)
    }
    
    public func getAppConfiguration(delegate: OBSRemoteDataDelegate? = nil){
        self.delegate = delegate
        self.getData(command: Config.getAppConfigurationUrl, headers: nil, useQueue: false)
    }
    
    public func getCitiesForCountry(delegate: OBSRemoteDataDelegate? = nil, countryId:Int64){
        self.delegate = delegate
        
        storedCountryId = countryId
        let url =  Config.getCitiesUrl.replacingOccurrences(of: "(id)", with: "\(countryId)")
        self.getData(command: url, headers: nil, useQueue: false)
    }

    public func getWallets(delegate: OBSRemoteDataDelegate? = nil){
        self.delegate = delegate
        self.getData(command: Config.getWalletsUrl, headers: nil, useQueue: false)
    }
    
    public func getAlerts(delegate: OBSRemoteDataDelegate? = nil){
        self.delegate = delegate
        self.getData(command: Config.getAlertsUrl, headers: nil, useQueue: false)
    }
    
    public func getFaqs(delegate: OBSRemoteDataDelegate? = nil){
        self.delegate = delegate
        self.getData(command: Config.getFaqsUrl, headers: nil, useQueue: false)
    }

    public func getTransactionsWithFilter(delegate: OBSRemoteDataDelegate? = nil,
                                           senderCountryId:String,
                                           senderPhoneNumber:String,
                                           receiverCountryId:String,
                                           receiverPhoneNumber:String,
                                           fromDate:Date,
                                           toDate:Date){
        
        self.delegate = delegate
        
        var data : [String: String] = [:]
        data["fu_filter_tx[sender][country]"] = senderCountryId
        data["fu_filter_tx[sender][number]"] = senderPhoneNumber
        data["fu_filter_tx[receiver][country]"] = receiverCountryId
        data["fu_filter_tx[receiver][number]"] = receiverPhoneNumber
        data["fu_filter_tx[from]"] = fromDate.toString(format: "MMM dd, YYYY")
        data["fu_filter_tx[to]"] = toDate.toString(format: "MMM dd, YYYY")

        var url = "\(Config.getTransactionsUrl)?rsformat=1"
        for (key, value) in data {
            url.append("&" + key + "=" + value)
        }
        url = url.safeGetParams()
        self.getData(command: url.safeGetParams(), headers: nil, useQueue: false)
    }
    
    public func getTransactions(delegate: OBSRemoteDataDelegate? = nil){
        self.delegate = delegate
        self.getData(command: Config.getTransactionsUrl, headers: nil, useQueue: false)
    }
    
    public func getPendingRequestsWithFilter(delegate: OBSRemoteDataDelegate? = nil,
                                             senderCountryId:String,
                                             senderPhoneNumber:String,
                                             receiverCountryId:String,
                                             receiverPhoneNumber:String,
                                             fromDate:Date,
                                            toDate:Date){
        
        self.delegate = delegate
        
        var data : [String: String] = [:]
        data["fu_filter_tx[sender][country]"] = senderCountryId
        data["fu_filter_tx[sender][number]"] = senderPhoneNumber
        data["fu_filter_tx[receiver][country]"] = receiverCountryId
        data["fu_filter_tx[receiver][number]"] = receiverPhoneNumber
        data["fu_filter_tx[from]"] = fromDate.toString(format: "MMM dd, YYYY")
        data["fu_filter_tx[to]"] = toDate.toString(format: "MMM dd, YYYY")

        var url = "\(Config.getPendingRequestsUrl)?rsformat=1"
        for (key, value) in data {
            url.append("&" + key + "=" + value)
        }
        url = url.safeGetParams()
        self.getData(command: url.safeGetParams(), headers: nil, useQueue: false)
    }
    
    public func getPendingRequests(delegate: OBSRemoteDataDelegate? = nil){
        self.delegate = delegate
        self.getData(command: Config.getPendingRequestsUrl, headers: nil, useQueue: false)
    }
    
    public func cancelPendingRequest(delegate: OBSRemoteDataDelegate? = nil,
                                     id:String){
        self.delegate = delegate
        let data : [String: String] = [:]
        pendingRequestIdStored = id
        
        let url =  Config.cancelPendingRequestUrl.replacingOccurrences(of: "(id)", with: "\(id)")
        self.postData(command: url, data: data, headers: nil, useQueue: false)
    }
    
    public func cancelPendingRequest(delegate: OBSRemoteDataDelegate? = nil,
                                        id:String,
                                        senderWalletId: String,
                                        pinCode: String){
           self.delegate = delegate
           var data : [String: String] = [:]
           data["form[sender]"] = senderWalletId
           data["form[request_id]"] = id
           data["form[pinCode]"] = "\(pinCode)"
           
           pendingRequestIdStored = id
           let url =  Config.cancelPendingRequestUrl.replacingOccurrences(of: "(id)", with: "\(id)")
           self.postData(command: url, data: data, headers: nil, useQueue: false)
       }
    
    public func confirmPendingRequest(delegate: OBSRemoteDataDelegate? = nil,
                                      id:String,
                                      senderWalletId: String,
                                      pinCode: String){
        self.delegate = delegate
        var data : [String: String] = [:]
        data["form[sender]"] = senderWalletId
        data["form[request_id]"] = id
        data["form[pinCode]"] = "\(pinCode)"

        pendingRequestIdStored = id
        let url = Config.confirmPendingRequestUrl.replacingOccurrences(of: "(id)", with: "\(id)")

        self.postData(command: url, data: data, headers: nil, useQueue: false)
    }

    public func getProfileSettings(delegate: OBSRemoteDataDelegate? = nil){
        self.delegate = delegate
        self.getData(command: Config.profileSettings, headers: nil, useQueue: false)
    }
    
    public func getProfileDetails(delegate: OBSRemoteDataDelegate? = nil){
        self.delegate = delegate
        self.getData(command: Config.profileDetailsUrl, headers: nil, useQueue: false)
    }
    
    public func getOzowFees(delegate: OBSRemoteDataDelegate? = nil){
        self.delegate = delegate
        self.getData(command: Config.getOzowFees, headers: nil, useQueue: false)
    }

    public func register(delegate: OBSRemoteDataDelegate? = nil, params: [String: String]){
        self.delegate = delegate
        self.postData(command: Config.registrationURL, data: params, headers: nil, useQueue: false)
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
            
            let cancelPendingRequestUrl =  Config.cancelPendingRequestUrl.replacingOccurrences(of: "(id)", with: "\(pendingRequestIdStored ?? "N/A")")
            let confirmPendingRequestUrl =  Config.confirmPendingRequestUrl.replacingOccurrences(of: "(id)", with: "\(pendingRequestIdStored ?? "N/A")")
            let sellProgramUrl =  Config.sellProgramUrl.replacingOccurrences(of: "(id)", with: "\(sellProgramIdStored ?? "N/A")")

            
            if command.contains(Config.registrationURL) {
                self.delegate?.hasFinishedLoadingData(status: .didRegister, message: "")
                return
            }
            
            else if command.contains(Config.requestResetPasswordURL) {
                
                if data != nil {
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let message = responseDic["message"] as? String, message != "" {
                            self.delegate?.hasFinishedLoadingData(status: .didRequestPassReset, message: message)
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
            
            else if command.contains(Config.requestResetPasswordLoggedInURL) {
                
                if data != nil {
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let message = responseDic["message"] as? String, message != "" {
                            self.delegate?.hasFinishedLoadingData(status: .didRequestPassReset, message: message)
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
            
            else if command.contains(Config.requestResetPinURL) {
                
                if data != nil {
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let message = responseDic["message"] as? String, message != "" {
                            self.delegate?.hasFinishedLoadingData(status: .didRequestPinReset, message: message)
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
            
            else if command.contains(Config.profileSettings){
                if data != nil {
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataDict = responseDic["data"] as? NSDictionary {
                            let context = CoreDataManager.shared.context

                            let profileSettings = ProfileSettings(context: context)
                            profileSettings.parse(profileSettingsObject: dataDict)
                            CoreDataManager.shared.saveContext(context)
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
                
            else if command.contains(Config.editProfileUrl){
                if data != nil {
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataDict = responseDic["data"] as? NSDictionary {
                            let context = CoreDataManager.shared.context

                            if let profileDetails = CoreDataService.getLogin() {
                                profileDetails.parseProfileDetails(profileDetailsObject: dataDict)
                                CoreDataManager.shared.saveContext(context)
                            }
                        }
                        var messageToReturn = "Profile Updated Successfully"
                        
                        if let message = responseDic["message"] as? String, message != "" {
                            messageToReturn = message
                        }
                        self.delegate?.hasFinishedLoadingData(status: .updateProfileSucceeded, message: messageToReturn)
                    }
                    else{
                        self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Failed To Update Profile")
                    }
                }
                else{
                    self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Server Error: JSON Empty")
                }
            }
            
            else if command.contains(Config.getOzowFees){
                if data != nil {
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataDict = responseDic["data"] as? NSDictionary {
                            let context = CoreDataManager.shared.context

                            let ozowFee = OzowFee(context: context)
                            ozowFee.parse(ozowFeeObject: dataDict)
                            CoreDataManager.shared.saveContext(context)
                        }
                        self.delegate?.hasFinishedLoadingData(status: .ozowFeesFetchedSucceeded, message: "Data Loaded Successfully")
                    }
                    else{
                        self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Failed To Load Data")
                    }
                }
                else{
                    self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Server Error: JSON Empty")
                }
            }
                
            else if command.contains(Config.profileDetailsUrl){
                if data != nil {
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataDict = responseDic["data"] as? NSDictionary {
                            let context = CoreDataManager.shared.context

                            if let profileDetails = CoreDataService.getLogin() {
                                profileDetails.parseProfileDetails(profileDetailsObject: dataDict)
                                CoreDataManager.shared.saveContext(context)
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
                
            else if command.contains(Config.editProfileUrl){
                
            }
            
            else if command.contains(Config.verifyEmailUrl){
                
            }
                
            else if command.contains(Config.verifyPhoneUrl){
                
            }
                
            else if command.contains(Config.getWalletsUrl){
                if data != nil {                    
                    CoreDataService.clearWallets()
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataArray = responseDic["data"] as? NSArray {
                            for dataObj in dataArray {
                                
                                if let dataDict = dataObj as? NSDictionary {
                                    let context = CoreDataManager.shared.context

                                    let wallet = Wallet(context: context)
                                    wallet.parse(walletObject: dataDict)
                                    CoreDataManager.shared.saveContext(context)
                                }
                            }
                        }
                        self.delegate?.hasFinishedLoadingData(status: .walletsFetchSucceeded, message: "Wallets Loaded Successfully")
                    }
                    else{
                        self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Failed To Load Data")
                    }
                }
                else{
                    self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Server Error: JSON Empty")
                }
            }
                
            else if command.contains(Config.getAlertsUrl){
                if data != nil {
                    CoreDataService.clearAlerts()
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataArray = responseDic["data"] as? NSArray {
                            for dataObj in dataArray {
                                
                                if let dataDict = dataObj as? NSDictionary {
                                    let context = CoreDataManager.shared.context

                                    let alert = Alert(context: context)
                                    alert.parse(alertObject: dataDict)
                                    CoreDataManager.shared.saveContext(context)
                                }
                            }
                        }
                        self.delegate?.hasFinishedLoadingData(status: .HTTPSuccess, message: "Notifications Loaded Successfully")
                    }
                    else{
                        self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Failed To Load Data")
                    }
                }
                else{
                    self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Server Error: JSON Empty")
                }
            }
                
            else if command.contains(Config.getFaqsUrl){
                if data != nil {
                    CoreDataService.clearFaqs()
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataArray = responseDic["data"] as? NSArray {
                            for dataObj in dataArray {
                                
                                if let dataDict = dataObj as? NSDictionary {
                                    let context = CoreDataManager.shared.context

                                    let faq = Faq(context: context)
                                    faq.parse(faqObject: dataDict)
                                    CoreDataManager.shared.saveContext(context)
                                }
                            }
                        }
                        self.delegate?.hasFinishedLoadingData(status: .HTTPSuccess, message: "Notifications Loaded Successfully")
                    }
                    else{
                        self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Failed To Load Data")
                    }
                }
                else{
                    self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Server Error: JSON Empty")
                }
            }
            
            else if command.contains(Config.getProgramsUrl){
                if data != nil {
                    CoreDataService.clearPrograms()
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataArray = responseDic["data"] as? NSArray {
                            for dataObj in dataArray {
                                
                                if let dataDict = dataObj as? NSDictionary {
                                    let context = CoreDataManager.shared.context

                                    let program = Program(context: context)
                                    program.parse(programObject: dataDict)
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
                
            else if command.contains(Config.getMyProgramsUrl){
                if data != nil {
                    CoreDataService.clearMyPrograms()
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataObject = responseDic["data"] as? NSDictionary, let assetsArray = dataObject["assets"] as? NSArray {
                            for assetObj in assetsArray {
                                
                                if let assetDict = assetObj as? NSDictionary {
                                    let context = CoreDataManager.shared.context
                                    
                                    if let status = assetDict["status"] as? String, status != "Accepted"{
                                        let myProgram = MyProgram(context: context)
                                        myProgram.parse(myProgramObject: assetDict)
                                        CoreDataManager.shared.saveContext(context)
                                    }
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
            
            else if command.contains(sellProgramUrl){
                if data != nil {
                    let responseDic = parseJSON(data: data!)!

                    if let success = responseDic["success"] as? Bool, success {
                        if let dataObject = responseDic["data"] as? NSDictionary{

                        }
                        self.delegate?.hasFinishedLoadingData(status: .programSellRequestSucceeded, message: "Data Loaded Successfully")
                    }
                    else{
                        self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Failed To Load Data")
                    }
                }
                else{
                    self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Server Error: JSON Empty")
                }
            }
               
            else if command.contains(Config.getLoyaltyProgramsUrl){
                if data != nil {
                    CoreDataService.clearLoyaltyPrograms()
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataArray = responseDic["data"] as? NSArray {
                            for dataObj in dataArray {
                                
                                if let dataDict = dataObj as? NSDictionary {
                                    let context = CoreDataManager.shared.context

                                    let loyaltyProgram = LoyaltyProgram(context: context)
                                    loyaltyProgram.parse(loyaltyProgramObject: dataDict)
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
            
            else if command.contains(Config.getTransactionsUrl){
                if data != nil {
                    CoreDataService.clearTransactions()
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataArray = responseDic["data"] as? NSArray {
                            for dataObj in dataArray {
                                
                                if let dataDict = dataObj as? NSDictionary {
                                    let context = CoreDataManager.shared.context

                                    let transaction = Transaction(context: context)
                                    transaction.parse(transactionObject: dataDict)
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
            
            else if command.contains(Config.getPendingRequestsUrl){
                if data != nil {
                    CoreDataService.clearPendingRequests()
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let dataArray = responseDic["data"] as? NSArray {
                            for dataObj in dataArray {
                                
                                if let dataDict = dataObj as? NSDictionary {
                                    let context = CoreDataManager.shared.context

                                    let pendingRequest = PendingRequest(context: context)
                                    pendingRequest.parse(pendingRequestObject: dataDict)
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
            
            else if command.contains(cancelPendingRequestUrl) {
                
                if data != nil {
                    CoreDataService.clearPendingRequests()
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let message = responseDic["message"] as? String, message != "" {
                            self.delegate?.hasFinishedLoadingData(status: .didCancelPendingRequest, message: message)
                        }
                        else {
                            self.delegate?.hasFinishedLoadingData(status: .didCancelPendingRequest, message: "Pending Request Canceled")
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
            
            else if command.contains(confirmPendingRequestUrl) {
                
                if data != nil {
                    CoreDataService.clearPendingRequests()
                    let responseDic = parseJSON(data: data!)!
                    
                    if let success = responseDic["success"] as? Bool, success {
                        if let message = responseDic["message"] as? String, message != "" {
                            self.delegate?.hasFinishedLoadingData(status: .didConfirmPendingRequest, message: message)
                        }
                        else {
                            self.delegate?.hasFinishedLoadingData(status: .didConfirmPendingRequest, message: "Pending Request Confirmed")
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
            let getCitiesUrl =  Config.getCitiesUrl.replacingOccurrences(of: "(id)", with: "\(storedCountryId ?? -1)")

            if command.contains(Config.registrationURL){
                self.delegate?.hasFinishedLoadingData(status: .didNotRegister, message: jsonResponse["message"] as? String ?? "")
            }
            
            else if command.contains(Config.getAppConfigurationUrl) {
                if data != nil {
                    CoreDataService.clearCountries()
                    CoreDataService.clearAppConfiguration()
                    let responseDic = parseJSON(data: data!)!
                    
                    if let dataArray = responseDic["countries"] as? NSArray, dataArray.count > 0, let countryData = responseDic["country"] as? NSDictionary {
                        for dataObj in dataArray {
                            
                            if let dataDict = dataObj as? NSDictionary {
                                let context = CoreDataManager.shared.context

                                let country = Country(context: context)
                                country.parse(countryObject: dataDict)
                                CoreDataManager.shared.saveContext(context)
                            }
                        }
                        
                        let context = CoreDataManager.shared.context

                        let configuration = AppConfiguration(context: context)
                        configuration.parse(countryObject: countryData)
                        CoreDataManager.shared.saveContext(context)

                        
                        self.delegate?.hasFinishedLoadingData(status: .configurationFetchSucceeded, message: "Configuration Loaded Successfully")
                    }
                    else{
                        self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Failed To Load Data")
                    }
                }
            }
            
            else if command.contains(getCitiesUrl) {
                if data != nil {
                    CoreDataService.clearCities()
                    let responseDic = parseJSON(data: data!)!
                    
                    if let dataArray = responseDic["cities"] as? NSArray, dataArray.count > 0 {
                        for dataObj in dataArray {
                            
                            if let dataDict = dataObj as? NSDictionary {
                                let context = CoreDataManager.shared.context

                                let city = City(context: context)
                                city.parse(countryObject: dataDict)
                                CoreDataManager.shared.saveContext(context)
                            }
                        }
                        self.delegate?.hasFinishedLoadingData(status: .citiesFetchSucceeded, message: "Cities Loaded Successfully")
                    }
                    else{
                        self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: "Failed To Load Data")
                    }
                }
            }
            else{
                self.delegate?.hasFinishedLoadingData(status: .didNotLoadRemoteData, message: jsonResponse["message"] as? String ?? "Error occured! Please try again later.")
            }
        }
    }
    
//    func resetCourses() {
//        for course in CourseStore.shared.list(userOnly: true) {
//            course.cd.registered = false
//        }
//    }
}

extension OBSRemoteDataStatus.Name{
    static let didRegister = OBSRemoteDataStatus.Name("didRegister")
    static let didNotRegister = OBSRemoteDataStatus.Name("didNotRegister")
    static let didRequestPassReset = OBSRemoteDataStatus.Name("passReset")
    static let didRequestPinReset = OBSRemoteDataStatus.Name("pinReset")
    static let didCancelPendingRequest = OBSRemoteDataStatus.Name("didCancelPendingRequest")
    static let didConfirmPendingRequest = OBSRemoteDataStatus.Name("didConfirmPendingRequest")
    static let didLoadProfile = OBSRemoteDataStatus.Name("didLoadProfile")
}
