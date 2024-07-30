//
//  HabbitVreateView.swift
//  Tracker
//
//  Created by Федор Завьялов on 23.06.2024.
//

import Foundation
import UIKit

protocol HabbitCreateViewControllerProtocol{
    func createTracker(category: String, tracker: Tracker)
}
class TrackerCreateViewController: UIViewController {
    
    var delegate: HabbitCreateViewControllerProtocol?
    var category: String? = "Спорт"
    var regular: Bool
    var trackerTypeSelectViewController: TrackerTypeSelectViewController
    var trackerSchedule: [String] = []
    var trackerName = ""
    var trackerColor: UIColor?
    var trackerEmoji: String?
    var scheduleSubtitle: String?
    
    init(regular: Bool, trackerTypeSelectViewController: TrackerTypeSelectViewController) {
        self.regular = regular
        self.trackerTypeSelectViewController = trackerTypeSelectViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var categoryAndScheduleArray:[String] = {
        if regular {
         return ["Категория", "Расписание"]
        } else {
         return ["Категория"]
        }
    }()
    

    
    private let sectionHeader = ["Emoji","Цвет"]
    private let emoji: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    private lazy var collectionViewCellSize: Int = {
        if (view.frame.width - 32) / 6 >= 52 {
            return 52
        } else {
            return 48
        }
    }()
    
    private lazy var supplementaryViewCellSize: Int = 34
    private lazy var safeZoneCollectioView: Int = 58
    private lazy var collectionViewHeight: Int = {
        return sectionHeader.count * (supplementaryViewCellSize + safeZoneCollectioView) + emoji.count / 6 * collectionViewCellSize + colors.count / 6 * collectionViewCellSize
    }()
    
    
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
   
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        scrollView.scrollsToTop = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.text = "Новая привычка"
        titleLable.tintColor = .trackerBlack
        titleLable.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        return titleLable
    }()
    
    
    private lazy var layerTextFieldView: UIView = {
        let layerTextFieldView = UIView()
        layerTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        layerTextFieldView.backgroundColor = .trackerBackgroundOpacityGray
        layerTextFieldView.layer.cornerRadius = 16
        return layerTextFieldView
    }()
    
    private lazy var trackerNameTextField: UITextField = {
        let trackerName = UITextField()
        trackerName.translatesAutoresizingMaskIntoConstraints = false
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.rgbColors(red: 174, green: 175, blue: 180, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 17)!
        ]
        trackerName.attributedPlaceholder = NSAttributedString(string: "Введите название трекера", attributes:attributes)
        trackerName.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        trackerName.backgroundColor = .none
        trackerName.addTarget(self, action: #selector(inputText(_ :)), for: .allEditingEvents)
        trackerName.delegate = self
        return trackerName
    }()
    
    lazy var categoryAndScheduleTableView: UITableView = {
        let categoryAndSchedule = UITableView()
        categoryAndSchedule.translatesAutoresizingMaskIntoConstraints = false
        categoryAndSchedule.layer.cornerRadius = 16
        categoryAndSchedule.backgroundColor = .trackerWhite
        categoryAndSchedule.dataSource = self
        categoryAndSchedule.delegate = self
        categoryAndSchedule.register(TrackerCreateViewCell.self, forCellReuseIdentifier: "cell")
        categoryAndSchedule.rowHeight = 75
        categoryAndSchedule.separatorStyle = .singleLine
        categoryAndSchedule.separatorInset.left = 16
        categoryAndSchedule.separatorInset.right = 16
        categoryAndSchedule.separatorColor = .trackerDarkGray
        categoryAndSchedule.isScrollEnabled = false
        return categoryAndSchedule
    }()
    
    private lazy var buttonStack: UIStackView = {
        let hStack = UIStackView()
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.distribution = .fillEqually
        hStack.backgroundColor = .none
        return hStack
    }()
    
