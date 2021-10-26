//
//  ViewController.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class MarketplaceProductsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    //        btnNotifications.setup(selectedBGColor: configColor, deselectedBGColor: UIColor.white, checkColor: UIColor.white, borderColor: configColor, selected: false)

    // MARK: Class Outlets
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var cvContent: UICollectionView!
    
    // MARK: Class Variables
    var categoryId = -1
    var categoryName:String?
    var products = [MarketplaceProduct]()

    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgressBar()
        MarketplaceStore.shared.getProducts(delegate: self, id: Int64(categoryId))

        registerForKeyboardNotifications()
        setupDismissOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblScreenTitle.text = categoryName
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: UICollectionView Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width/3 - lay.minimumInteritemSpacing
        //        let heightPerItem = widthPerItem

        return CGSize(width:widthPerItem, height:125)
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketplaceProductsVCDefaultCell", for: indexPath as IndexPath) as! MarketplaceProductsVCDefaultCell
        
        cell.configureCell(product: products[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegueIfPossible(identifier: "marketplaceProductsToPurchase")
    }
    
    // MARK : Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "marketplaceProductsToPurchase" {
            if let vc = segue.destination as? PurchaseVC{
                if let indexPath = cvContent.indexPathsForSelectedItems?[0]{
                    vc.marketPlaceProductObject = products[indexPath.item]
                }
            }
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
    
    @IBAction func btnHomeAction(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: CustomTabBarController.self)
    }
       
}

//An extension for Requests
extension MarketplaceProductsVC : OBSRemoteDataDelegate {
    
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        if status == .HTTPSuccess {
            hideProgressBar()
            products = CoreDataService.getMarketPlaceProducts()
            
            if products.count == 0 {
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
