//
//  OBSPush.swift
//  lacpa
//
//  Created by Obsoft on 3/22/19.
//  Copyright © 2019 OBSoft. All rights reserved.
//

import UIKit
import UserNotifications

extension Notification.Name {
    static let remoteNotificationPermissionChanged = Notification.Name("RemoteNotificationPermissionChanged")
}

class OBSPush: NSObject, UNUserNotificationCenterDelegate {
    static private var instance:OBSPush?;
    static var shared:OBSPush{
        get {
            if instance==nil{
                instance=OBSPush()
            }
            return instance!
        }
    }
    var status:UNAuthorizationStatus = .notDetermined
    var registered:Bool = false
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) {
            granted, error in
            print("Permission granted: \(granted)")
            guard granted else {
                self.status = .denied
                NotificationCenter.default.post(name: .remoteNotificationPermissionChanged, object: self.status)
                return
            }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            self.status = settings.authorizationStatus
            NotificationCenter.default.post(name: .remoteNotificationPermissionChanged, object: self.status)
            guard settings.authorizationStatus == .authorized else { return }
            if !self.registered {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
}