    private lazy var emojiAndColors: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let emojiAndColors = UICollectionView(frame: .zero, collectionViewLayout: layout)
        emojiAndColors.translatesAutoresizingMaskIntoConstraints = false
        emojiAndColors.backgroundColor = .trackerWhite
        emojiAndColors.register(EmojiAndColorCollectionViewCell.self, forCellWithReuseIdentifier: "emojiAndColors")
        emojiAndColors.register(EmojiAndColorsSupplementaryViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        emojiAndColors.dataSource = self
        emojiAndColors.delegate = self
        emojiAndColors.allowsMultipleSelection = true
        emojiAndColors.isScrollEnabled = false
        return emojiAndColors
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        button.tintColor = .trackerWhite
        button.backgroundColor = .trackerDarkGray
        button.addTarget(self, action: #selector(createTracker), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        button.tintColor = .trackerPink
        button.backgroundColor = .trackerWhite
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.trackerPink.cgColor
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(createButton)
        addSubviews()
        setConstraints()
    }
    
    
    @objc func inputText(_ sender: UITextField){
        let text = sender.text ?? ""
        trackerName = text
        print(text)
    }
    
    @objc func createTracker(){
        let schedule = regular ? trackerSchedule : [
            Weekdays.Monday.rawValue,
            Weekdays.Tuesday.rawValue,
            Weekdays.Wednesday.rawValue,
            Weekdays.Thursday.rawValue,
            Weekdays.Friday.rawValue,
            Weekdays.Saturday.rawValue,
            Weekdays.Sunday.rawValue
        ]
        
        let category = regular ? self.category ?? "Категория не выбрана" : (self.category ?? "Категория не выбрана") + " " + "🔥"
        
        let tracker = Tracker(
            trackerId: UUID(),
            name: trackerName,
            emoji: trackerEmoji ?? "🤬",
            color: trackerColor ?? UIColor.trackerBlack,
            schedule: schedule)
        
        delegate?.createTracker(category: category, tracker: tracker)
        self.dismiss(animated: false)
        trackerTypeSelectViewController.dismiss(animated: true)
        trackerSchedule = []
        scheduleSubtitle = nil
    }
    
    @objc func cancel(){
        self.dismiss(animated: true)
    }
    
    func reloadTable(){
        categoryAndScheduleTableView.reloadData()
    }
    
    private func addSubviews(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLable)
        contentView.addSubview(layerTextFieldView)
        contentView.addSubview(trackerNameTextField)
        contentView.addSubview(categoryAndScheduleTableView)
        contentView.addSubview(emojiAndColors)
        contentView.addSubview(buttonStack)


    }
    
