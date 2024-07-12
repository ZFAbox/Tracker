//
//  Colors.swift
//  Tracker
//
//  Created by Федор Завьялов on 31.05.2024.
//

import Foundation
import UIKit

extension UIColor {
    
    static func rgbColors(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat ) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    
    static var trackerBlue = UIColor.rgbColors(red: 55, green: 114, blue: 231, alpha: 1)
    static var trackerBlack = UIColor.rgbColors(red: 26, green: 27, blue: 34, alpha: 1)
    static var trackerGray = UIColor.rgbColors(red: 240, green: 240, blue: 240, alpha: 1)
    static var trackerGreen = UIColor.rgbColors(red: 51, green: 207, blue: 105, alpha: 1)
    static var trackerOrnage = UIColor.rgbColors(red: 255, green: 136, blue: 30, alpha: 1)
    static var trackerDarkGray = UIColor.rgbColors(red: 174, green: 175, blue: 180, alpha: 1)
    static var trackerPink = UIColor.rgbColors(red: 245, green: 107, blue: 108, alpha: 1)
    static var ypWhite = UIColor.rgbColors(red: 245, green: 245, blue: 245, alpha: 1)
    static var trackerBackgroundOpacityGray =  UIColor.rgbColors(red: 230, green: 232, blue: 235, alpha: 0.3)
}
