//
//  FilterTableViewCell.swift
//  Tracker
//
//  Created by Fedor on 18.09.2024.


import Foundation
import UIKit

final class FilterTableViewCell: UITableViewCell {
    
    private lazy var filterName: UILabel = {
        let lable = UILabel()
        lable.text = "Категория"
        lable.textColor = .generalTextColor
        lable.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        return lable
    }()
    
    private lazy var checkMark: UIImageView = {
        let  image = UIImage(named: "Check Mark")
        let  imageView = UIImageView(image: image)
        imageView.tintColor = .trackerBlue
        return imageView
    }()
    
    private lazy var separatorView: UIView = {
        let separator = UIView()
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
    
    func setFilterNameText(_ filterNameText: String) {
        self.filterName.text = filterNameText
    }
    
    func getFilterNameText() -> String {
        guard let filterNameText = self.filterName.text else { return "" }
        return filterNameText
    }
    func checkMarkIsHidden(_ isHidden: Bool){
        self.checkMark.isHidden = isHidden
    }
    
    func separateViewIsHidden(_ isHidden: Bool){
        self.separatorView.isHidden = isHidden
    }
    
    func isCheckMarkHidden() -> Bool{
        return self.checkMark.isHidden
    }
    
    private func addSubiews(){
        [filterName, separatorView, checkMark].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subView)
        }
    }
    
    private func setConstraints(){
        setCategoryNameConstraints()
        setSeparatorConstraints()
        setCheckMarkConstraints()
    }
    
    private func setCategoryNameConstraints (){
        NSLayoutConstraint.activate([
            filterName.topAnchor.constraint(equalTo: contentView.topAnchor),
            filterName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            filterName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setCheckMarkConstraints (){
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

