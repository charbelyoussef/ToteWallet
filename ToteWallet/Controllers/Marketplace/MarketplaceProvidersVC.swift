//
//  ViewController.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit


class MarketplaceProvidersVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: Class Outlets
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var cvContent: UICollectionView!
    
    // MARK: Class Variables
    var contentArray = NSMutableArray()
    var providers = [MarketplaceProvider]()
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        showProgressBar()
        MarketplaceStore.shared.getProviders(delegate: self)
        registerForKeyboardNotifications()
        setupDismissOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "marketplaceProvidersToCategories" {
            let vc = segue.destination as? MarketplaceCategoriesVC
            if vc != nil{
                if let indexPath = cvContent.indexPathsForSelectedItems?[0]{
                    // set presented view controller data
                    vc?.providerId = Int(providers[indexPath.item].id)
                    vc?.providerName = providers[indexPath.item].name ?? "N/A"
                }
            }
        }
        else if segue.identifier == "marketplaceProvidersToProducts" {
            let vc = segue.destination as? MarketplaceProductsVC
            if vc != nil{
                if let indexPath = cvContent.indexPathsForSelectedItems?[0]{
                    // set presented view controller data
                    vc?.categoryName = providers[indexPath.item].name
                    vc?.categoryId = Int(providers[indexPath.item].id)
                }
            }
        }
    }
    
    // MARK: UICollectionView Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
        //        let heightPerItem = widthPerItem

        return CGSize(width:widthPerItem, height:125)
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return providers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketplaceProvidersVCDefaultCell", for: indexPath as IndexPath) as! MarketplaceProvidersVCDefaultCell
        
        cell.configureCell(provider: providers[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let provider = providers[indexPath.item]
        if provider.hasChildren {
            performSegueIfPossible(identifier: "marketplaceProvidersToCategories")
        }
        else{
            performSegueIfPossible(identifier: "marketplaceProvidersToProducts")
        }
    }
    
    // MARK: Button Handlers
    @IBAction func btnBuyTipsAction(_ sender: Any) {

    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        revealMenu()
    }

    @IBAction func btnCloseAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//An extension for Requests
extension MarketplaceProvidersVC : OBSRemoteDataDelegate {
    
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        if status == .HTTPSuccess {
            hideProgressBar()
            providers = CoreDataService.getMarketPlaceProviders()
            
            if providers.count == 0 {
                showAlertWithCompletion(message: "No Data Found!", okTitle: "Ok", cancelTitle: "") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else{
                cvContent.reloadData()
            }
        }
    }
    
    func hasFinishedLoadingDataWithError(error: Error?) {
        
    }

}
