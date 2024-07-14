//
//  TrackerCreateViewCell.swift
//  Tracker
//
//  Created by Федор Завьялов on 14.07.2024.
//

import Foundation
import UIKit

class TrackerCreateViewCell: UITableViewCell {
    
    lazy var lableStackView: UIStackView = {
        let vStack = UIStackView()
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 2
        vStack.distribution = .fillEqually
        return vStack
    }()
    
    
    lazy var mainTitle: UILabel = {
        let titleLable = UILabel()
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.text = "Категория"
        titleLable.textColor = .trackerBlack
        titleLable.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        return titleLable
    }()
    
    
    lazy var additionalTitle: UILabel = {
        let titleLable = UILabel()
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.textColor = .trackerDarkGray
        titleLable.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        return titleLable
    }()
    
    lazy var accessoryImageView: UIImageView = {
        let  defaultImage = UIImage(systemName: "chevron.right")
        let  imageView = UIImageView(image: defaultImage)
        imageView.tintColor = .trackerDarkGray
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        lableStackView.addArrangedSubview(mainTitle)
        addSubiews()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubiews(){
        contentView.addSubview(lableStackView)
//        contentView.addSubview(accessoryImageView)
    }
    
    func setConstraints(){
        setLableStackViewConstraints()
//        setAccessotyImageViewConstraints()
    }
    
    func setLableStackViewConstraints(){
        NSLayoutConstraint.activate([
            lableStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            lableStackView.heightAnchor.constraint(equalToConstant: 46),
//            lableStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lableStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
//    func setAccessotyImageViewConstraints(){
//        NSLayoutConstraint.activate([
//            accessoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -24),
//            accessoryImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            accessoryImageView.heightAnchor.constraint(equalToConstant: 12),
//            accessoryImageView.widthAnchor.constraint(equalToConstant: 7)
//        ])
//    }
    
}
