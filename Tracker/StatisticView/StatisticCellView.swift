//
//  StatisticViewCell.swift
//  Tracker
//
//  Created by Федор Завьялов on 20.09.2024.
//

import Foundation
import UIKit


final class StatisticCellView: UITableViewCell {
    
    lazy var statisticCountValue: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont(name: "SFProDisplay-Bold", size: 34)
        lable.text = "1"
        lable.textColor = .trackerBlack
        return lable
    }()
    
    lazy var statisticSectionName: UILabel = {
        let lable = UILabel()
        lable.font = UIFont(name: "SFProDisplay-Medium", size: 12)
        lable.text = ""
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = .trackerBlack
        return lable
        
    }()
    
    private lazy var gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var textView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .trackerWhite
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .trackerWhite
        addSubviews()
        setConstraints()
        traitCollectionDidChange(.current)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle == .dark {
            textView.backgroundColor = .trackerBlack
            contentView.backgroundColor = .trackerBlack
            statisticCountValue.textColor = .trackerWhite
            statisticSectionName.textColor = .trackerWhite
        } else {
            textView.backgroundColor = .trackerWhite
            contentView.backgroundColor = .trackerWhite
            statisticCountValue.textColor = .trackerBlack
            statisticSectionName.textColor = .trackerBlack
        }
    }
    
    func setGradientBackground(view: UIView) {
        let colorLeft =  UIColor.rgbColors(red: 253, green: 76, blue: 73, alpha: 1).cgColor
        let colorCenter = UIColor.rgbColors(red: 70, green: 230, blue: 157, alpha: 1).cgColor
        let colorRight = UIColor.rgbColors(red: 0, green: 123, blue: 250, alpha: 1).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorLeft, colorCenter, colorRight]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width - 32, height: 102)
                
//        self.gradientView.layer.insertSublayer(gradientLayer, at:0)
        self.gradientView.layer.addSublayer(gradientLayer)
    }
    
    
    private func addSubviews() {
        contentView.addSubview(gradientView)
        contentView.addSubview(textView)
        contentView.addSubview(statisticSectionName)
        contentView.addSubview(statisticCountValue)
    }
    
    private func setConstraints(){
        setGradienViewConstraints()
        setTextViewConstraints()
        setCountViewConstraints()
        setSectionNameViewConstraints()
    }
    
    private func setGradienViewConstraints(){
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
    
    private func setTextViewConstraints(){
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7)
        ])
    }
    
    private func setCountViewConstraints(){
        NSLayoutConstraint.activate([
            statisticCountValue.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 12),
            statisticCountValue.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 12)
        ])
    }
    
    private func setSectionNameViewConstraints(){
        NSLayoutConstraint.activate([
            statisticSectionName.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 12),
            statisticSectionName.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -12)
        ])
    }
}
