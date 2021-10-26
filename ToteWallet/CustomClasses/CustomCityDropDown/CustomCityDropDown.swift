//
//  CustomCountryDropDown.swift
//  White Labelled App
//
//  Created by Charbel Helou on 9/20/19.
//  Copyright © 2019 Charbel Helou. All rights reserved.
//

import UIKit

@objc protocol CustomCityDropDownDelegate {
    @objc optional func dropDownCityDidSelect(contentReturned: [City], tag:Int)
}

class CustomCityDropDown: FadingViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var tvContent: UITableView!
    
    @IBOutlet weak var consTvContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vBackground: UIView!
    @IBOutlet weak var vContentContainer: UIView!
    
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    private static var dropDown:CustomCityDropDown?
    var selectedItems = [City]()
    
    var delegate: CustomCityDropDownDelegate?
    
    var dropDownTag = -1
    var titleText = "Title"
    var heightForRow = 40
    var maxDisplayedElementsCount = 8
    var allowsMultipleSelection = false
    var initialContent = [City]()
    var content = [City]()
    
    var didSetAlreadySelected = false
    
    override func viewDidLoad() {
        tvContent.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tvContent.allowsMultipleSelection = allowsMultipleSelection
        let configColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimary ?? "")
        
        lblTitle.text = titleText
        lblTitle.textColor = .white
        consTvContentHeight.constant = (content.count <= maxDisplayedElementsCount) ? CGFloat((content.count)*heightForRow) : CGFloat((maxDisplayedElementsCount)*heightForRow)
        
        vContentContainer.backgroundColor = configColor
        vContentContainer.layer.cornerRadius = 10
        
        vContentContainer.layer.borderWidth = 1
        vContentContainer.layer.borderColor = UIColor.gray.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.close))
        vBackground.addGestureRecognizer(tap)
        
        for selectedItem in selectedItems {
            if content.contains(selectedItem) {
                if let index = content.firstIndex(of: selectedItem) {
                    tvContent.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .none)
                    tableView(tvContent, didSelectRowAt: IndexPath(row: index, section: 0))
                }
            }
        }
        didSetAlreadySelected = true
    }
    
    // MARK: Class Methods
    class func open(title:String, data:[City], selectedItems:[City]?, delegate:CustomCityDropDownDelegate, multipleSelection: Bool, tag:Int){
        dropDown = CustomCityDropDown(nibName: "CustomCityDropDown", bundle: Bundle.main)
        dropDown?.delegate = delegate
        dropDown?.initialContent = data
        dropDown?.content = data
        dropDown?.titleText = title
        dropDown?.modalPresentationStyle = .custom
        dropDown?.transitioningDelegate = dropDown
        dropDown?.allowsMultipleSelection = multipleSelection
        dropDown?.dropDownTag = tag
        if selectedItems != nil {
            dropDown?.selectedItems = selectedItems!
        }
        
        if dropDown != nil {
            UIApplication.shared.keyWindow?.rootViewController?.present(dropDown!, animated: true, completion: nil)
        }
    }
    
    @objc func close() {
        dropDownTag = -1
        if CustomCityDropDown.dropDown != nil {
            CustomCityDropDown.dropDown?.dismiss(animated: true, completion: nil)
        }
    }
    
    //UITableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.searchBarStyle = .default
        searchBar.placeholder = " Search Here..."
        searchBar.sizeToFit()
        
        return searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        content = initialContent

        if searchText == "" {
            content = initialContent
        }
        else{
            content = content.filter { ($0.name?.contains(searchText))! }
        }
        tvContent.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = content[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = content[indexPath.row]
        if !selectedItems.contains(selectedItem) {
            selectedItems.append(selectedItem)
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor(white: 0.8, alpha: 1)
        if didSetAlreadySelected {
            dismissAfterSelection()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = selectedItems.firstIndex(of: content[indexPath.row]) {
            selectedItems.remove(at: index)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.backgroundColor = UIColor.clear
        }
    }
    
    // MARK Action Handlers
    
    @objc func dismissAfterSelection(){
        self.delegate?.dropDownCityDidSelect?(contentReturned: selectedItems, tag: dropDownTag)
        self.close()
    }
    
    @IBAction func btnOkAction(_ sender: Any) {
        self.delegate?.dropDownCityDidSelect?(contentReturned: selectedItems, tag: dropDownTag)
        self.close()
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        self.close()
    }
    
}
