//
//  CustomCollectionViews.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/16/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class CustomCV: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        setCollectionViewLayout(layout, animated: true)
    }
    
}
