//
//  UIColor+Hex Extension.swift
//  Tracker
//
//  Created by Федор Завьялов on 26.07.2024.
//

import Foundation
import UIKit

extension UIColor {
    
        static func getHexColor(from color: UIColor) -> String {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            
            color.getRed(&r, green: &g, blue: &b, alpha: nil)
            
            var rHex = r == 0 ? "00" : String(Int(r * 255), radix: 16)
            var gHex = g == 0 ? "00" : String(Int(g * 255), radix: 16)
            var bHex = b == 0 ? "00" : String(Int(b * 255), radix: 16)
            
            
            rHex = rHex.count < 2 ? "0" + rHex: rHex
            gHex = gHex.count < 2 ? "0" + gHex: gHex
            bHex = bHex.count < 2 ? "0" + bHex: bHex
            let hexString = "#" + rHex + gHex + bHex
            return hexString
        }
        
        static func getUIColor(from hexString: String) -> UIColor {
            
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            
            var numbers: [Int] = []
            let hex = hexString.dropFirst().lowercased()
            var number = 0
            for character in hex {
                switch character {
                case "a": number = 10
                case "b": number = 11
                case "c": number = 12
                case "d": number = 13
                case "e": number = 14
                case "f": number = 15
                default: if let parameter = Int(String(character)) {
                    number = parameter
                }
                }
                numbers.append(number)
            }
            //        print(numbers)
            r = CGFloat( numbers[0] * 16 + numbers[1] * 1)
            g = CGFloat( numbers[2] * 16 + numbers[3] * 1)
            b = CGFloat( numbers[4] * 16 + numbers[5] * 1)
            
            let color = UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
            return color
        }
        
    }


