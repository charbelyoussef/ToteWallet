//
//  CustomCheckBox.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/23/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//


import UIKit

@objc protocol CustomCheckBoxDelegate {
    @objc optional func checkBoxChanged(checkBox: CustomCheckBox, checked: Bool)
}

class CustomCheckBox: UIButton {
    
    var delegate:CustomCheckBoxDelegate?
    
    var selectedBGColor:UIColor?
    var deselectedBGColor:UIColor?
    var checkColor:UIColor?
    
    let checkImage = UIImage(named: "check")?.withRenderingMode(.alwaysTemplate)
    
    var isCheckSelected = false {
        didSet {
            setupDesign(animated: false)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setup(selectedBGColor:UIColor, deselectedBGColor: UIColor, checkColor:UIColor, borderColor: UIColor?, selected:Bool) {
        self.selectedBGColor = selectedBGColor
        self.deselectedBGColor = deselectedBGColor
        self.checkColor = checkColor
        self.isCheckSelected = selected
        self.setImage(checkImage, for: .normal)
        self.layer.borderColor = borderColor?.cgColor
        self.showsTouchWhenHighlighted = false
        self.adjustsImageWhenHighlighted = false
        if borderColor != nil {
            self.layer.borderWidth = 1.5
        }
        self.removeTarget(nil, action: nil, for: .allEvents)
        self.addTarget(self, action: #selector(changeStatus), for: .touchUpInside)
        
        self.setupDesign(animated: false)
    }
    
    @objc func changeStatus() {
        self.isCheckSelected = !self.isCheckSelected
        
        self.setupDesign(animated: true)
    }
    
    func setSelected(selected: Bool) {
        self.isCheckSelected = selected
        setupDesign(animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDesign(animated: false)
    }
    
    fileprivate func setupDesign(animated: Bool) {
        self.layer.cornerRadius = 2.5
        self.clipsToBounds = true
        let duration = animated ? 0.1 : 0
        
        UIView.animate(withDuration: duration, animations: {
            self.imageView?.alpha = CGFloat(truncating: NSNumber(value: self.isCheckSelected))
            self.tintColor = self.checkColor
            self.backgroundColor = self.isCheckSelected ? self.selectedBGColor : self.deselectedBGColor
        }) { (bool) in
            self.delegate?.checkBoxChanged?(checkBox: self, checked: self.isCheckSelected)
        }
    }
}
