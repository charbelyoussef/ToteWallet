//
//  CustomPickerView.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/14/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class CustomPickerView: UIPickerView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().bgColor ?? "")
        setValue(UIColor.black, forKey: "textColor")
        autoresizingMask = .flexibleWidth
        contentMode = .center
        frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - Constants.UIElements.pickerHeight, width: UIScreen.main.bounds.size.width, height: Constants.UIElements.pickerHeight)
    }
}
