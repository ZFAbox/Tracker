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
    
    static var lunchScreeBlue = UIColor.rgbColors(red: 55, green: 114, blue: 231, alpha: 1)
}