    private func setConstraints(){
        setScrollViewConstraints()
        setScrollViewContentConstraints()
        setTitleConstraints()
        setLayerTextFieldViewConstrains()
        setTrackerNameConstraints()
        setCategoryAndScheduleTableViewConstraints()
        setEmojiAndColors()
//        setButtonStackConstraintsForSingle()
//        setButtonStackConstraintsForTecker()
//        if regular {
            setButtonStackConstraintsForTecker()
//        } else {
//            setButtonStackConstraintsForSingle()
//        }
//        scrollViewContent.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
//        scrollViewContent.heightAnchor.constraint(equalTo: scrollView.heightAnchor).priority = .fittingSizeLevel
        contentView.bottomAnchor.constraint(equalTo: buttonStack.bottomAnchor).isActive = true
    }
    
    
    private func setScrollViewConstraints(){
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    private func setScrollViewContentConstraints(){
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

    }
    private func setTitleConstraints(){
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            titleLable.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)])
    }
    
    private func setLayerTextFieldViewConstrains(){
        NSLayoutConstraint.activate([
            layerTextFieldView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 87),
            layerTextFieldView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            layerTextFieldView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            layerTextFieldView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setTrackerNameConstraints(){
        NSLayoutConstraint.activate([
            trackerNameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 87),
            trackerNameTextField.leadingAnchor.constraint(equalTo: layerTextFieldView.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setCategoryAndScheduleTableViewConstraints(){
        NSLayoutConstraint.activate([
            categoryAndScheduleTableView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 24),
            categoryAndScheduleTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryAndScheduleTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryAndScheduleTableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * categoryAndScheduleArray.count - 1))
        ])
    }
    

    private func setEmojiAndColors(){
        NSLayoutConstraint.activate([
            emojiAndColors.topAnchor.constraint(equalTo: categoryAndScheduleTableView.bottomAnchor, constant: 8),
            emojiAndColors.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiAndColors.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emojiAndColors.heightAnchor.constraint(equalToConstant: CGFloat(collectionViewHeight))
        ])
        
    }
    
    private func setButtonStackConstraintsForTecker(){
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: emojiAndColors.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setButtonStackConstraintsForSingle(){
        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonStack.heightAnchor.constraint(equalToConstant: 60),
            buttonStack.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension TrackerCreateViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryAndScheduleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TrackerCreateViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.mainTitle.text = categoryAndScheduleArray[indexPath.row]
        if indexPath.row == 1 {
            if scheduleSubtitle != nil {
                cell.lableStackView.addArrangedSubview(cell.additionalTitle)
                cell.additionalTitle.text = scheduleSubtitle
            }
        } else {
            if category != nil {
                cell.lableStackView.addArrangedSubview(cell.additionalTitle)
                cell.additionalTitle.text = category
            }
        }
        cell.backgroundColor = .trackerBackgroundOpacityGray
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension TrackerCreateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            let viewController = ScheduleViewController()
            viewController.delegate = self
            viewController.modalPresentationStyle = .popover
            self.present(viewController, animated: true)
        }
    }
}

extension TrackerCreateViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return emoji.count
        case 1: return colors.count
        default: return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sectionHeader.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiAndColors", for: indexPath) as? EmojiAndColorCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        let section = indexPath.section
        let emojiIsHidden = section == 0
        cell.emoji.isHidden = !emojiIsHidden
        cell.color.isHidden = emojiIsHidden
        cell.emoji.text = emoji[indexPath.row]
        cell.color.backgroundColor = colors[indexPath.row]
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

extension TrackerCreateViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let splitRatio = collectionView.bounds.width / 6
//        if splitRatio > 52 {
//            let size = CGSize(width: 52, height: 52)
//            return size
//        } else {
//            let size = CGSize(width: 48, height: 48)
//            return size
//        }
//
        let size = CGSize(width: collectionViewCellSize, height: collectionViewCellSize)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: collectionView.frame.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section}).forEach({collectionView.deselectItem(at: $0, animated: true)})
        if let trackerEmoji = self.trackerEmoji {
            let index = self.emoji.firstIndex { emoji in
                emoji == trackerEmoji
            }
            let selectedCell = collectionView.cellForItem(at: IndexPath(row: index ?? 0, section: indexPath.section)) as? EmojiAndColorCollectionViewCell
            UIView.animate(withDuration: 0.3) {
                selectedCell?.backgroundColor = .trackerWhite
            }
        }
        
        if let trackerColor = self.trackerColor {
            let index = self.colors.firstIndex { color in
                color == trackerColor
            }
            
            let selectedCell = collectionView.cellForItem(at: IndexPath(row: index ?? 0, section: indexPath.section)) as? EmojiAndColorCollectionViewCell
            UIView.animate(withDuration: 0.3) {
                selectedCell?.layer.cornerRadius = 0
                selectedCell?.layer.borderWidth = 0
            }
        }
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorCollectionViewCell
            
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
                if indexPath.section == 0 {
                    cell?.layer.cornerRadius = 16
                    cell?.clipsToBounds = true
                    cell?.backgroundColor = .trackerBackgroundOpacityGray
                    self.trackerEmoji = self.emoji[indexPath.row]
                } else {
                    cell?.layer.cornerRadius = 8
                    cell?.layer.borderWidth = 3
                    cell?.layer.borderColor = selecctionColors[indexPath.row].cgColor
                    self.trackerColor = self.colors[indexPath.row]
                }
            }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorCollectionViewCell
//        UIView.animate(withDuration: 0.3) {
//            if indexPath.section == 0 {
//                cell?.backgroundColor = .trackerWhite //.trackerWhite
//            } else {
//                cell?.layer.cornerRadius = 0
//                cell?.layer.borderWidth = 0
//            }
//        }
//    }
}

extension TrackerCreateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        trackerName = textField.text ?? ""
        print(trackerName)
        return true
    }
    
}
