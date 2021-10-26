//
//  OBSWebImage.swift
//  lacpa
//
//  Created by Nadim Henoud on 3/20/19.
//  Copyright © 2019 OBSoft. All rights reserved.
//

import UIKit

class OBSWebImage:UIImageView {
    
}

extension UIImageView {
    func imageWithUrl(urlString: String, withPlaceHolder: UIImage? = nil) {
        if(withPlaceHolder != nil){
            self.image = withPlaceHolder
        }
        if #available(iOS 13.0, *) {
            self.imageWithUrl(urlString: urlString, indicatorStyle: UIActivityIndicatorView.Style.medium)
        } else {
                        self.imageWithUrl(urlString: urlString, indicatorStyle: UIActivityIndicatorView.Style.white)
        }
    }
    func imageWithUrl(urlString: String, with label: UILabel) {
        if #available(iOS 13.0, *) {
            self.imageWithUrl(urlString: urlString, label: label, indicatorStyle: UIActivityIndicatorView.Style.medium)
        } else {
            self.imageWithUrl(urlString: urlString, label: label, indicatorStyle: UIActivityIndicatorView.Style.white)
        }
    }
    func imageWithUrl(urlString: String, label: UILabel? = nil, indicatorStyle: UIActivityIndicatorView.Style) {
        let indicator = UIActivityIndicatorView(style: indicatorStyle)
        indicator.frame.origin = CGPoint(x: self.frame.midX-indicator.frame.size.width/2,y: self.frame.midY-indicator.frame.size.height)
        self.addSubview(indicator)
        indicator.startAnimating()
        
        if label != nil {
            label?.frame.origin = CGPoint(x: self.frame.midX-label!.frame.size.width/2,y: self.frame.midY+label!.frame.size.height+8)
            self.addSubview(label!)
        }
        self.image = nil
        UIImage.download(urlString: urlString) { (url, img) in
            /// If the loaded URL != current URL the image has changed, don't add it to the view
            if(url != urlString) {
                return
            }
            self.image = img
            indicator.stopAnimating()
            if(img != nil) {
                label?.removeFromSuperview()
            }
        }
    }
}

extension UIImage {
    /// Save PNG in the Documents directory
    func save(_ name: String) {
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let url = URL(fileURLWithPath: path).appendingPathComponent(name)
        try! self.pngData()?.write(to: url)
        print("saved image at \(url)")
    }
    
    static func getImageFilename(urlString: String) -> String{
        let fileExt = URL(fileURLWithPath: urlString).pathExtension
        let fileName = "\(urlString.sha1().hexEncodedString()).\(fileExt)"
        return fileName
    }
    
    static func getImageFileURL(urlString: String) -> URL{
        let fn = UIImage.getImageFilename(urlString: urlString)
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsUrl.appendingPathComponent(fn)
        return fileURL
    }
    
    static func download(urlString: String, save:Bool=true, completion: ((String, UIImage?) -> ())?=nil) {
        let fileExt = URL(fileURLWithPath: urlString).pathExtension
        let fileName = "\(urlString.sha1().hexEncodedString()).\(fileExt)"
        guard let image = UIImage.load(fileName: fileName) else {
            if let url = URL(string: urlString.safeURL()) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let httpURLResponse = response as? HTTPURLResponse,
                        httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                        let data = data, error == nil,
                        let image = UIImage(data: data) else {
                            DispatchQueue.main.async() { () -> Void in
                                print("\(String(describing: response?.url)) NOT LOADED")
                                completion?(urlString, nil)
                            }
                            return
                    }
                    DispatchQueue.main.async() { () -> Void in
                        image.save(fileName);
                        completion?(urlString, image)
                    }
                }.resume()
            } else {
                completion?(urlString, nil)
            }
            return;
        }
        completion?(urlString, image)
    }
    
    static func load(fileName: String, download:Bool=false) -> UIImage? {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    func tint(_ color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        
        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    // fills the alpha channel of the source image with the given color
    // any color information except to the alpha channel will be ignored
    func fillAlpha(_ fillColor: UIColor) -> UIImage {
        
        return modifiedImage { context, rect in
            // draw tint color
            context.setBlendMode(.normal)
            fillColor.setFill()
            context.fill(rect)
            
            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }
    
    
    fileprivate func modifiedImage(_ draw: (CGContext, CGRect) -> ()) -> UIImage {
        
        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)
        
        // correctly rotate image
        context.translateBy(x: 0, y: size.height);
        context.scaleBy(x: 1.0, y: -1.0);
        
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        
        draw(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
