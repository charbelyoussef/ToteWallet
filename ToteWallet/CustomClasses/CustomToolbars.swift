//
//  CustomToolbars.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/19/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class CustomPickerToolbar: UIToolbar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - Constants.UIElements.pickerHeight, width: UIScreen.main.bounds.size.width, height: Constants.UIElements.pickerToolbarHeight)
        barStyle = .default
    }

}
