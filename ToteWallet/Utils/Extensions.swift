//
//  Extensions.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 10/23/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//
import UIKit
import JGProgressHUD
import SideMenu

// MARK: UIViewController extension

extension UIViewController {
    
    private static var coConfig = [String:Bool]()
    
    var FuncCalledOnce:Bool {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIViewController.coConfig[tmpAddress] ?? false
        }
        set {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIViewController.coConfig[tmpAddress] = newValue
        }
    }
    
    func callOnce(funcToCall: () -> ()) {
        if !FuncCalledOnce {
            FuncCalledOnce = true
            funcToCall()
        }
    }
    
    /**
     Adds an action to the view controller that dismisses the keyboard on click.
     */
    func setupDismissOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        // Add the action to happen whenever the view is clicked, this case to dismiss keyboard
        self.view.addGestureRecognizer(tap)
    }
    
    /**
     Adds a toolbar to the keyboard  that dismisses the keyboard on "done" click.
     - parameter textfields: list of fields to add the toolbar to.
     - parameter colorHex: done button color hex.
     */
    func addDoneButtonOnKeyboard(colorHex: String = ConfigurationManager.getAppConfiguration().themeBGColorHexPrimary ?? "") {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        
        done.tintColor = UIColor(hex: colorHex)
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        for case let textField in getAllTextFields(fromView: self.view) {
            textField.inputAccessoryView = doneToolbar
        }
    }
    
    /**
     Gets a list of all the textfields for a view.
     - parameter fromView: the view to return the textfields for
     */
    func getAllTextFields(fromView view: UIView)-> [UITextField] {
        return view.subviews.flatMap { (view) -> [UITextField]? in
            if view is UITextField {
                return [(view as! UITextField)]
            } else {
                return getAllTextFields(fromView: view)
            }
        }.flatMap({$0})
    }
    
    /**
     Shows an alert popup with a custom message and optional cancel button.
     - parameter title: The title of the error popup.
     - parameter message: The message to display.
     - parameter okTitle: The text of the Confirm button.
     - parameter cancelTitle: The text of the Cancel button. This is optional, and if set as nil the Cancel button will not be added to the popup.
     - parameter completionBlock: The action that happens when clicking the confirmation button. This can be nil.
     */
    func showAlertWithCompletion(title:String = "Tote Wallet", message:String, okTitle:String, cancelTitle:String?, completionBlock: (() -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = UIColor(hexString: ConfigurationManager.getAppConfiguration().themeBGColorHexPrimaryLighter ?? "")
        
        let okAction = UIAlertAction(title: okTitle, style: .default) {
           UIAlertAction in
           completionBlock?()
        }

        if(cancelTitle != nil && cancelTitle != ""){
            let cancelAction = UIAlertAction(title: cancelTitle, style: .default) {
               UIAlertAction in
            }
            alertController.addAction(cancelAction)
        }
                
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /**
     Checks if the segueway exists for the given identifier.
     - parameter identifier: The identifier string of the segue.
     - Returns:
     canPerform: Bool value to determine if the segue exists for the given identifier.
     */
    func canPerformSegue(identifier: String) -> Bool {
        guard let identifiers = value(forKey: "storyboardSegueTemplates") as? [NSObject] else {
            return false
        }
        
        let canPerform = identifiers.contains { (object) -> Bool in
            if let id = object.value(forKey: "_identifier") as? String {
                if id == identifier {
                    return true
                }
                else {
                    return false
                }
            }
            else {
                return false
            }
        }
        
        return canPerform
    }
    
    /**
     Perform the segueway if the segueway exists for the given identifier.
     - parameter identifier: The identifier string of the segue.
     */
    func performSegueIfPossible(identifier: String) {
        if canPerformSegue(identifier: identifier) {
            performSegue(withIdentifier: identifier, sender: self)
        }
    }
    
    /**
     Registers callback events for when the keyboard will open and will close.
     Override keyboardWillShow() and keyboardWillHide() to implement the needed logic.
     */
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // Override this function in ViewController for listening to notification
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // Override this function in ViewController for listening to notification
    }
    
    /**
     Dismisses the keyboard in the current view controller.
     */
    @objc func dismissKeyboard() {
        // dismisses the keyboad if it was open
        self.view.endEditing(true)
    }
    
    /**
     Shows a progress bar with a custom message.
     - parameter message: The message to display in the progress bar.
     */
    @objc func showProgressBar(message: String = "Loading..."){
        let hud = JGProgressHUD(style: .light)
        hud.parallaxMode = JGProgressHUDParallaxMode.alwaysOn
        hud.textLabel.text = message
        hud.show(in: self.view)
    }
    
    /**
     Hides the progress bar.
     */
    @objc func hideProgressBar(){
        let huds = JGProgressHUD.allProgressHUDs(in: self.view)
        if(huds.count > 0){
            for hud in huds {
                hud.dismiss(animated: true)
            }
        }
    }
    
    /**
    Shows the SideBar Menu.
    */
    func revealMenu() {
        if let menu = storyboard!.instantiateViewController(withIdentifier: "LeftMenu") as? SideMenuNavigationController {
            present(menu, animated: true, completion: nil)
        }
    }
    
    /**
    Shows the SideBar Menu.
    */
    func presentSideMenu() {
        let sideMenuNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuNav") as! SideMenuNavigationController
        self.present(sideMenuNav, animated: true, completion: nil)
    }

}

