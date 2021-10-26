//
//  ProgramsVCDefaultCell.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 11/3/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

enum Sections:Int {
    case Livestock
    case PricklyPears
    case Pomegranate
}

class ProgramsVCDefaultCell: UITableViewCell {

    @IBOutlet weak var vContainer: UIView!
    
    

    //Top Layer Outlets
    @IBOutlet weak var vTopLayer: UIView!
    @IBOutlet weak var vTopInner: UIView!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGet: UILabel!
    @IBOutlet weak var lblGrow: UILabel!
    @IBOutlet weak var lblGain: UILabel!
    @IBOutlet weak var lblClickForMore: UILabel!
    @IBOutlet weak var lblRemainingAssets: UILabel!
    @IBOutlet weak var sldrRemainingAssets: UISlider!
    @IBOutlet weak var btnBuyAsset: UIButton!
    @IBOutlet weak var lblRemainingAssetsValue: UILabel!
    
    //Bottom Layer Outlets
    @IBOutlet weak var vBottomLayer: UIView!
    @IBOutlet weak var vBottomInner: UIView!
    @IBOutlet weak var ivIcon1: UIImageView!
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblCostPerAssetValue: UILabel!
    @IBOutlet weak var lblAssetsAvailabilityValue: UILabel!
    @IBOutlet weak var lblTotalProfitValue: UILabel!
    @IBOutlet weak var lblLifeExpectancyValue: UILabel!
    @IBOutlet weak var btnMoreDetails: UIButton!

    var isFlipped = false

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
//        sldrRemainingAssets.addTarget(self, action: #selector(self.flipCardAction(_:)), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(indexPath:IndexPath, programObject: Program?){
        sldrRemainingAssets.value = programObject?.percentage ?? 0

        ConfigurationManager.setSecondaryLighterThemeBGColorForViews(views: [btnBuyAsset])
        vContainer.layer.cornerRadius = 10
        lblGet.layer.cornerRadius = lblGet.frame.size.height/2
        lblGet.layer.borderWidth = 1
        lblGet.layer.borderColor = UIColor.white.cgColor
        
        lblGrow.layer.cornerRadius = lblGrow.frame.size.height/2
        lblGrow.layer.borderWidth = 1
        lblGrow.layer.borderColor = UIColor.white.cgColor

        lblGain.layer.cornerRadius = lblGain.frame.size.height/2
        lblGain.layer.borderWidth = 1
        lblGain.layer.borderColor = UIColor.white.cgColor

        let tapGetGrowGrainTop = UITapGestureRecognizer(target: self, action: #selector(self.flipCardAction(_:)))
        vTopLayer.addGestureRecognizer(tapGetGrowGrainTop)

        let tapGetGrowGrainBottom = UITapGestureRecognizer(target: self, action: #selector(self.flipCardAction(_:)))
        vBottomLayer.addGestureRecognizer(tapGetGrowGrainBottom)

        if let iconUrl = programObject?.iconFile {
            ivIcon.sd_setImage(with: URL(string: ("\(Constants.urlPrefix)\(iconUrl)").safeURL()))
        }
        else {
            ivIcon.image = UIImage(named: ConfigurationManager.getAppConfiguration().defaultLogoImageName ?? "")
        }
        
        if let iconUrl1 = programObject?.iconFile {
            ivIcon1.sd_setImage(with: URL(string: ("\(Constants.urlPrefix)\(iconUrl1)").safeURL()))
        }
        else {
            ivIcon1.image = UIImage(named: ConfigurationManager.getAppConfiguration().defaultLogoImageName ?? "")
        }
        
        if let imageUrl = programObject?.imageFile {
            ivImage.sd_setImage(with: URL(string: ("\(Constants.urlPrefix)\(imageUrl)").safeURL()))
        }
        else {
            ivImage.image = UIImage(named: ConfigurationManager.getAppConfiguration().defaultLogoImageName ?? "")
        }
        
       
        sldrRemainingAssets.minimumTrackTintColor = UIColor(hex: "609821")
        sldrRemainingAssets.maximumTrackTintColor = UIColor(hex: "C6992D")
        sldrRemainingAssets.setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        
        lblTitle.text = programObject?.name
        lblTitle1.text = programObject?.name
        
        lblRemainingAssetsValue.text = programObject?.stock
        lblGet.text = "get \n \(programObject?.settingsPrice ?? "N/A")"
        lblGrow.text = "grow \n \(programObject?.grow ?? "N/A")"
        lblGain.text = "gain \n \(programObject?.gain ?? "N/A")"

        lblCostPerAssetValue.text = "\(programObject?.settingsPrice ?? "N/A") TIPs"
        lblAssetsAvailabilityValue.text = "\(programObject?.stock ?? "N/A")"
        lblTotalProfitValue.text = "\(programObject?.gain ?? "N/A") TIPs"
        lblLifeExpectancyValue.text = "\(programObject?.grow ?? "N/A") Years"
    }
    
    @objc func sliderValueChanged(_ sender: UISlider? = nil) {
        print("\(sender?.value ?? 1)")
    }

    @objc func flipCardAction(_ sender: UITapGestureRecognizer? = nil) {
        guard let displayView = isFlipped ? vTopLayer : vBottomLayer else { return }
        guard let hiddenView = !isFlipped ? vTopLayer : vBottomLayer else { return }

        UIView.transition(with: contentView, duration: 1.0,
                          options: isFlipped ? .transitionFlipFromLeft : .transitionFlipFromRight,
                          animations: { () -> Void in
                            displayView.isHidden = false
                            hiddenView.isHidden = true
//                            self.contentView.insertSubview(displayView, at: 100)
//                            self.setNeedsLayout()
//                            self.layoutIfNeeded()
                          }, completion: nil)

        isFlipped = !isFlipped
    }
}
