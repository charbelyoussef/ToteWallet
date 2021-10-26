//
//  RegisterVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class EditProfileVC : UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate {
    
    // MARK: Class Outlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tvContent: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    // MARK: Class Variables
    
    fileprivate enum TVSections:Int {
        case AccountSection
        case PersonalInformationSection
        case AddressSection
        case ResetSection
        case ButtonsSection
        case SectionsCount
    }
    
    fileprivate enum TextfieldsTags:Int {
        case ProfilePicture
        case Firstname
        case Lastname
        case Email
        case PhoneNumber
//        case Password
//        case PinCode
        
        case IDImage
        case IDNumber
        case Gender
        
        case Country
        case Province
        case AddressLine1
        case AddressLine2
        case AddressLine3
        case AddressLine4
        
//        case ResetPassword
//        case ResetPin
        
        case UpdateProfileButton
        
        case RowCount
    }
    
    fileprivate enum AccountSection:Int {
        case ProfilePicture
        case Firstname
        case Lastname
        case Email
        case PhoneNumber
//        case Password
//        case PinCode
        case AccountSectionCount
    }
    
    fileprivate enum PersonalInformationSection:Int {
        case IDImage
        case IDNumber
        case Gender
        case PersonalInformationSectionCount
    }
    
    fileprivate enum AddressSection:Int {
        case Country
        case Province
        case AddressLine1
        case AddressLine2
        case AddressLine3
        case AddressLine4
        case AddressSectionCount
    }
    
    fileprivate enum ResetSection:Int {
//        case ResetPassword
//        case ResetPin
        case ResetSectionCount
    }
    
    fileprivate enum ButtonsSection:Int {
        case UpdateProfileButton
        case ButtonsSectionCount
    }
    
    fileprivate enum TVPickers:Int {
        case PhoneCountryCode
        case Gender
        case Country
        case Province
    }
    
    enum ImagePickerOptions:Int {
        case ProfileImage
        case IDImage
    }
    
    var selectedImagePicker = -1
    var rowHeight:CGFloat = 65
    var imageRowHeight:CGFloat = 150
    var contentArray = NSMutableArray()

    var imagePicker = UIImagePickerController()
    var ivPopOut = UIImageView(frame: .zero)
    var vPopOut = UIImageView(frame: .zero)

    var toolBar = UIToolbar()
    var picker  = UIPickerView()

    var genders = ["Female", "Male"]
    var provinces = [City]()
    var countries = DataHelper.countries
    
    var user:Login?
    var imageToUpload:UIImage?
    var idImageToUpload:UIImage?

    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgressBar()
        User.shared.getProfileDetails(delegate: self)
        tvContent.customRegisterForCell(identifiers: ["EditProfileVCHeaderImageCell", "EditProfileVCDefaultCell", "EditProfileVCPhoneCell", "EditProfileVCSelectionCell", "EditProfileProvinceVCSelectionCell","EditProfileVCButtonCell"])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
        setupDismissOnTap()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK : TableView Methods
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case TVSections.AccountSection.rawValue:
            return 50
            
        case TVSections.PersonalInformationSection.rawValue:
            return 50

        case TVSections.AddressSection.rawValue:
            return 50

        case TVSections.ResetSection.rawValue:
            return 50

        case TVSections.ButtonsSection.rawValue:
            return 0

        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = .lightGray

        headerView.addSubview(label)
        
        switch section {
        case TVSections.AccountSection.rawValue:
            label.text = "Account Information"
            break
            
        case TVSections.PersonalInformationSection.rawValue:
            label.text = "Personal Information"
            break
            
        case TVSections.AddressSection.rawValue:
            label.text = "Address"
            break
            
        case TVSections.ResetSection.rawValue:
            label.text = "Reset"
            break
            
        case TVSections.ButtonsSection.rawValue:
            break
            
        default:
            break
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case TVSections.AccountSection.rawValue:
            switch indexPath.row {
            case AccountSection.ProfilePicture.rawValue:
                return imageRowHeight
            default:
                return rowHeight
            }
            
        case TVSections.PersonalInformationSection.rawValue:
            switch indexPath.row {
            case PersonalInformationSection.IDImage.rawValue:
                return imageRowHeight
            default:
                return rowHeight
            }
            
        default:
            return rowHeight
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TVSections.SectionsCount.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case TVSections.AccountSection.rawValue:
            return AccountSection.AccountSectionCount.rawValue
            
        case TVSections.PersonalInformationSection.rawValue:
            return PersonalInformationSection.PersonalInformationSectionCount.rawValue
            
        case TVSections.AddressSection.rawValue:
            return AddressSection.AddressSectionCount.rawValue
            
        case TVSections.ResetSection.rawValue:
            return ResetSection.ResetSectionCount.rawValue
            
        case TVSections.ButtonsSection.rawValue:
            return ButtonsSection.ButtonsSectionCount.rawValue
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case TVSections.AccountSection.rawValue:
            switch indexPath.row {
            case AccountSection.ProfilePicture.rawValue:
                let cell:EditProfileVCHeaderImageCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCHeaderImageCell", for: indexPath) as! EditProfileVCHeaderImageCell
                
                cell.lblTitle.text = "Profile Pic"
                cell.ivProfile.layer.cornerRadius = cell.ivProfile.frame.width/2
//                cell.ivProfile.layer.borderWidth =  2.0
//                cell.ivProfile.layer.borderColor = UIColor.white.cgColor
                cell.ivProfile.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleProfilePicLongTap(recognizer:))))
                
                if imageToUpload != nil {
                    cell.ivProfile.image = imageToUpload
                }
                else {
                    if let imageUrl = user?.imageUrl, imageUrl != "" {
                        cell.ivProfile.sd_setImage(with: URL(string: imageUrl.safeURL()), placeholderImage: UIImage(named: "user"))
                    }
                    else {
                        cell.ivProfile.image = UIImage(named: "user")
                    }
                }
                
                cell.btnChangePicture.tag = ImagePickerOptions.ProfileImage.rawValue
                cell.btnChangePicture.addTarget(self, action: #selector(changePicture), for: .touchUpInside)
                return cell
                
            case AccountSection.Firstname.rawValue:
                let cell:EditProfileVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCDefaultCell", for: indexPath) as! EditProfileVCDefaultCell
                
                cell.lblTitle.text = "First Name"
                cell.tfValue.tag = TextfieldsTags.Firstname.rawValue
                cell.tfValue.text = user?.firstName
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
                
                return cell
                
            case AccountSection.Lastname.rawValue:
                let cell:EditProfileVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCDefaultCell", for: indexPath) as! EditProfileVCDefaultCell
                
                cell.lblTitle.text = "Last Name"
                cell.tfValue.tag = TextfieldsTags.Lastname.rawValue
                cell.tfValue.text = user?.lastName
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .words, returnKeyType: .default, isPassword: false)
                
                return cell
                
            case AccountSection.Email.rawValue:
                let cell:EditProfileVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCDefaultCell", for: indexPath) as! EditProfileVCDefaultCell
                
                cell.lblTitle.text = "Email"
                cell.tfValue.tag = TextfieldsTags.Email.rawValue
                cell.tfValue.text = user?.email
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .emailAddress, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: false)
                
                return cell
                
            case AccountSection.PhoneNumber.rawValue:
                let cell:EditProfileVCPhoneCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCPhoneCell", for: indexPath) as! EditProfileVCPhoneCell
                
                cell.lblTitle.text = "Phone"
                cell.tfValue.tag = TextfieldsTags.PhoneNumber.rawValue
                cell.tfValue.text = user?.tel ?? "N/A"
                
                cell.btnCountryCode.tag = TextfieldsTags.PhoneNumber.rawValue
                cell.btnCountryCode.addTarget(self, action: #selector(selectCountryCode), for: .touchDown)
                let country = DataHelper.getcountry(for: "\(user?.countryCode ?? -1)")
                
                cell.btnCountryCode.setTitle(country?.codeWithName, for: .normal)
                
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .phonePad, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: false)
                
                return cell
                
