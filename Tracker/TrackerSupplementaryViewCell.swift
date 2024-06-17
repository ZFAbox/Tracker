//
//  TrackerSupplementaryViewCell.swift
//  Tracker
//
//  Created by Федор Завьялов on 18.06.2024.
//

import Foundation
import UIKit

class TrackerSupplementaryViewCell: UICollectionReusableView {
    
    var titleLable = UILabel()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        addSubview(titleLable)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLable.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
