//
//  HabbitVreateView.swift
//  Tracker
//
//  Created by Федор Завьялов on 23.06.2024.
//

import Foundation
import UIKit

class HabbitCreateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let categoryAndScheduleArray = ["Категория, Расписание"]
    private let sectionHeader = ["Emoji","Цвет"]
    private let emoji: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    private let colors: [UIColor] = [
        UIColor.rgbColors(red: 253, green: 76, blue: 73, alpha: 1),
        UIColor.rgbColors(red: 255, green: 136, blue: 30, alpha: 1),
        UIColor.rgbColors(red: 0, green: 123, blue: 250, alpha: 1),
        UIColor.rgbColors(red: 110, green: 68, blue: 254, alpha: 1),
        UIColor.rgbColors(red: 51, green: 207, blue: 105, alpha: 1),
        UIColor.rgbColors(red: 230, green: 109, blue: 212, alpha: 1),
        UIColor.rgbColors(red: 249, green: 212, blue: 212, alpha: 1),
        UIColor.rgbColors(red: 52, green: 167, blue: 254, alpha: 1),
        UIColor.rgbColors(red: 70, green: 230, blue: 157, alpha: 1),
        UIColor.rgbColors(red: 53, green: 52, blue: 124, alpha: 1),
        UIColor.rgbColors(red: 255, green: 103, blue: 77, alpha: 1),
        UIColor.rgbColors(red: 255, green: 153, blue: 204, alpha: 1),
        UIColor.rgbColors(red: 236, green: 196, blue: 139, alpha: 1),
        UIColor.rgbColors(red: 121, green: 148, blue: 245, alpha: 1),
        UIColor.rgbColors(red: 131, green: 44, blue: 241, alpha: 1),
        UIColor.rgbColors(red: 173, green: 86, blue: 218, alpha: 1),
        UIColor.rgbColors(red: 141, green: 214, blue: 230, alpha: 1),
        UIColor.rgbColors(red: 47, green: 208, blue: 88, alpha: 1)
    ]
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryAndScheduleArray.count
    }
    
    private lazy var cell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.accessibilityIdentifier = "cell"
        cell.textLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        return cell
    }()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categoryAndScheduleArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    private lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.text = "Новая привычка"
        titleLable.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        return titleLable
    }()
    
    
    private lazy var trakcerName: UITextField = {
        let trackerName = UITextField()
        trackerName.placeholder = "Введите название трекера"
        trackerName.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        trackerName.backgroundColor = .textFiledBackground
        return trackerName
    }()
    
    private lazy var categoryAndScheduleTableView: UITableView = {
        let categoryAndSchedule = UITableView()
        categoryAndSchedule.dataSource = self
        categoryAndSchedule.delegate = self
        return categoryAndSchedule
    }()
    
    private lazy var emojiAndColors: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let emojiAndColors = UICollectionView(frame: .zero, collectionViewLayout: layout)
        emojiAndColors.translatesAutoresizingMaskIntoConstraints = false
        emojiAndColors.register(EmojiAndColorCollectionViewCell.self, forCellWithReuseIdentifier: "emojiAndColors")
        emojiAndColors.register(EmojiAndColorsSupplementaryViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        emojiAndColors.dataSource = self
        emojiAndColors.delegate = self
        return emojiAndColors
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
}

extension HabbitCreateViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiAndColors", for: indexPath) as? EmojiAndColorCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        if indexPath.section == 1 {
            cell.color.isHidden = true
            cell.emoji.isHidden = false
            cell.emoji.text = emoji[indexPath.row]
        } else {
            cell.emoji.isHidden = true
            cell.color.isHidden = false
            cell.color.backgroundColor = colors[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        default:
            id = ""
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! EmojiAndColorsSupplementaryViewCell
        if id == "header" {
            headerView.titleLable.text = sectionHeader[indexPath.section]
        } else {
            headerView.titleLable.text = ""
        }
        return headerView
    }
}

extension HabbitCreateViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 6
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: collectionView.frame.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
}
