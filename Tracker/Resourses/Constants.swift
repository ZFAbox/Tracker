//
//  Constants.swift
//  Tracker
//
//  Created by Федор Завьялов on 09.07.2024.
//

import Foundation
import UIKit

struct Constants {
    
    static let colors: [UIColor] = [
        UIColor.rgbColors(red: 253, green: 76, blue: 73, alpha: 1),
        UIColor.rgbColors(red: 255, green: 136, blue: 30, alpha: 1),
        UIColor.rgbColors(red: 0, green: 123, blue: 250, alpha: 1),
        UIColor.rgbColors(red: 110, green: 68, blue: 254, alpha: 1),
        UIColor.rgbColors(red: 51, green: 207, blue: 105, alpha: 1),
        UIColor.rgbColors(red: 230, green: 109, blue: 212, alpha: 1),
        UIColor.rgbColors(red: 249, green: 212, blue: 212, alpha: 1),
        UIColor.rgbColors(red: 52, green: 167, blue: 254, alpha: 1),
        UIColor.rgbColors(red: 70, green: 230, blue: 157, alpha: 1),
        UIColor.rgbColors(red: 53, green: 52, blue: 124, alpha: 1),
        UIColor.rgbColors(red: 255, green: 103, blue: 77, alpha: 1),
        UIColor.rgbColors(red: 255, green: 153, blue: 204, alpha: 1),
        UIColor.rgbColors(red: 236, green: 196, blue: 139, alpha: 1),
        UIColor.rgbColors(red: 121, green: 148, blue: 245, alpha: 1),
        UIColor.rgbColors(red: 131, green: 44, blue: 241, alpha: 1),
        UIColor.rgbColors(red: 173, green: 86, blue: 218, alpha: 1),
        UIColor.rgbColors(red: 141, green: 214, blue: 230, alpha: 1),
        UIColor.rgbColors(red: 47, green: 208, blue: 88, alpha: 1)
    ]
    
    static let selectionColors: [UIColor] = [
        UIColor.rgbColors(red: 253, green: 76, blue: 73, alpha: 0.3),
        UIColor.rgbColors(red: 255, green: 136, blue: 30, alpha: 0.3),
        UIColor.rgbColors(red: 0, green: 123, blue: 250, alpha: 0.3),
        UIColor.rgbColors(red: 110, green: 68, blue: 254, alpha: 0.3),
        UIColor.rgbColors(red: 51, green: 207, blue: 105, alpha: 0.3),
        UIColor.rgbColors(red: 230, green: 109, blue: 212, alpha: 0.3),
        UIColor.rgbColors(red: 249, green: 212, blue: 212, alpha: 0.3),
        UIColor.rgbColors(red: 52, green: 167, blue: 254, alpha: 0.3),
        UIColor.rgbColors(red: 70, green: 230, blue: 157, alpha: 0.3),
        UIColor.rgbColors(red: 53, green: 52, blue: 124, alpha: 0.3),
        UIColor.rgbColors(red: 255, green: 103, blue: 77, alpha: 0.3),
        UIColor.rgbColors(red: 255, green: 153, blue: 204, alpha: 0.3),
        UIColor.rgbColors(red: 236, green: 196, blue: 139, alpha: 0.3),
        UIColor.rgbColors(red: 121, green: 148, blue: 245, alpha: 0.3),
        UIColor.rgbColors(red: 131, green: 44, blue: 241, alpha: 0.3),
        UIColor.rgbColors(red: 173, green: 86, blue: 218, alpha: 0.3),
        UIColor.rgbColors(red: 141, green: 214, blue: 230, alpha: 0.3),
        UIColor.rgbColors(red: 47, green: 208, blue: 88, alpha: 0.3)
    ]
    
    static let emoji: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    static func getColorIndex(selectedColor: UIColor?) -> Int {
        
        guard let selectedColor = selectedColor, let index = colors.firstIndex(of: selectedColor) else { return 0 }
        return index
    }
    
    static func getEmojiIndex(selectedEmoji: String?) -> Int {
        guard let selectedEmoji = selectedEmoji, let index = emoji.firstIndex(of: selectedEmoji) else { return 0 }
        return index
    }
}

