//
//  TrackerSupplementaryViewCell.swift
//  Tracker
//
//  Created by Федор Завьялов on 18.06.2024.
//

import Foundation
import UIKit

final class TrackerSupplementaryViewCell: UICollectionReusableView {
    
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
            titleLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLable.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class TrackerCollectionHeaderView {
    
    static let shared = TrackerSupplementaryViewCell(frame: .zero)
    private init() {}
    
}



