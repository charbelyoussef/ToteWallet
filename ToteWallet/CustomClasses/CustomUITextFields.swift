//
//  CustomTextField.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/10/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

@IBDesignable

class CustomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        backgroundColor =  isUserInteractionEnabled ? .clear : UIColor(hexString: ConfigurationManager.getAppConfiguration().readOnlyBackgroundColor ?? "")
        layer.borderColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().textFieldsBorderColor ?? "").cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = frame.size.height/2
        
        setPadding(left: 10.0, right: 10.0)
    }
}
