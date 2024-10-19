//
//  TrackerCategoriesListCell.swift
//  Tracker
//
//  Created by Fedor on 14.08.2024.


import Foundation
import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    
    lazy var separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = .trackerDarkGrayOpacity70
        return separator
    }()
    
    lazy var switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        return switchButton
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
        [separatorView, switchButton].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subView)
        }
    }
    
    func setConstraints(){
        setSeparatorConstraints()
        setSwitcherConstraints()
    }
    
    private func setSeparatorConstraints(){
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setSwitcherConstraints(){
        NSLayoutConstraint.activate([
            switchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchButton.heightAnchor.constraint(equalToConstant: 31)
        ])
    }
    
}