// MARK: CollectionView Extension

extension UICollectionView {
    
    func customRegisterForCell(identifier:String) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
}

// MARK: UIButton Extension

extension UIButton
{
}

// MARK: TableView Extension

extension UITableView {
    
    func customRegisterForCell(identifiers: [String]) {
        for identifier in identifiers {
            self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
    }
    
}

// MARK: TimeInterval Extension

extension TimeInterval {
    
    func formatted() -> String {
        let time = NSInteger(self)
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        var string = ""
        string += (hours > 0) ? String(format: "%dh ", hours) : ""
        string += (minutes > 0) ? String(format: "%dm ", minutes) : ""
        string += (seconds > 0) ? String(format: "%d", seconds) : ""
        string += (ms > 0) ? "" : "s"
        string += (ms > 0) ? String(format: ".%d", ms) : ""
        string += (ms > 0) ? "s" : ""
        return string
    }
    
}

// MARK: Double extension

extension Double {
    
    func priceFormatWithTwoDigits()-> String{
        // returns a string of the number with two decimal places
        return String(format: "%.2f", self)
    }
    
    var float:CGFloat {
        return CGFloat(self)
    }
    
}

extension Float {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

// MARK: Date extension

extension Date {
    
    // CLASS METHODS
    
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        // get full date string from date selected
        let string = formatter.string(from: self)
        // get date from full date string
        let date = formatter.date(from: string)
        // set the date format specified
        formatter.dateFormat = format
        
        return formatter.string(from: date!)
    }
    
    func calculateNightsToDate(date: Date) -> Int {
        let calendar = NSCalendar.current
        return abs(calendar.dateComponents([.day], from: calendar.startOfDay(for: self), to: calendar.startOfDay(for: date)).day!)
    }
    
    func isToday() -> Bool {
        return (Calendar.current as NSCalendar).isDateInToday(self)
    }
    
    mutating func addOneDay() {
        self = (Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to: self, options: [])!
    }
    
    mutating func removeOneDay() {
        self = (Calendar.current as NSCalendar).date(byAdding: .day, value: -1, to: self, options: [])!
    }
    
    mutating func addOneYear() {
        self = (Calendar.current as NSCalendar).date(byAdding: .year, value: 1, to: self, options: [])!
    }
    
