//
//  CalendarPickerVC.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/23/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit
import FSCalendar

@objc protocol CalendarPickerDelegate {
    
    @objc optional func datesSelected(firstDate: Date, lastDate: Date)
    @objc optional func dateSelected(date: Date)
    
}

class CalendarPickerVC: FadingViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var vHeader: UIView!
    
    @IBOutlet weak var fsCalendar: FSCalendar!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    
    @IBOutlet weak var lblDates: UILabel!
    @IBOutlet weak var lblNights: UILabel!
    
    private static var picker : CalendarPickerVC?
    
    var delegate: CalendarPickerDelegate?
    
    var firstDate: Date?
    var lastDate: Date?
    
    var multipleSelection = false
    
    private var datesRange: [Date]?
    
    override func viewDidLoad() {
        btnApply.isEnabled = false
        btnApply.setTitleColor(UIColor(white: 0, alpha: 0.2), for: .disabled)
        
        vContainer.layer.cornerRadius = 10
        vContainer.layer.borderWidth = 2
        vContainer.layer.borderColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimaryLighter ?? "").cgColor
        vHeader.backgroundColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimaryLighter ?? "")
        
        setupCalendar()
        
        fsCalendar.allowsMultipleSelection = multipleSelection
        
        if fsCalendar.allowsMultipleSelection {
            selectCalendarBetween(firstDate: firstDate, lastDate: lastDate)
        }
        else {
            selectCalendar(date: firstDate)
        }
    }
    
    func setupCalendar() {
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        fsCalendar.scrollDirection = .vertical
        fsCalendar.pagingEnabled = false
        fsCalendar.allowsMultipleSelection = true
        fsCalendar.appearance.todayColor = UIColor.brown
        fsCalendar.appearance.titleTodayColor = UIColor.white
        fsCalendar.appearance.headerTitleColor = UIColor.black
        fsCalendar.appearance.headerTitleFont = UIFont(name: "HelveticaNeue-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        fsCalendar.appearance.weekdayTextColor = UIColor.black
        fsCalendar.appearance.weekdayFont = UIFont(name: "HelveticaNeue-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15)
        fsCalendar.appearance.selectionColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimaryLighter ?? "")
        fsCalendar.appearance.titleSelectionColor = UIColor.darkText
    }
    
    func selectCalendarBetween(firstDate: Date?, lastDate: Date?) {
        self.firstDate = firstDate
        self.lastDate = lastDate
        
        if self.firstDate != nil && self.lastDate != nil {
        
            let range = Date.getRangeBetween(firstDate: self.firstDate!, lastDate: lastDate!)
            self.lastDate = range.last
            
            for tmpDate in range {
                fsCalendar.select(tmpDate)
            }
            
            datesRange = range
            
            lblDates.text = "\(self.firstDate!.toString(format: "EE dd/MM")) - \(self.lastDate!.toString(format: "EE dd/MM"))"
            
//            let numOfNights = self.firstDate!.calculateNightsToDate(date: self.lastDate!)
//            lblNights.text = numOfNights == 1 ? "\(numOfNights) Night" : "\(numOfNights) Nights"
            
            btnApply.isEnabled = true
        }
    }
    
    func selectCalendar(date: Date?) {
        if date != nil {
            fsCalendar.select(date!)
            btnApply.isEnabled = true
        }
    }
    
    class func open(firstDate: Date?, lastDate: Date?, delegate: CalendarPickerDelegate?, multipleSelection: Bool) {
        picker = CalendarPickerVC(nibName: "CalendarPickerVC", bundle: Bundle.main)
        picker?.delegate = delegate
        picker?.modalPresentationStyle = .custom
        picker?.transitioningDelegate = picker
        picker?.firstDate = firstDate
        picker?.lastDate = lastDate
        picker?.multipleSelection = multipleSelection
        
        if picker != nil {
            UIApplication.shared.keyWindow?.rootViewController?.present(picker!, animated: true, completion: nil)
        }
    }
    
    class func close() {
        if CalendarPickerVC.picker != nil {
            CalendarPickerVC.picker?.dismiss(animated: true, completion: nil)
        }
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date().addDays(days: -365)
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date.oneYearFromNow()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        lblDates.text = ""
        lblNights.text = ""
        
        if calendar.allowsMultipleSelection {
            
            if firstDate == nil {
                firstDate = date
                datesRange = [firstDate!]
                btnApply.isEnabled = false
                return
            }
            
            if firstDate != nil && lastDate == nil {
                if date <= firstDate! {
                    calendar.deselect(firstDate!)
                    firstDate = date
                    datesRange = [firstDate!]
                    btnApply.isEnabled = false
                    return
                }
                
                selectCalendarBetween(firstDate: firstDate!, lastDate: date)
                
                return
                
            }
            
            if firstDate != nil && lastDate != nil {
                calendar.deselectAll()
                firstDate = nil
                lastDate = nil
                btnApply.isEnabled = false
                datesRange = []
                
                firstDate = date
                calendar.select(date)
                datesRange = [firstDate!]
            }
        }
            
        else {
            firstDate = date
            calendar.deselectAll()
            selectCalendar(date: firstDate)
            btnApply.isEnabled = true
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar.allowsMultipleSelection {
            if firstDate != nil && lastDate != nil {
                calendar.deselectAll()
                firstDate = nil
                lastDate = nil
                lblDates.text = ""
                lblNights.text = ""
                btnApply.isEnabled = false
                datesRange = []
            }
        }
        else {
            firstDate = nil
            calendar.deselectAll()
            btnApply.isEnabled = false
            lblDates.text = ""
            lblNights.text = ""
        }
    }
    
    @IBAction func btnApplyAction(_ sender: Any) {
        if fsCalendar.allowsMultipleSelection {
            if firstDate != nil && lastDate != nil {
                self.delegate?.datesSelected?(firstDate: firstDate!, lastDate: lastDate!)
                CalendarPickerVC.close()
            }
        }
        else {
            if firstDate != nil {
                self.delegate?.dateSelected?(date: firstDate!)
                CalendarPickerVC.close()
            }
        }
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        CalendarPickerVC.close()
    }
    
}

extension FSCalendar {
    
    /**
     Deselects all selected dates of the calendar.
     */
    func deselectAll() {
        for date in self.selectedDates {
            self.deselect(date)
        }
    }
    
}
