//
//  CustomContainer.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/10/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

@IBDesignable

class CustomContainerView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()

        addCornerRadius(corners: [.topLeft, .topRight], cornerRadius: 20)
        clipsToBounds = true
    }

}

class CustomTextFieldContainerView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor =  isUserInteractionEnabled ? .clear : UIColor(hexString: ConfigurationManager.getAppConfiguration().readOnlyBackgroundColor ?? "")
        addCornerRadius(corners: .allCorners, cornerRadius: frame.size.height/2)
        clipsToBounds = true
    }

}

class CustomPhoneNumberContainerView :UIView {
    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = .clear
        layer.borderColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().textFieldsBorderColor ?? "").cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = frame.size.height/2
    }

}
