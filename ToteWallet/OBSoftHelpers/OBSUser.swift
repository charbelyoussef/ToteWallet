//
//  User.swift
//  EOMP
//
//  Created by OB Soft on 2/16/18.
//  Copyright © 2018 Obsoft. All rights reserved.
//

import UIKit

extension OBSRemoteDataStatus.Name {
    static let loginSuccess = OBSRemoteDataStatus.Name("loginSuccess")
    static let loginFailed = OBSRemoteDataStatus.Name("loginFailed")
    static let versionOutdated = OBSRemoteDataStatus.Name("versionOutdated")
    static let versionUptodate = OBSRemoteDataStatus.Name("versionUptodate")
    static let updateProfileSucceeded = OBSRemoteDataStatus.Name("updateProfileSucceeded")
    static let configurationFetchSucceeded = OBSRemoteDataStatus.Name("configurationFetchSucceeded")
    static let citiesFetchSucceeded = OBSRemoteDataStatus.Name("citiesFetchSucceeded")
    static let walletsFetchSucceeded = OBSRemoteDataStatus.Name("walletsFetchSucceeded")
    static let programSellRequestSucceeded = OBSRemoteDataStatus.Name("programSellRequestSucceeded")
    static let ozowFeesFetchedSucceeded = OBSRemoteDataStatus.Name("ozowFeesFetchedSucceeded")
    static let idFetchFailure = OBSRemoteDataStatus.Name("idFetchFailure")
}

class OBSUser: OBSRemoteData {
    static private var instance:OBSUser?;
    var wsse:OBSWSSE!
    
    var username:String="";
    var password:String="";
    var deviceId:String=UIDevice.current.identifierForVendor!.uuidString;
    var isLoggedIn=false;
    var roles:[String]=[];
    
    static var shared:OBSUser{
        get {
            if instance==nil{
                instance=OBSUser()
            }
            return instance!
        }
    }
    
    override init() {
        super.init()
        
        if(Config.enableAutoLogin) {
            let wsseId = UserDefaults.standard.string(forKey: "savedUserId")
            let wsseToken = UserDefaults.standard.string(forKey: "savedUserToken")
            if wsseId != nil && wsseToken != nil {
                self.isLoggedIn = true
                self.wsse = OBSWSSE(user: wsseId!, token: wsseToken!);
                if(Config.registerForPushAfterLogin) {
                    OBSPush.shared.registerForPushNotifications()
                }
            }
        }
        self.useQueue = false
    }
    
    convenience init(username:String, password:String) {
        self.init()
        self.username = username
        self.password = password
    }
    
    static func getInstance() -> OBSUser {
        if(self.instance == nil) {
            self.instance = OBSUser();
        }
        return instance!;
    }
    
    func login(username: String, password: String) {
        var data : [String: String] = [:]
        data["deviceID"] = self.deviceId
        data["deviceType"] = "iOS"
        data["username"] = username
        data["password"] = password
        OBSRequestStore.shared.clean()
        self.wsse = nil
        self.postData(command: Config.loginUrl, data: data, headers:nil, useQueue: false)
    }
    
    func logout() {
        UserDefaults.standard.set(nil, forKey: "savedUserId")
        UserDefaults.standard.set(nil, forKey: "savedUserToken")
        self.isLoggedIn = false
        wsse = nil
        NotificationCenter.default.post(name: .userLoggedOut, object: nil, userInfo: nil)
    }
    
    func checkVersion(){
        self.getData(command: Config.versionCheckURL, headers: nil, useQueue: false)
    }
    
    func verifyAutoLogin(){
        self.getData(command: Config.loginCheckURL, headers: nil, useQueue: false)
    }
    
    func registerForPushNotification(deviceToken:Data){
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        var data : [String: String] = [:]
        data["deviceId"] = self.deviceId
        data["deviceType"] = "iOS"
        data["deviceToken"] = token
        data["format"] = "json"
        self.postData(command: Config.registerPushURL, data: data, headers: nil, useQueue: false)
    }
    