    func addYears(years:Int) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .year, value: years, to: self, options: [])!
    }
    
    func addDays(days:Int) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: days, to: self, options: [])!
    }
    
    func addMinutes(minutes:Int) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .minute, value: minutes, to: self, options: [])!
    }
    
    func addSeconds(seconds:Int) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .second, value: seconds, to: self, options: [])!
    }
    
    func extractTimeFromDate() -> String{
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        let period = hour > 12 ? "PM" : "AM"
        let fullTime = "\(hour < 10 ? "0\(hour)" : "\(hour)"):\(minutes < 10 ? "0\(minutes)" : "\(minutes)") \(period)"
        
        return fullTime
    }
    
    // STATIC METHODS
    
    static func getTodayWithoutTime() -> Date {
        return Date().toString(format: "yyyy-MM-dd").toDate(format: "yyyy-MM-dd")
    }
    
    static func daysFromNowWithoutTime(days: Int) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: days, to: Date.getTodayWithoutTime(), options: [])!
    }
    
    static func daysFromNow(days: Int) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: days, to: Date(), options: [])!
    }
    
    static func nextMonth() -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .month, value: 1, to: Date(), options: [])!
    }
    
    static func previousMonth() -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .month, value: -1, to: Date(), options: [])!
    }
    
    static func oneYearFromNow() -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .year, value: 1, to: Date(), options: [])!
    }
    
    static func getRangeBetween(firstDate: Date, lastDate: Date) -> [Date] {
        if firstDate > lastDate { return [Date]() }
        
        var tempDate = firstDate
        var array = [tempDate]
        
        while tempDate < lastDate {
            tempDate.addOneDay()
            array.append(tempDate)
        }
        
        return array
    }
    
    func toString(dateFormat format : String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

// MARK: UIColor extension

extension UIColor {
   
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(rgb:0xAAAAAA)
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let red   = CGFloat(Int(color >> 16) & 0x000000FF) / 255.0
        let green = CGFloat(Int(color >> 8) & 0x000000FF) / 255.0
        let blue  = CGFloat(Int(color) & 0x000000FF) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return self
        }
    }
    
}

// MARK: UIView extension

extension UIView {
    
