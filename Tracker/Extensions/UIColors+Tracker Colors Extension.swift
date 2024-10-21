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
    
    //Ligth mode color set
    static var trackerBlue = UIColor.rgbColors(red: 55, green: 114, blue: 231, alpha: 1)
    static var trackerBorderDark = UIColor.rgbColors(red: 13, green: 13, blue: 17, alpha: 1)
    static var trackerBlack = UIColor.rgbColors(red: 26, green: 27, blue: 34, alpha: 1)
    static var trackerBlackOpacity30 = UIColor.rgbColors(red: 26, green: 27, blue: 34, alpha: 0.3)
    static var trackerGray = UIColor.rgbColors(red: 240, green: 240, blue: 240, alpha: 1)
    static var trackerGreen = UIColor.rgbColors(red: 51, green: 207, blue: 105, alpha: 1)
    static var trackerOrnage = UIColor.rgbColors(red: 255, green: 136, blue: 30, alpha: 1)
    static var trackerRed = UIColor.rgbColors(red: 255, green: 69, blue: 58, alpha: 1)
    static var trackerDarkGray = UIColor.rgbColors(red: 174, green: 175, blue: 180, alpha: 1)
    static var trackerDarkGrayOpacity30 = UIColor.rgbColors(red: 174, green: 175, blue: 180, alpha: 0.4)
    static var trackerDarkGrayOpacity70 = UIColor.rgbColors(red: 174, green: 175, blue: 180, alpha: 0.7)
    static var trackerPink = UIColor.rgbColors(red: 245, green: 107, blue: 108, alpha: 1)
    static var trackerWhite = UIColor.rgbColors(red: 245, green: 245, blue: 245, alpha: 1)
    static var trackerBackgroundOpacityGray =  UIColor.rgbColors(red: 230, green: 232, blue: 235, alpha: 0.4)
    static var trackerBackgroundOpacityDarkGray =  UIColor.rgbColors(red: 65, green: 65, blue: 65, alpha: 0.85)
    static var trackerEmojiSelectionGray =  UIColor.rgbColors(red: 230, green: 232, blue: 235, alpha: 1)
    
    //Dark and Ligth mode color set
    
    static let applicationBackgroundColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return trackerWhite
        } else {
            return trackerBlack
        }
    }
    
    static let titleTextColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return trackerBlack
        } else {
            return trackerWhite
        }
    }
    
    static let generalTextColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return trackerBlack
        } else {
            return trackerWhite
        }
    }
    
    static let darkButtonTextColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return trackerWhite
        } else {
            return trackerBlack
        }
    }
    
    static let darkButtonColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return trackerBlack
        } else {
            return trackerWhite
        }
    }
    
    static let tableCellBackgoundColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return trackerBackgroundOpacityGray
        } else {
            return trackerBackgroundOpacityDarkGray
        }
    }
    
    static let disableButtonColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return trackerDarkGray
        } else {
            return trackerDarkGray
        }
    }
    
    static let activeButtonColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return trackerBlack
        } else {
            return white
        }
    }
    
    static let disableButtonTextColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return white
        } else {
            return white
        }
    }
    
    static let activeButtonTextColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return trackerWhite
        } else {
            return trackerBlack
        }
    }
    
    static let daysLableColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return trackerBlack
        } else {
            return white
        }
    }
    
    static let textFiledColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return trackerBackgroundOpacityGray
        } else {
            return trackerBackgroundOpacityDarkGray
        }
    }
    
}
