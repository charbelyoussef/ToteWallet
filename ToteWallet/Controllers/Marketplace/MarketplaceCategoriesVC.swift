//
//  ViewController.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class MarketplaceCategoriesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    // MARK: Class Outlets
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tvContent: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var cvContent: UICollectionView!

    // MARK: Class Variables
    var contentArray = NSMutableArray()
    var providerId = -1
    var providerName:String?
    var categories = [MarketplaceCategory]()

    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        registerForKeyboardNotifications()
        setupDismissOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblScreenTitle.text = providerName
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
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketplaceCategoriesVCDefaultCell", for: indexPath as IndexPath) as! MarketplaceCategoriesVCDefaultCell
        
        cell.configureCell(category: categories[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        providerName = category.name ?? "N/A"

        if category.hasChildren {
            providerId = Int(category.id)
            loadCategories()
        }
        else{
            performSegueIfPossible(identifier: "marketplaceCategoriesToProducts")
        }
    }
    
    // MARK: Custom Methods
    func loadCategories() {
        showProgressBar()
        lblScreenTitle.text = providerName
        MarketplaceStore.shared.getCategories(delegate: self, id: Int64(providerId))
    }
    
    // MARK: Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "marketplaceCategoriesToProducts" {
            let vc = segue.destination as? MarketplaceProductsVC
            if vc != nil{
                if let indexPath = cvContent.indexPathsForSelectedItems?[0]{
                    // set presented view controller data
                    vc?.categoryId = Int(categories[indexPath.item].id)
                    vc?.categoryName = providerName
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
extension MarketplaceCategoriesVC : OBSRemoteDataDelegate {
    
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        if status == .HTTPSuccess {
            hideProgressBar()
            categories.removeAll()
            categories = CoreDataService.getMarketPlaceCategories()
            if categories.count == 0 {
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
        hideProgressBar()
    }

}