    override func parseError(response: URLResponse?, error: Error?, command : String) {
        if response != nil && (response as! HTTPURLResponse).statusCode == 403 || (response as! HTTPURLResponse).statusCode == 401 {
            self.isLoggedIn = false;
            self.wsse = nil
            self.delegate?.hasFinishedLoadingData(status: .loginFailed, message: "Wrong Username/Password")
            return
        }
        self.delegate?.hasFinishedLoadingData(status: .loginFailed, message: "Wrong Username/Password")
    }
    
    public func parseLoginResponse(data: Data!) -> Bool{
        if data != nil {
            let item = parseJSON(data: data!)!
            if item["id"] != nil {
                //let data = item["data"] as! [String: Any]
                let id = item["id"] as! String
                let token = item["token"] as! String
                let user = item["user"] as! [String: Any]
//                self.username = user["email"] as! String
                
                if let countryCode = user["country"] as? String, let phoneNumber = user["number"] as? String {
                    self.username = "\(countryCode)\(phoneNumber)"
                }
                if let dataObj = item["user"] as? NSDictionary{
                    let context = CoreDataManager.shared.context

                    if let id = item["id"] as? String, let wsse = item["wsse"] as? String {
                        let login = Login(context: context)
                        login.parse(id: id, wsse: wsse, loginObject: dataObj)
                        CoreDataManager.shared.saveContext(context)
                    }
                }

                self.wsse = OBSWSSE(user: id, token: token)
                self.isLoggedIn = true
                if(Config.enableAutoLogin) {
                    UserDefaults.standard.set(id, forKey: "savedUserId")
                    UserDefaults.standard.set(token, forKey: "savedUserToken")
                    UserDefaults.standard.synchronize()
                }
                if(Config.registerForPushAfterLogin) {
                    OBSPush.shared.registerForPushNotifications()
                }

            } else {
                self.isLoggedIn = false
            }
        }
        return self.isLoggedIn
    }
    
    override func parseResponse(data: Data?, response: URLResponse?, error: Error?, command: String) {
        //Login
        if command.contains(Config.loginUrl) {
            if parseLoginResponse(data: data) {
                self.delegate?.hasFinishedLoadingData(status: .loginSuccess, message: "Logged In")
            }else{
                self.delegate?.hasFinishedLoadingData(status: .loginFailed, message: "Wrong Username/Password")
            }
        }
        // Version Check
        else if command.contains(Config.versionCheckURL) {
            let urlContents = try! String(contentsOf: URL(string: "\(Config.serverAPIURL)\(command)")!, encoding: String.Encoding.utf8)
            if urlContents != Config.appVersion {
                self.delegate?.hasFinishedLoadingData(status: .versionOutdated, message: "")
            } else {
                self.delegate?.hasFinishedLoadingData(status: .versionUptodate, message: "")
            }
        }
        //Verify Auto Login
        else if command.contains(Config.loginCheckURL) {
            if (response as? HTTPURLResponse)!.statusCode == 403 || (response as! HTTPURLResponse).statusCode == 401 || (response as? HTTPURLResponse)!.statusCode == 500 {
                self.isLoggedIn = false;
                self.wsse = nil
                self.delegate?.hasFinishedLoadingData(status: .loginFailed, message: "User Not Found")
                return
            }
            if data != nil {
                let items = parseJSON(data: data!)!
                if let status = items["status"] {
                    if (status as? Int) == 200 {
                        self.isLoggedIn = true
                        self.delegate?.hasFinishedLoadingData(status: .loginSuccess, message: "Logged In")
                    } else {
                        self.isLoggedIn = false
                        self.wsse = nil
                        self.delegate?.hasFinishedLoadingData(status: .loginFailed, message: "User Not Found")
                    }
                } else {
                    self.isLoggedIn = false
                    self.wsse = nil
                    self.delegate?.hasFinishedLoadingData(status: .loginFailed, message: "User Not Found")
                }
            }
        }else if command.contains(Config.registerPushURL) {
            let items = parseJSON(data: data!)!
            print("notifications parse: \(items)")
        }
    }
    
}

extension Notification.Name{
    static let userLoggedOut = Notification.Name("userLoggedOut")
}