    func addCornerRadius(corners: UIRectCorner, cornerRadius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func addCornerRadiusWithBorder(radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func rounded() {
        if self.frame.size.width != self.frame.size.height {
            ALog.d(object: "Width is not equals to height. Will not be circular.")
        }
        self.layer.cornerRadius = self.frame.size.height/2.0
        self.layer.masksToBounds = true
    }
    
    func addGradientBackgroundWithFrame(colors: [CGColor], startPoint:CGPoint, endPoint:CGPoint, frame:CGRect) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.3
        animation.values = [-20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
    
    func startLoadingAnimation(duration:CGFloat) {
        self.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.clipsToBounds = true
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: -self.bounds.width, y: -self.bounds.height, width: self.bounds.width*3, height: self.bounds.height*3)
        gradient.colors = [UIColor.clear.cgColor, UIColor.gray.cgColor, UIColor.gray.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0, 0.5, 0.5, 1]
        gradient.startPoint = CGPoint(x: -1, y: 0.4)
        gradient.endPoint = CGPoint(x: 0, y: 0.6)
        
        self.layer.addSublayer(gradient)
        
        let animation1 = CABasicAnimation(keyPath: "startPoint")
        animation1.fromValue = CGPoint(x: -1, y: 0.4)
        animation1.toValue = CGPoint(x: 1, y: 0.4)
        animation1.duration = CFTimeInterval(duration)
        animation1.repeatCount = Float.infinity
        gradient.add(animation1, forKey: "anim1")
        
        let animation2 = CABasicAnimation(keyPath: "endPoint")
        animation2.fromValue = CGPoint(x: 0, y: 0.6)
        animation2.toValue = CGPoint(x: 2, y: 0.6)
        animation2.duration = CFTimeInterval(duration)
        animation2.repeatCount = Float.infinity
        gradient.add(animation2, forKey: "anim2")
    }
    
    func stopLoadingAnimation() {
        self.layer.removeAllAnimations()
        if let sublayers = self.layer.sublayers {
            for case let sublayer as CAGradientLayer in sublayers {
                sublayer.removeAllAnimations()
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
    func addGradientBackground(colors: [CGColor], startPoint:CGPoint, endPoint:CGPoint) {
        addGradientBackgroundWithFrame(colors: colors, startPoint: startPoint, endPoint: endPoint, frame: self.bounds)
    }
    
    func addShadow(radius: CGFloat, offset: CGSize, color: UIColor = .lightGray, opacity: Float = 0.5) {
        self.layer.shadowPath =
            UIBezierPath(roundedRect: self.bounds,
                         cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    func addShadowWithTransparency(radius: CGFloat, offset: CGSize, opacity: Float = 0.5) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leftAnchor
        }
        return self.leftAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.rightAnchor
        }
        return self.rightAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
    }
    
}


// MARK: Dictionary extension

extension Dictionary {
    
    func prettyPrint() {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                ALog.d(object: "\n\(string)")
                return
            }
            ALog.d(object: "Could not parse data")
            return
        }
        ALog.d(object: "Coult not parse json data")
    }
    
}

// MARK: UISlider extension

extension UISlider {
    
    func changeThumbImage (_ image: UIImage, _ size: CGSize) {
        let img = image.resizeImage(toSize: size)
        self.setThumbImage(img, for: .normal)
        self.setThumbImage(img, for: .highlighted)
        self.setThumbImage(img, for: .focused)
        self.setThumbImage(img, for: .selected)
    }
    
}

// MARK: UIImage extension

extension UIImage {
    
    func resizeImage(toSize:CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(toSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: toSize.width, height: toSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func replace(color: UIColor, withColor replacingColor: UIColor) -> UIImage? {
        guard let inputCGImage = self.cgImage else {
            return nil
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            return nil
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        let inColor = RGBA32(color: color)
        let outColor = RGBA32(color: replacingColor)
        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                if pixelBuffer[offset] == inColor {
                    pixelBuffer[offset] = outColor
                }
            }
        }
        
        guard let outputCGImage = context.makeImage() else {
            return nil
        }
        return UIImage(cgImage: outputCGImage, scale: self.scale, orientation: self.imageOrientation)
    }
    
    struct RGBA32: Equatable {
        private var color: UInt32
        
        var redComponent: UInt8 {
            return UInt8((self.color >> 24) & 255)
        }
        
        var greenComponent: UInt8 {
            return UInt8((self.color >> 16) & 255)
        }
        
        var blueComponent: UInt8 {
            return UInt8((self.color >> 8) & 255)
        }
        
        var alphaComponent: UInt8 {
            return UInt8((self.color >> 0) & 255)
        }
        
        init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
            self.color = (UInt32(red) << 24) | (UInt32(green) << 16) | (UInt32(blue) << 8) | (UInt32(alpha) << 0)
        }
        
        init(color: UIColor) {
            let components = color.cgColor.components ?? [0.0, 0.0, 0.0, 1.0]
            let colors = components.map { UInt8($0 * 255) }
            self.init(red: colors[0], green: colors[1], blue: colors[2], alpha: colors[3])
        }
        
        static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
            return lhs.color == rhs.color
        }
        
    }
    
}

// MARK: Sequence extension

public extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.append(element) {
                categories[key] = [element]
            }
        }
        return categories
    }
    
    func categorise<U : Hashable>(_ key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var dict: [U:[Iterator.Element]] = [:]
        for el in self {
            let key = key(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}

// MARK: UITextView extension

extension UITextView {
    
    func customize (keyboardType: UIKeyboardType, autoCorrectionType: UITextAutocorrectionType, capitalizationType: UITextAutocapitalizationType, returnKeyType: UIReturnKeyType, isPassword: Bool) {
        self.keyboardType = keyboardType
        self.autocorrectionType = autoCorrectionType
        self.autocapitalizationType = capitalizationType
        self.returnKeyType = returnKeyType
        self.isSecureTextEntry = isPassword
    }
    
}

// MARK: CGFloat extension

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

// MARK: UILabel extension

extension UILabel {
    
    //    struct LConfiguration {
    //        var textAsAccent:Bool = false
    //    }
    //
    //    private static var lConfig = [String:LConfiguration]()
    //
    //    @IBInspectable var TextAsAccent:Bool {
    //        get {
    //            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
    //            return UILabel.lConfig[tmpAddress]?.textAsAccent ?? false
    //        }
    //        set {
    //            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
    //            UILabel.lConfig[tmpAddress]?.textAsAccent = newValue
    //        }
    //    }
    //
    //    open override func awakeFromNib() {
    //        super.awakeFromNib()
    //        if self.ApplyConfig {
    //            if self.TextAsAccent {
    //                if let color = ConfigurationManager.getAppConfiguration().themeBGColorHex {
    //                    self.textColor = UIColor(hexString: color)
    //                }
    //            }
    //            else {
    //                if let color = ConfigurationManager.getAppConfiguration().themeTextColorHex {
    //                    self.textColor = UIColor(hexString: color)
    //                }
    //            }
    //        }
    //    }
    
    func getActualLineNumber() -> Int {
        let height = self.text?.height(withConstrainedWidth: self.frame.size.width, font: self.font) ?? 0
        return lroundf(Float(height/self.font.lineHeight))
    }
    
    func getActualLineNumberForAttributeString() -> Int {
        let height = self.attributedText?.height(withConstrainedWidth: self.frame.size.width)
        return lroundf(Float(height ?? 0/self.font.lineHeight))
    }
}

// MARK: UITextField extension

extension UITextField {
    
    func setPadding(left:CGFloat, right:CGFloat) {
        let leftPaddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: 0))
        let rightPaddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: 0))
        self.leftView = leftPaddingView
        self.rightView = rightPaddingView
        self.leftViewMode = .always
        self.rightViewMode = .always
    }
    
    func setLeftImage(width:CGFloat, image:UIImage?, imageSize: CGSize) {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        let imageView = UIImageView(frame: CGRect(x: width/2 - imageSize.width/2, y: self.frame.height/2 - imageSize.height/2, width: imageSize.width, height: imageSize.height))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        leftPaddingView.addSubview(imageView)
        self.leftView = leftPaddingView
        self.leftViewMode = .always
    }
    
    func isEmptyString() -> Bool {
        return self.text == ""
    }
    
    func customize (keyboardType: UIKeyboardType, autoCorrectionType: UITextAutocorrectionType, capitalizationType: UITextAutocapitalizationType, returnKeyType: UIReturnKeyType, isPassword: Bool) {
        self.keyboardType = keyboardType
        self.autocorrectionType = autoCorrectionType
        self.autocapitalizationType = capitalizationType
        self.returnKeyType = returnKeyType
        self.isSecureTextEntry = isPassword
    }
    
    func setPlaceholderColor(color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
}

