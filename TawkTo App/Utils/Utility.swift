//
//  Utility.swift
//  Track App
//
//  Created by Maribeth-Santillan on 6/17/20.
//  Copyright © 2020 Maribeth-Santillan. All rights reserved.
//

import Foundation
import UIKit


class Utility {
    
}

func formatNumber(_ number: Double) -> String? {
    
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 2 // minimum number of fraction digits on right
    formatter.maximumFractionDigits = 3 // maximum number of fraction digits on right, or comment for all available
    formatter.minimumIntegerDigits = 1 // minimum number of integer digits on left (necessary so that 0.5 don't return .500)
    
    let formattedNumber = formatter.string(from: NSNumber.init(value: number))
    
    return formattedNumber
    
}


func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
    
}



extension UIButton{
    
    
    func roundedButton(){
        
        let maskLayer = CAShapeLayer()
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds, byRoundingCorners:[.topLeft , .bottomRight, .topRight, .bottomLeft], cornerRadii: CGSize(width: 10.0, height: 10.0) )
        
        
        maskLayer.frame = self.bounds
        maskLayer.path = maskPAth1.cgPath
        self.layer.mask = maskLayer
        
    }
    
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

let imgCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        if url == nil {return}
        self.image = nil

        /* check cached image */
        if let cachedImage = imgCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        /* if not, download image from url */
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imgCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }

        }).resume()
    }
}

extension Int {
    var stringValue:String {
        return "\(self)"
    }
}

