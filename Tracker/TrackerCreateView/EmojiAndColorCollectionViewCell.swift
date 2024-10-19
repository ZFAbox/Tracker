//
//  EmojiAndColorsCollectionViewCell.swift
//  Tracker
//
//  Created by Федор Завьялов on 07.07.2024.
//

import Foundation
import UIKit

class EmojiAndColorCollectionViewCell:UICollectionViewCell {
    
    lazy var emoji: UILabel = {
        let emoji = UILabel()
        emoji.translatesAutoresizingMaskIntoConstraints = false
        emoji.text = "😂"
        emoji.font = UIFont(name: "SFProDisplay-Bold", size: 32)
        return emoji
    }()
    
    lazy var color: UIView = {
        let color = UIView()
        color.translatesAutoresizingMaskIntoConstraints = false
        color.layer.cornerRadius = 8
        color.clipsToBounds = true
        return color
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setConstrains()
        traitCollectionDidChange(.current)
    }
    
    func addSubViews(){
        self.addSubview(emoji)
        self.addSubview(color)
    }
    
    func setConstrains(){
        NSLayoutConstraint.activate([
            emoji.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            color.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            color.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            color.heightAnchor.constraint(equalToConstant: 40),
            color.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
