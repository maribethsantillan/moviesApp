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
