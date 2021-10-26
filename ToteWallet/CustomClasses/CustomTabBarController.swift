//
//  CustomTabBarController.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/13/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    static var indexToOpen = Enums.TabBarSections.Home.rawValue
    static var subIndexToOpen = Enums.HomeSubSection.Home.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().bgColor ?? "")
        tabBar.tintColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().bgColor ?? "")

        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()

        delegate = self
    }
    
}

extension CustomTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
          return false // Make sure you want this as false
        }

        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.4, options: [.transitionFlipFromRight], completion: nil)
        }

        return true
    }
}
