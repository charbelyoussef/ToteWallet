//
//  RegisterVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class SplashVC : UIViewController, UINavigationControllerDelegate {
    
    // MARK: Class Outlets
    
    // MARK: Class Variables
        
    
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CoreDataService.clearLogin()
//        if getLoggedInUser() != nil{
//            User.shared.getProfileDetails(delegate: self)
//        }
//        else{
        if let configuration = CoreDataService.getAppConfiguration().first, CoreDataService.getAllCountries(ascending: true).count > 0 {
            performSegueIfPossible(identifier: "splashToLogin")
        }
        else{
            User.shared.getAppConfiguration(delegate: self)
        }
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "splashToLogin" {
//            let vc = segue.destination as? UIViewController
//            if vc != nil{
//            }
        }
    }
    
    // MARK: Custom Methods
    func getLoggedInUser() -> Login?{
        return CoreDataService.getLogin()
    }

}

//An extension for Requests
extension SplashVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        
//        if(status == .HTTPSuccess){
//            User.shared.getWallets(delegate: self)
//        }
//        else if(status == .walletsFetchSucceeded) {
//            if CoreDataService.getAllCountries(ascending: true).count > 0 {
//                performSegueIfPossible(identifier: "splashToHome")
//            }
//            else{
//                User.shared.getCountries(delegate: self)
//            }
//        }
        if(status == .configurationFetchSucceeded) {
//            if getLoggedInUser() != nil{
//                performSegueIfPossible(identifier: "splashToHome")
//            }
//            else{
                performSegueIfPossible(identifier: "splashToLogin")
//            }
        }
    }
    
    func hasFinishedLoadingDataWithError(error: Error?) {
        if error != nil, let errorMessage = error?.localizedDescription, errorMessage != "" {
            showAlertWithCompletion(message: errorMessage, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
        else {
            showAlertWithCompletion(message: Constants.Errors.GENERAL_ERROR, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
        }
//        if CoreDataService.getProfileSettings() != nil && CoreDataService.getAllCountries(ascending: true).count > 0 {
//            performSegueIfPossible(identifier: "splashToHome")
//        }
//        else{
//            User.shared.getProfileDetails(delegate: self)
//        }
    }
    
}