//            case AccountSection.Password.rawValue:
//                let cell:EditProfileVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCDefaultCell", for: indexPath) as! EditProfileVCDefaultCell
//
//                cell.lblTitle.text = "Password"
//                cell.tfValue.tag = TextfieldsTags.Password.rawValue
//                cell.tfValue.isUserInteractionEnabled = false
//                cell.tfValue.backgroundColor =  cell.tfValue.isUserInteractionEnabled ? .clear : UIColor(hexString: ConfigurationManager.getAppConfiguration().readOnlyBackgroundColor ?? "")
//                cell.tfValue.delegate = self
//                cell.tfValue.customize(keyboardType: .emailAddress, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: true)
//
//                return cell
//
//            case AccountSection.PinCode.rawValue:
//                let cell:EditProfileVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCDefaultCell", for: indexPath) as! EditProfileVCDefaultCell
//
//                cell.lblTitle.text = "Pin Code"
//                cell.tfValue.tag = TextfieldsTags.PinCode.rawValue
//                cell.tfValue.isUserInteractionEnabled = false
//                cell.tfValue.backgroundColor =  cell.tfValue.isUserInteractionEnabled ? .clear : UIColor(hexString: ConfigurationManager.getAppConfiguration().readOnlyBackgroundColor ?? "")
//                cell.tfValue.delegate = self
//                cell.tfValue.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: true)
//
//                return cell
            default:
                return UITableViewCell()
            }
            
        case TVSections.PersonalInformationSection.rawValue:
            switch indexPath.row {
            
            case PersonalInformationSection.IDImage.rawValue:
                let cell:EditProfileVCHeaderImageCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCHeaderImageCell", for: indexPath) as! EditProfileVCHeaderImageCell
                
                cell.lblTitle.text = "ID scan/image or Passport"
                cell.ivProfile.layer.cornerRadius = cell.ivProfile.frame.width/2
                cell.ivProfile.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleProfilePicLongTap(recognizer:))))
                
                if idImageToUpload != nil {
                    cell.ivProfile.image = idImageToUpload
                }
                else {
                    if let imageUrl = user?.idImageUrl, imageUrl != "" {
                        cell.ivProfile.sd_setImage(with: URL(string: imageUrl.safeURL()), placeholderImage: UIImage(named: "user"))
                    }
                    else {
                        cell.ivProfile.image = UIImage(named: "user")
                    }
                }

                cell.btnChangePicture.tag = ImagePickerOptions.IDImage.rawValue
                cell.btnChangePicture.addTarget(self, action: #selector(changePicture), for: .touchUpInside)
                return cell
            
            case PersonalInformationSection.IDNumber.rawValue:
                let cell:EditProfileVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCDefaultCell", for: indexPath) as! EditProfileVCDefaultCell
                
                cell.lblTitle.text = "ID Number"
                cell.tfValue.tag = TextfieldsTags.IDNumber.rawValue
                cell.tfValue.isUserInteractionEnabled = false
                cell.tfValue.backgroundColor =  cell.tfValue.isUserInteractionEnabled ? .clear : UIColor(hexString: ConfigurationManager.getAppConfiguration().readOnlyBackgroundColor ?? "")
                cell.tfValue.text = user?.id
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: false)
                
                return cell
                
            case PersonalInformationSection.Gender.rawValue:
                let cell:EditProfileVCSelectionCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCSelectionCell", for: indexPath) as! EditProfileVCSelectionCell
                
                cell.lblTitle.text = "Gender"