// MARK: Int extension

extension Int {
    
    func toStringwithSeparator(_ separator:String) -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = separator
        formatter.numberStyle = .decimal
        return formatter.string(for: self)!
    }
    
}

// MARK: UIImageView extension

extension UIImageView {
    
    func tint(color: UIColor) {
        self.image = self.image?.withRenderingMode(.automatic)
        self.tintColor = color
    }
    
}

// MARK: String extension

extension String {
    
    static func emptyOrNil(string: String?) -> Bool {
        return string == nil || string == ""
    }
    
    func plural(count:Int, uppercased:Bool) -> String {
        var str = self
        switch self.lowercased() {
        case "child":
            str.append(count != 1 ? "ren" : "")
        case "night","room","adult":
            str.append(count != 1 ? "s" : "")
        default:
            break
        }
        
        return uppercased ? str.uppercased() : str
    }
    
    func truncate(length: Int, trailing: String = "…") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        } else {
            return self
        }
    }
    
    static func htmlToString(html: String) -> String{
        let data = Data(html.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            return attributedString.string
        }
        return html
    }
    
    func encodeToHTML() -> String {
        let string = self as NSString
        return string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    func toDate(format: String) -> Date {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        return dateformatter.date(from: self)!
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizeFirstLetter()
    }
    
    func isEmptyString() -> Bool {
        return self == ""
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }

    func safeURL() -> String {
        return self.replacingOccurrences(of: " ", with: "%20")
    }
    
    func safeGetParams() -> String {
        let str = self.replacingOccurrences(of: ",", with: "%2C")
        return str.replacingOccurrences(of: " ", with: "+")
    }

}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension UINavigationController {
    
    func popToViewController(ofClass: AnyClass){
        
        if let vc = self.getViewControllerInStack(ofClass: ofClass) {
            popToViewController(vc, animated: true)
        }
        else{
            print("Couldn't Find Class In Stack")
        }
    }
    
    func getViewControllerInStack(ofClass: AnyClass) -> UIViewController?{
        for vc in self.viewControllers as [UIViewController] {
            if vc.isKind(of: ofClass) {
                return vc
            }
        }
        
        return nil
    }
    
}

extension NSSet {
    
    func toArray<T>() -> [T] {
        let array = self.map({ $0 as! T})
        return array
    }
}


extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
