//
//  CustomSlider.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 1/22/21.
//  Copyright © 2021 Charbel Youssef. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {
    var thumbTextLabel: UILabel = UILabel()
    private let thumbWidth: Float = 40
    lazy var startingOffset: Float = 0 - (thumbWidth / 2)
    lazy var endingOffset: Float = thumbWidth

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(thumbTextLabel)
        thumbTextLabel.textAlignment = .center
        thumbTextLabel.layer.zPosition = layer.zPosition + 1
    }

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY-7.5)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 15))
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let xTranslation =  startingOffset + (minimumValue + endingOffset) / maximumValue * value
        return super.thumbRect(forBounds: bounds, trackRect: rect.applying(CGAffineTransform(translationX: CGFloat(xTranslation), y: 0)), value: value)
    }

    private var thumbFrame: CGRect {
        return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        thumbTextLabel.frame = thumbFrame
        thumbTextLabel.textColor = .white
        thumbTextLabel.font = UIFont.systemFont(ofSize: 11.0)
        thumbTextLabel.text = "\(value.cleanValue)%"
    }

}