//                cell.btnSelection.setTitle(user?.gender, for: .normal)
                cell.btnSelection.tag = TextfieldsTags.Gender.rawValue
                cell.btnSelection.addTarget(self, action: #selector(selectGenderAction), for: .touchDown)
                cell.btnSelection.setTitle(user?.genderName, for: .normal)
                
                return cell
                
            default:
                return UITableViewCell()
            }
            
        case TVSections.AddressSection.rawValue:
            switch indexPath.row {
            case AddressSection.Country.rawValue:
                let cell:EditProfileVCSelectionCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCSelectionCell", for: indexPath) as! EditProfileVCSelectionCell
                
                cell.lblTitle.text = "Country"
                let country = DataHelper.getcountryForId(countryId: "\(user?.detailsCountryId ?? -1)")
                cell.btnSelection.setTitle(country?.name, for: .normal)
                cell.btnSelection.tag = TextfieldsTags.Country.rawValue
                cell.btnSelection.addTarget(self, action: #selector(selectCountryCode), for: .touchDown)
                
                return cell
                
            case AddressSection.Province.rawValue:
                let cell:EditProfileProvinceVCSelectionCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileProvinceVCSelectionCell", for: indexPath) as! EditProfileProvinceVCSelectionCell
                
                cell.lblTitle.text = "Province"
                cell.btnSelection.setTitle(user?.cityName, for: .normal)
                cell.btnSelection.tag = TextfieldsTags.Province.rawValue
                cell.btnSelection.addTarget(self, action: #selector(selectProvinceAction), for: .touchDown)
                
                return cell
                
            case AddressSection.AddressLine1.rawValue:
                let cell:EditProfileVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCDefaultCell", for: indexPath) as! EditProfileVCDefaultCell
                
                cell.lblTitle.text = "Address Line 1"
                cell.tfValue.tag = TextfieldsTags.AddressLine1.rawValue
                cell.tfValue.text = user?.address1
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .emailAddress, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: false)
                
                return cell
                
            case AddressSection.AddressLine2.rawValue:
                let cell:EditProfileVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCDefaultCell", for: indexPath) as! EditProfileVCDefaultCell
                
                cell.lblTitle.text = "Address Line 2(Optional)"
                cell.tfValue.tag = TextfieldsTags.AddressLine2.rawValue
                cell.tfValue.text = user?.address2
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .emailAddress, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: false)
                
                return cell
                
            case AddressSection.AddressLine3.rawValue:
                let cell:EditProfileVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCDefaultCell", for: indexPath) as! EditProfileVCDefaultCell
                
                cell.lblTitle.text = "Address Line 3(Optional)"
                cell.tfValue.tag = TextfieldsTags.AddressLine3.rawValue
                cell.tfValue.text = user?.address3
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .emailAddress, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: false)
                
                return cell
                
            case AddressSection.AddressLine4.rawValue:
                let cell:EditProfileVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCDefaultCell", for: indexPath) as! EditProfileVCDefaultCell
                
                cell.lblTitle.text = "Address Line 4(Optional)"
                cell.tfValue.tag = TextfieldsTags.AddressLine4.rawValue
                cell.tfValue.text = user?.address4
                cell.tfValue.delegate = self
                cell.tfValue.customize(keyboardType: .emailAddress, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: false)
                
                return cell
                
            default:
                return UITableViewCell()
            }
            
        case TVSections.ResetSection.rawValue:
            switch indexPath.row {
//            case ResetSection.ResetPassword.rawValue:
//                let cell:EditProfileVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCDefaultCell", for: indexPath) as! EditProfileVCDefaultCell
//
//                cell.lblTitle.text = "Password"
//                cell.tfValue.tag = TextfieldsTags.ResetPassword.rawValue
//                cell.tfValue.isUserInteractionEnabled = false
//                cell.tfValue.backgroundColor =  cell.tfValue.isUserInteractionEnabled ? .clear : UIColor(hexString: ConfigurationManager.getAppConfiguration().readOnlyBackgroundColor ?? "")
//
//                //            cell.tfValue.text = user?.email
//                cell.tfValue.delegate = self
//                cell.tfValue.customize(keyboardType: .default, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: true)
//
//                return cell
                
//            case ResetSection.ResetPin.rawValue:
//                let cell:EditProfileVCDefaultCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCDefaultCell", for: indexPath) as! EditProfileVCDefaultCell
//
//                cell.lblTitle.text = "Pin Code"
//                cell.tfValue.tag = TextfieldsTags.ResetPin.rawValue
//                cell.tfValue.isUserInteractionEnabled = false
//                cell.tfValue.backgroundColor =  cell.tfValue.isUserInteractionEnabled ? .clear : UIColor(hexString: ConfigurationManager.getAppConfiguration().readOnlyBackgroundColor ?? "")
//                //            cell.tfValue.text = user?.email
//                cell.tfValue.delegate = self
//                cell.tfValue.customize(keyboardType: .numberPad, autoCorrectionType: .no, capitalizationType: .none, returnKeyType: .default, isPassword: true)
//
//                return cell
                
            default:
                return UITableViewCell()
            }
            
        case TVSections.ButtonsSection.rawValue:
            switch indexPath.row {
            case ButtonsSection.UpdateProfileButton.rawValue:
                let cell:EditProfileVCButtonCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileVCButtonCell", for: indexPath) as! EditProfileVCButtonCell
                cell.btnUpdateSettings.addTarget(self, action: #selector(updateAction), for: .touchUpInside)
                cell.btnReset.addTarget(self, action: #selector(resetAction), for: .touchUpInside)

                
                return cell
                
            default:
                return UITableViewCell()
            }
            
        default:
            return UITableViewCell()
        }
        
    }
    
    // MARK: TextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        hidePicker()
        switch textField.tag {
            //            case TVSections.Firstname.rawValue:
        //                return false
        default:
            return true
            
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case TextfieldsTags.Firstname.rawValue:
            user?.firstName = textField.text ?? ""
            return true

        case TextfieldsTags.Lastname.rawValue:
            user?.lastName = textField.text ?? ""
            return true

        case TextfieldsTags.Email.rawValue:
            user?.email = textField.text ?? ""
            return true

        case TextfieldsTags.PhoneNumber.rawValue:
            user?.tel = textField.text ?? "0"
            return true

        case TextfieldsTags.AddressLine1.rawValue:
            user?.address1 = textField.text ?? ""
            return true
            
        case TextfieldsTags.AddressLine2.rawValue:
            user?.address2 = textField.text ?? ""
            return true

        case TextfieldsTags.AddressLine3.rawValue:
            user?.address3 = textField.text ?? ""
            return true

        case TextfieldsTags.AddressLine4.rawValue:
            user?.address4 = textField.text ?? ""
            return true

            
//        case TextfieldsTags.Password.rawValue:
//            return true
//
//        case TextfieldsTags.ResetPassword.rawValue:
//            return true
//
//        case TextfieldsTags.PinCode.rawValue:
//            return true
//
//        case TextfieldsTags.ResetPin.rawValue:
//            return true
            
        default:
            return true
        }
    }
    
    // MARK: Image Picker Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            // Code performed while dismissing
        })
        let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if let image = imagePicked {
//            uploadImage(image: image)
            switch selectedImagePicker {
            case ImagePickerOptions.ProfileImage.rawValue:
                imageToUpload = image
                let indexPath = IndexPath(row: 0, section: 0)
                if let cell = tvContent.cellForRow(at: indexPath) as? EditProfileVCHeaderImageCell {
                    cell.ivProfile.image = image
                }
                break
                
            case ImagePickerOptions.IDImage.rawValue:
                idImageToUpload = image
                let indexPath = IndexPath(row: 0, section: 1)
                if let cell = tvContent.cellForRow(at: indexPath) as? EditProfileVCHeaderImageCell {
                    cell.ivProfile.image = image
                }
                break
                
            default:
                break
            }
        }
    }
    
    // MARK: Custom Methods
    
    @objc func handleProfilePicLongTap(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            if let cell = tvContent.cellForRow(at: IndexPath(row: TextfieldsTags.ProfilePicture.rawValue, section: 0)) as? EditProfileVCHeaderImageCell {
                let frame = self.view.convert(cell.ivProfile.frame, from: cell.ivProfile.superview)
                
                vPopOut.frame = self.view.frame
                vPopOut.backgroundColor = .clear
                
                ivPopOut.frame = frame
                ivPopOut.clipsToBounds = true
                ivPopOut.contentMode = .scaleAspectFit
                ivPopOut.alpha = 0
                if let imageUrl = user?.imageUrl, imageUrl != "" {
                    ivPopOut.sd_setImage(with: URL(string: imageUrl))
                }
                self.view.addSubview(vPopOut)
                vPopOut.addSubview(ivPopOut)
                UIView.animate(withDuration: 0.2) {
                    self.vPopOut.backgroundColor = UIColor(white: 0, alpha: 0.5)
                    self.ivPopOut.frame = self.vPopOut.frame
                    self.ivPopOut.alpha = 1
                }
            }
            break
        case .changed, .possible:
            break
        default:
            if let cell = tvContent.cellForRow(at: IndexPath(row: TextfieldsTags.ProfilePicture.rawValue, section: 0)) as? EditProfileVCHeaderImageCell {
                let frame = self.view.convert(cell.ivProfile.frame, from: cell.ivProfile.superview)
                UIView.animate(withDuration: 0.2, animations: {
                    self.ivPopOut.frame = frame
                    self.ivPopOut.alpha = 0
                }) { (finished) in
                    self.ivPopOut.removeFromSuperview()
                    self.vPopOut.removeFromSuperview()
                }
            }
            else {
                self.ivPopOut.removeFromSuperview()
            }
            break
        }
    }
    
    @objc func changePicture(sender: UIButton){
        selectedImagePicker = sender.tag
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {_ in self.openCamera() }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {_ in self.openLibrary() }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = sender
            presenter.sourceRect = sender.bounds
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func resetAction(sender: UIButton){
        let alert = UIAlertController(title: "Select Option:", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Change Password", style: .default, handler: {_ in self.changePassword() }))
        alert.addAction(UIAlertAction(title: "Change Pin", style: .default, handler: {_ in self.changePin() }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
                
        self.present(alert, animated: true, completion: nil)
    }
    
    func changePassword(){
        showProgressBar()
        User.shared.requestResetPassword(delegate: self, email: "")
    }
    
    func changePin(){
        showProgressBar()
        User.shared.requestResetPin(delegate: self)
    }

    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func reloadUser(){
        user = CoreDataService.getLogin()
    }
    
    override func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            tvContent.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 20, right: 0)
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        tvContent.contentInset = .zero
    }
    
    // MARK : Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerToRegistrationSuccessful" {
//            let vc = segue.destination as? UIViewController
//            if vc != nil{
//                if let indexPath = tvContent.indexPathForSelectedRow{
//                    // set presented view controller data
//                }
//            }
        }
    }
    
    // MARK: Custom Methods
    @objc func updateAction(){
        if checkIfAllFieldsAreFilled() {
            
            if !Utils.isEmailValid(user?.email) {
                showAlertWithCompletion(message: Constants.Errors.ERR_EMAIL_NOT_VALID, okTitle: "Ok", cancelTitle: nil, completionBlock: nil)
                return
            }
            
            if let password = user?.password, password != "", let confirmPassword = user?.confirmPassword, confirmPassword != "" {
                if !checkPasswordConformity(password: password, confirmPassword: confirmPassword) {
                    showAlertWithCompletion(message: Constants.Errors.PASSWORD_MISMATCH_ERROR, okTitle: "Ok", cancelTitle: nil, completionBlock: nil)
                    return
                }
            }
            
            let country = DataHelper.getcountry(for: "\(user?.countryCode ?? -1)")

            showProgressBar()
            User.shared.editProfile(delegate: self,
                                    gender: "\(user?.gender ?? -1)",
                                    phoneCountry: "\(country?.id ?? -1)",
                                    phoneNumber: user?.tel ?? "N/A",
                                    email: user?.email ?? "N/A",
                                    city: "\(user?.detailsCityId ?? "N/A")",
                                    countryId: "\(user?.detailsCountryId ?? -1)",
                                    imageFile: user?.imageUrl ?? "N/A",
                                    idNumber: user?.id ?? "N/A",
                                    idNationality: "\(user?.detailsIdNationalityId ?? -1)",
                                    idType: "\(user?.detailsIdTypeId ?? -1)",
                                    address1: user?.address1 ?? "N/A",
                                    address2: user?.address2 ?? "N/A",
                                    address3: user?.address3 ?? "N/A",
                                    address4: user?.address4 ?? "N/A",
                                    profilePicFile: user?.imageUrl ?? "N/A",
                                    firstname: user?.firstName ?? "N/A",
                                    lastname: user?.lastName ?? "N/A",
                                    roles: "2",
                                    birthdate: user?.birthdate ?? "N/A",
                                    image: imageToUpload ?? nil,
                                    imageName: "profile-user-\(user?.id ?? "N/A").jpg",
                                    idImage: idImageToUpload ?? nil,
                                    idImageName: "profile-user-id-image-\(user?.id ?? "N/A").jpg")
        }
        else{
            showAlertWithCompletion(message: Constants.Errors.ERROR_FILL_ALL_FIELDS, okTitle: "Ok", cancelTitle: nil, completionBlock: nil)
        }

    }
    
    func uploadImage(image: UIImage) {
//        let imgData = image.jpegData(compressionQuality:0.2)! //Low Quality
    }
    
    func checkPasswordConformity(password:String, confirmPassword:String) -> Bool{
        let isConform = (password == confirmPassword)
        isConform ? () : showAlertWithCompletion(message: Constants.Errors.PASSWORD_MISMATCH_ERROR, okTitle: "Okay", cancelTitle: nil, completionBlock: nil)
        return isConform
    }

    
    @objc func selectGenderAction(_ sender: UIButton){
//        initPicker(tag: TVPickers.Gender.rawValue)
        initPicker(tag: sender.tag)
    }
    
    @objc func selectProvinceAction(){
        showProgressBar()
        
        let country = DataHelper.getcountryForId(countryId: "\(user?.detailsCountryId ?? -1)")
        showProgressBar()
        User.shared.getCitiesForCountry(delegate: self, countryId: country?.id ?? -1)
    }
    
    func checkIfAllFieldsAreFilled() -> Bool{
        
        if(user?.firstName == nil || user?.firstName == ""){
            return false
        }
        if(user?.lastName == nil || user?.lastName == ""){
            return false
        }
        if(user?.email == nil || user?.email == ""){
            return false
        }
        if(user?.tel == nil || user?.tel == "") {
            return false
        }
//        if(user?.password == nil || user?.password == "") {
//            return false
//        }
//        if(registerObject.confirmPassword == nil || registerObject.confirmPassword == "") {
//            return false
//        }
//        if(registerObject.pinCode == nil || registerObject.pinCode == 0) {
//            return false
//        }
//        if(registerObject.confirmPinCode == nil || registerObject.confirmPinCode == 0) {
//            return false
//        }
        if(user?.detailsCityId == nil || user?.detailsCityId == ""){
            return false
        }
        if(user?.address1 == nil || user?.address1 == ""){
            return false
        }
//        if(user?.address2 == nil || user?.address2 == ""){
//            return false
//        }
//        if(user?.address3 == nil || user?.address3 == ""){
//            return false
//        }
//        if(user?.address4 == nil || user?.address4 == "") {
//            return false
//        }
        return true
    }
    
    // MARK: Button Handlers
    @IBAction func btnBackAction(_ sender: Any) {
//        revealMenu()
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func btnMenuAction(_ sender: Any) {
        revealMenu()
    }
    
    @IBAction func btnLogoutAction(_ sender: Any) {
        if let country = DataHelper.getcountry(for: "\(user?.countryCode ?? -1)"), let phoneNumber = self.user?.tel {
            UserDefaults.standard.set("\(country.id)", forKey: "lastLoggedInlastCountryId")
            UserDefaults.standard.set("\(phoneNumber)", forKey: "lastLoggedInlastPhoneNumber")
        }
        
        CoreDataService.clearAll()
        self.parent?.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: CountryDropDown Methods
extension EditProfileVC: CustomCountryDropDownDelegate {
    
    // MARK: CustomDropDown Methods
    @objc func openDropDown(title: String, data:[Country], tag:Int){
        switch tag {
        case TVPickers.PhoneCountryCode.rawValue:
            resignFirstResponder()
            CustomCountryDropDown.open(title:"Select Country",
                            data: data,
                            selectedItems: nil,
                            delegate: self,
                            multipleSelection: false,
                            tag:tag)
            break
            
        case TVPickers.Country.rawValue:
            resignFirstResponder()
            CustomCountryDropDown.open(title:"Select Country",
                            data: data,
                            selectedItems: nil,
                            delegate: self,
                            multipleSelection: false,
                            tag:tag)
            break

        default:
            break
        }
    }
    
    func dropDownCountryDidSelect(contentReturned: [Country], tag: Int) {
        switch tag {
        case TVPickers.PhoneCountryCode.rawValue:
            if let country = contentReturned.first {
                if let cell = tvContent.cellForRow(at: IndexPath(row: AccountSection.PhoneNumber.rawValue, section: TVSections.AccountSection.rawValue)) as? EditProfileVCPhoneCell {
                    user?.countryCode = country.phoneCode
                    cell.btnCountryCode.setTitle(country.codeWithName, for: .normal)
                    tvContent.reloadData()
                }
            }
            break
        
        case TVPickers.Country.rawValue:
            if let country = contentReturned.first {
//                registerObject.countryCode = "\(country.id)"
                if let cell = tvContent.cellForRow(at: IndexPath(row: AddressSection.Country.rawValue, section: TVSections.AddressSection.rawValue)) as? EditProfileVCSelectionCell {
                    user?.detailsCountryId = country.id
                    cell.btnSelection.setTitle(country.name, for: .normal)
                    
                    if let cell = tvContent.cellForRow(at: IndexPath(row: AddressSection.Province.rawValue, section: TVSections.AddressSection.rawValue)) as? EditProfileProvinceVCSelectionCell {
                        user?.detailsCityId = ""
                        user?.cityName = ""
                        cell.btnSelection.setTitle("", for: .normal)
                    }
                    
                    tvContent.reloadData()
                }
            }
            break
            
            
        case TVPickers.Province.rawValue:
            break

        default:
            break
        }
    }
    
    @objc func selectCountryCode(_ sender: UIButton){
        openDropDown(title: "Select Country", data: DataHelper.countries, tag: sender.tag)
    }
}

// MARK: CityDropDown Methods
extension EditProfileVC: CustomCityDropDownDelegate {
    
    // MARK: CustomDropDown Methods
    @objc func openCityDropDown(title: String, data:[City], tag:Int){
        resignFirstResponder()
        CustomCityDropDown.open(title:"Select City",
                        data: data,
                        selectedItems: nil,
                        delegate: self,
                        multipleSelection: false,
                        tag:tag)
    }
    
    func dropDownCityDidSelect(contentReturned: [City], tag: Int) {
        if let province = contentReturned.first {
//                registerObject.countryCode = "\(country.id)"
            if let cell = tvContent.cellForRow(at: IndexPath(row: AddressSection.Province.rawValue, section: TVSections.AddressSection.rawValue)) as? EditProfileProvinceVCSelectionCell {
                user?.detailsCityId = province.id
                user?.cityName = province.name
                cell.btnSelection.setTitle(province.name, for: .normal)
                tvContent.reloadData()
            }
        }
    }
    
    @objc func selectCity(){
        openCityDropDown(title: "Select City", data: provinces, tag: -1)
    }
}

// MARK: UIPicker Methods
extension EditProfileVC : UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        switch picker.tag {
//        case TVPickers.PhoneCountryCode.rawValue:
//            return countries.count
//
//        case TVPickers.Gender.rawValue:
            return genders.count
//
//        case TVPickers.Country.rawValue:
//            return countries.count
//
//        case TVPickers.Province.rawValue:
//            return provinces.count
//
//        default:
//            return 0
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
//        switch picker.tag {
//        case TVPickers.PhoneCountryCode.rawValue:
//            return countries[row].codeWithName
//
//        case TVPickers.Gender.rawValue:
            return genders[row]
//
//        case TVPickers.Country.rawValue:
//            return countries[row].name
//
//        case TVPickers.Province.rawValue:
//            return provinces[row].name
//
//        default:
//            return "N/A"
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        switch picker.tag {
        case TVPickers.PhoneCountryCode.rawValue:
            let country = countries[row]
            if let cell = tvContent.cellForRow(at: IndexPath(row: AccountSection.PhoneNumber.rawValue, section: TVSections.AccountSection.rawValue)) as? EditProfileVCPhoneCell {
                user?.countryCode = country.phoneCode
                cell.btnCountryCode.setTitle(country.codeWithName, for: .normal)
                tvContent.reloadData()
            }
        case TVPickers.Gender.rawValue:
            let gender = genders[row]
            if let cell = tvContent.cellForRow(at: IndexPath(row: PersonalInformationSection.Gender.rawValue, section: TVSections.PersonalInformationSection.rawValue)) as? EditProfileVCSelectionCell {
                cell.btnSelection.setTitle(gender, for: .normal)
                user?.genderName = gender
                switch user?.genderName {
                case "Male":
                    user?.gender = 0
                    break
                    
                case "Female":
                    user?.gender = 1
                    break

                default:
                    break
                }
                tvContent.reloadData()
            }

        case TVPickers.Country.rawValue:
            let country = countries[row]
            if let cell = tvContent.cellForRow(at: IndexPath(row: AddressSection.Country.rawValue, section: TVSections.AddressSection.rawValue)) as? EditProfileVCSelectionCell {
                user?.detailsCountryId = country.id
                cell.btnSelection.setTitle(country.name, for: .normal)
                
                if let cell = tvContent.cellForRow(at: IndexPath(row: AddressSection.Province.rawValue, section: TVSections.AddressSection.rawValue)) as? EditProfileProvinceVCSelectionCell {
                    user?.detailsCityId = ""
                    user?.cityName = ""
                    cell.btnSelection.setTitle("", for: .normal)
                }
                
                tvContent.reloadData()
            }

        case TVPickers.Province.rawValue:
            let province = provinces[row]
            if let cell = tvContent.cellForRow(at: IndexPath(row: AddressSection.Province.rawValue, section: TVSections.AddressSection.rawValue)) as? EditProfileProvinceVCSelectionCell {
                user?.detailsCityId = province.id
                user?.cityName = province.name
                cell.btnSelection.setTitle(province.name, for: .normal)
                tvContent.reloadData()
            }

        default:
            break
        }
        
    }
    
    // MARK: Custom Methods
    
    func initPicker(tag: Int){
        if(!picker.isKind(of: CustomPickerView.self)){
            picker = CustomPickerView()
            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - Constants.UIElements.pickerHeight, width: UIScreen.main.bounds.size.width, height: Constants.UIElements.pickerToolbarHeight))
            toolBar.barStyle = .default
            let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

            toolBar.items = [flexButton, UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        }
        
        picker.tag = tag
        picker.delegate = self
        picker.dataSource = self
        picker.reloadAllComponents()
        picker.selectRow(0, inComponent: 0, animated: true)
        showPicker()
    }
    
    func showPicker(){
        self.tabBarController?.tabBar.isHidden = true
        self.view.addSubview(picker)
        self.view.addSubview(toolBar)
    }
    
    func hidePicker(){
        self.tabBarController?.tabBar.isHidden = false
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    @objc func onDoneButtonTapped() {
        hidePicker()
    }
}

//An extension for Requests
extension EditProfileVC : OBSRemoteDataDelegate {
    func hasFinishedLoadingData(status: OBSRemoteDataStatus.Name, message: String) {
        hideProgressBar()
        
        if status == .HTTPSuccess {
            user = CoreDataService.getLogin()
            tvContent.reloadData()
        }
        if status == .citiesFetchSucceeded {
            provinces = CoreDataService.getAllCities(ascending: true)
//            initPicker(tag: TVPickers.Province.rawValue)
            selectCity()
        }
        if status == .didNotLoadRemoteData {
            if message != "" {
                showAlertWithCompletion(message: message, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
            else{
                showAlertWithCompletion(message: Constants.Errors.GENERAL_ERROR, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
        }
        if status == .didRequestPinReset {
            if message != "" {
                showAlertWithCompletion(message: message, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
            else{
                showAlertWithCompletion(message: Constants.Errors.GENERAL_ERROR, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
        }
        if status == .didRequestPassReset {
            if message != "" {
                showAlertWithCompletion(message: message, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
            else{
                showAlertWithCompletion(message: Constants.Errors.GENERAL_ERROR, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
        }
        
        if status == .updateProfileSucceeded {
            imageToUpload = nil
            idImageToUpload = nil
            reloadUser()
            tvContent.reloadData()
            if message != "" {
                showAlertWithCompletion(message: message, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
            else{
                showAlertWithCompletion(message: Constants.Errors.GENERAL_ERROR, okTitle: "Ok", cancelTitle: "", completionBlock: nil)
            }
        }
        
    }
    
    func hasFinishedLoadingDataWithError(error: Error?) {
        hideProgressBar()
    }
    
}
