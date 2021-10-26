//
//  Utils.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/23/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    /**
     Convert from Fahrenheit to Celsius.
     - parameter fahrenheit: The temperature in Fahrenheit to convert.
     - Returns:
     celcius: The temperature in Celcius
     */
    class func convertToCelsius(fahrenheit: Double) -> Double {
        // apply formula from fahrenheit to celsius
        return (fahrenheit-32) * 5/9
    }
    
    /**
     Convert from Celcius to Fahrenheit.
     - parameter celcius: The temperature in Celcius to convert.
     - Returns:
     fahrenheit: The temperature in Fahrenheit
     */
    class func convertToFahrenheit(celsius: Double) -> Double {
        // apply formula from celsius to fahrenheit
        return (celsius*9/5) + 32
    }
    
    /**
     Convert from Degrees to Radians.
     - parameter degrees: The angle to convert in degrees.
     - Returns:
     radians: The angle in radians
     */
    class func deg2rad(degrees: Double) -> Double {
        return degrees * .pi / 180
    }
    
    /**
     Convert from Radians to Degrees.
     - parameter radians: The angle to convert in radians.
     - Returns:
     degrees: The angle in degrees
     */
    class func rad2deg(radians: Double) -> Double {
        return radians * 180 / .pi
    }
    
    /**
     Checks if email has a valid format.
     - parameter email: The email to validate.
     - Returns:
     valid: Bool value to determine if email is valid or not.
     */
    class func isEmailValid(_ email:String?) -> Bool {
        // Create the custom regular expression for the email validation
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        // NSPredicate to filter the string within the given regular expression
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email)
    }
    
    /**
    Checks if password is conform to the saved hex.
    - parameter password: the password string.
    - Returns:
    valid: Bool value to determine if password is valid or not.
    */
    class func checkPasswordFormat(password: String) -> Bool{
//        let regex = try! NSRegularExpression(pattern: #"/^(?=.\d)(?=.[a-z])(?=.[A-Z])(?=.[\W_]).{8,}$/"#)
        let regex = try! NSRegularExpression(pattern: #"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\S+$).{8,}$"#)
        let range = NSRange(location: 0, length: password.utf16.count)
        
        let isValid = regex.firstMatch(in: password, options: [], range: range) != nil
        
        return  isValid
    }
    
    /**
     Checks if credit card date is valid compared to current date.
     - parameter expiryMonth: Month of the expiry date.
     - parameter expiryYear: Year of the expiry date.
     - Returns:
     valid: Bool value to determine if creditcard date is valid or not.
     */
    class func isCreditCardDateValid(_ expiryMonth:String,_ expiryYear:String)->Bool{
        if (expiryMonth == "" || expiryYear == ""){
            return false
        }
        let currentDate = Date()
        let dateCreditCard = "\(expiryMonth) \(expiryYear)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let dateObj = dateFormatter.date(from: dateCreditCard)
        if dateObj?.compare(currentDate as Date) == ComparisonResult.orderedAscending{
            return false
        }
        return true
    }
    
    /**
     Converts an array of dictionaries to JSON string.
     - parameter array: The array to convert.
     - parameter options: Writing options for the JSONSerialization. Can be nil. Is set to .prettyPrinted by default.
     - Returns:
     json: Serialized JSON String.
     */
    class func toJSONString(array:[[String:AnyObject]], options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let dat = try? JSONSerialization.data(withJSONObject: array, options: options) {
            let str = String(data: dat, encoding: String.Encoding.utf8) ?? ""
            return str
        }
        return "[]"
    }
    
    /**
     Converts an array of Any to JSON string.
     - parameter array: The array to convert.
     - parameter options: Writing options for the JSONSerialization. Can be nil. Is set to .prettyPrinted by default.
     - Returns:
     json: Serialized JSON String.
     */
    class func toJSON(object:Any) -> String {
        if let dat = try? JSONSerialization.data(withJSONObject: object, options: []) {
            let str = String(data: dat, encoding: String.Encoding.utf8) ?? ""
            return str
        }
        return "!!NOT JSON STRUCTURE!!"
    }
    
    /**
     Converts date string  with timezone to local date string.
     - parameter dateStr: the date string.
     - parameter timeZone: the timezone code which is UTC by default.
     - parameter timeZone: the timezone code which is UTC by default.
     - Returns:
        formatted data
     */
    class func dateStringToLocal(dateStr: String, timeZone: String = "UTC", format: String = "yyyy-MM-dd HH:mm:ss") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = format
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    /**
     Attempts to call the given number.
     - parameter phoneNumber: The number to call.
     */
    class func callPhone(phoneNumber: String?, vc: UIViewController) {
        let phoneUrl = URL(string: "tel://\(phoneNumber ?? "")")
        if phoneUrl == nil {
            vc.showAlertWithCompletion(title: "Error", message: "Phone number invalid.", okTitle: "Ok", cancelTitle: nil, completionBlock: nil)
            return
        }
        if UIApplication.shared.canOpenURL(phoneUrl!) {
            UIApplication.shared.open(phoneUrl!, options: [:], completionHandler: nil)
        }
        else {
            vc.showAlertWithCompletion(title: "Error", message: "There was an error calling the number.", okTitle: "Ok", cancelTitle: nil, completionBlock: nil)
        }
    }
    
}

class ALog: NSObject {
    
    /**
     An extended debugger for the console.
     - parameter object: The object to print in the console.
     */
    class func d(object: Any?, fileName:String = #file, line:Int = #line, column:Int = #column, funcName:String = #function) {
        #if DEBUG
        print("Time: \(Date().toString(format: "HH:mm:ss.SSS")). ::DEBUG:: \(funcName) in \(URL(string: fileName)?.lastPathComponent ?? "") (line \(line)) --> \(object ?? "Object is nil")")
        #endif
    }
    
}
