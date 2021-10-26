//
//  WSSE.swift
//  platea
//
//  Created by Nadim Henoud on 4/2/16.
//  Copyright © 2016 OBSoft. All rights reserved.
//

import Foundation

class OBSWSSE {
    var username = ""
    var token = ""
    let dateFormatter = Config.serverDf
    
    convenience init(user: String, token: String)
    {
        self.init()
        self.username = user
        self.token = token
    }
    
    func generateToken(user: String, token: String) -> String
    {
        self.username = user
        self.token = token
        return generateToken()
    }
    
    func generateToken() -> String
    {
        let created = dateFormatter.string(from: Date())
        let nonce = "OBS\(Int(Date().timeIntervalSince1970))\(Int(Date().timeIntervalSince1970))"
        var digest = "\(nonce)\(created)\(self.token)"
        digest = digest.sha512().base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        let wsse = "UsernameToken Username=\"\(self.username)\", PasswordDigest=\"\(digest)\", Nonce=\"\(nonce)\", Created=\"\(created)\""
        print("WSSE TOKEN : \(wsse)")
        return wsse
    }
    
    func generateToken(user: String, token: String, nonce: String, created: String) -> String {
        self.username = user
        self.token = token
        var digest = "\(nonce)\(created)\(self.token)"
        print("digest: \(digest)")
        digest = digest.sha512().base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        return "UsernameToken Username=\"\(self.username)\", PasswordDigest=\"\(digest)\", Nonce=\"\(nonce)\", Created=\"\(created)\""
    }
    
}
