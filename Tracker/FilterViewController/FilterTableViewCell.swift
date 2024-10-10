//
//  FilterTableViewCell.swift
//  Tracker
//
//  Created by Fedor on 18.09.2024.


import Foundation
import UIKit

final class FilterTableViewCell: UITableViewCell {
    
    lazy var filterName: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Категория"
        lable.textColor = .trackerBlack
        lable.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        return lable
    }()
    
    lazy var checkMark: UIImageView = {
        let  image = UIImage(named: "Check Mark")
        let  imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .trackerBlue
        return imageView
    }()
    
    lazy var separatorView: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .trackerDarkGrayOpacity70
        return separator
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubiews()
        setConstraints()
        checkMark.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubiews(){
        contentView.addSubview(filterName)
        contentView.addSubview(separatorView)
        contentView.addSubview(checkMark)
    }
    
    func setConstraints(){
        setCategoryNameConstraints()
        setSeparatorConstraints()
        setCheckMarkConstraints()
    }
    
    func setCategoryNameConstraints (){
        NSLayoutConstraint.activate([
            filterName.topAnchor.constraint(equalTo: contentView.topAnchor),
            filterName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            filterName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setCheckMarkConstraints (){
        NSLayoutConstraint.activate([
            checkMark.centerYAnchor.constraint(equalTo: filterName.centerYAnchor),
            checkMark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21),
            checkMark.heightAnchor.constraint(equalToConstant: 14),
            checkMark.widthAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    private func setSeparatorConstraints(){
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
}

