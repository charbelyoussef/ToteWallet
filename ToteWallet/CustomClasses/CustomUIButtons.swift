//
//  RoundedButton.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/1/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

@IBDesignable

class RoundedButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let radius = min(bounds.width, bounds.height) / 2
        layer.cornerRadius = radius
//        backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHex ?? "")
    }
    
}

@IBDesignable

class CustomSelectionButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            
            let radius = min(bounds.width, bounds.height) / 2
            layer.cornerRadius = radius
            layer.borderWidth = 1.0
            layer.borderColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().textFieldsBorderColor ?? "").cgColor
            setImage(UIImage(named: "arrow-down"), for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: 10, left: (bounds.width - 25), bottom: 10, right: 10)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
}

@IBDesignable

class CustomSelectionButtonWithRightArrow: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            
            let radius = min(bounds.width, bounds.height) / 2
            layer.cornerRadius = radius
            layer.borderWidth = 1.0
            layer.borderColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().textFieldsBorderColor ?? "").cgColor
            setImage(UIImage(named: "arrow-right"), for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: 10, left: (bounds.width - 25), bottom: 10, right: 10)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: (imageView?.frame.width)!)
        }
    }

}
