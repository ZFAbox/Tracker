//
//  EmojiAndColorsSupplementaryView.swift
//  Tracker
//
//  Created by Федор Завьялов on 07.07.2024.
//

import Foundation
import UIKit

class EmojiAndColorsSupplementaryViewCell: UICollectionReusableView {
    
    var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.font = UIFont(name: "SFProDisplay-Bold", size: 19)
        return titleLable
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        addSubview(titleLable)
        
        NSLayoutConstraint.activate([
            titleLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLable.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EmojiAndColorSupplementaryHeaderView {
    
    static let shared = EmojiAndColorsSupplementaryViewCell(frame: .zero)
    
}
