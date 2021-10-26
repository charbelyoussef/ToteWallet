//
//  OBSReachability.swift
//  EyeQLab
//
//  Created by Nadim Henoud on 8/7/19.
//  Copyright © 2019 OBSoft. All rights reserved.
//

import Foundation

class OBSReachability {
    static private var instance:OBSReachability?=nil
    
    static var shared:OBSReachability?{
        get {
            if instance == nil {
                OBSReachability.initialize()
            }
            return instance
        }
    }
    
    let reachability:Reachability?
    
    init(hostname:String) {
        do {
            reachability = try Reachability(hostname: hostname)
        } catch {
            reachability = nil
            print(error)
        }
    }
    
    static func initialize(hostname:String="www.ob-soft.com") {
        instance = OBSReachability(hostname: hostname)
    }
}
