//
//  TrackerCategoriesListCell.swift
//  Tracker
//
//  Created by Fedor on 14.08.2024.
//

import Foundation
import UIKit

final class TrackerCategoriesListCell: UITableViewCell {
    
    lazy var categoryName: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Категория"
        lable.textColor = .trackerBlack
        lable.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        return lable
    }()
    
    lazy var accessoryImageView: UIImageView = {
        let  defaultImage = UIImage(systemName: "chevron.right")
        let  imageView = UIImageView(image: defaultImage)
        imageView.tintColor = .trackerDarkGray
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        addSubiews()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubiews(){
        contentView.addSubview(categoryName)
    }
    
    func setConstraints(){
        
    }
    
}
