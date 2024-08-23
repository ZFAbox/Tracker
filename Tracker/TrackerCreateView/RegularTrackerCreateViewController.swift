//
//  RegularTrackerCreateViewController.swift
//  Tracker
//
//  Created by Федор Завьялов on 20.08.2024.
//

import Foundation
import UIKit

class RegularTrackerCreateViewController: UIViewController {
    
    var delegate: TrackerCreateViewControllerProtocol?
    private var category: String? {
        didSet{
            isCreateButtonEnable()
        }
    }
    private var regular: Bool
    private var trackerTypeSelectViewController: TrackerTypeSelectViewController
    var trackerSchedule: [String] = [] {
        didSet {
            isCreateButtonEnable()
        }
    }
    private var trackerName = "" {
        didSet {
            isCreateButtonEnable()
        }
    }
    private var trackerColor: UIColor?
    private var trackerColorIsSelected = false {
        didSet{
            isCreateButtonEnable()
        }
    }
    private var trackerEmoji: String?
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
        return ["Категория", "Расписание"]
    }()
    
    private let sectionHeader = ["Emoji","Цвет"]
    private let emoji: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    private lazy var collectionViewCellSize: Int = {
        if (view.frame.width - 32 - 25) / 6 >= 52 {
            return Int((view.frame.width - 32 - 25) / 6)
        }
        else if (view.frame.width - 32) / 6 >= 52 {
            return 52
        } else if (view.frame.width - 32) / 6 >= 48{
            return 48
        } else {
            return Int((view.frame.width - 32) / 6)
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
    
    private lazy var textFieldVStack: UIStackView = {
        let vStack = UIStackView()
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.spacing = 8
        vStack.axis = .vertical
        vStack.alignment = .center
        return vStack
    }()
    
    private lazy var layerTextFieldView: UIView = {
        let layerTextFieldView = UIView()
        layerTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        layerTextFieldView.backgroundColor = .trackerBackgroundOpacityGray
        layerTextFieldView.layer.cornerRadius = 16
        return layerTextFieldView
    }()
    
//    private lazy var trackerNameTextField: UITextField = {
//        let trackerName = UITextField()
//        trackerName.translatesAutoresizingMaskIntoConstraints = false
//        let attributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.rgbColors(red: 174, green: 175, blue: 180, alpha: 1),
//            NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 17)!
//        ]
//        trackerName.attributedPlaceholder = NSAttributedString(string: "Введите название трекера", attributes:attributes)
//        trackerName.font = UIFont(name: "SFProDisplay-Regular", size: 17)
//        trackerName.backgroundColor = .none
//        trackerName.addTarget(self, action: #selector(inputText(_ :)), for: .allEditingEvents)
//        trackerName.delegate = self
//        trackerName.clearButtonMode = .whileEditing
//        var paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineBreakMode = .byClipping
//        trackerName.defaultTextAttributes = [.paragraphStyle: paragraphStyle]
//
//        return trackerName
//    }()
    
    private let placeholderText = "Введите название трекера"
    
    private lazy var placeholderLableView: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = placeholderText
        lable.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        lable.textColor = .trackerDarkGray
        return lable
    }()
    
    private lazy var trackerNameTextField: UITextView = {
        let trackerName = UITextView()
        trackerName.translatesAutoresizingMaskIntoConstraints = false
        trackerName.text = ""
        trackerName.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        trackerName.textColor = .trackerBlack
        trackerName.backgroundColor = .none
        trackerName.textContainerInset = UIEdgeInsets(top: 27, left: 0, bottom: 0, right: 0)
        trackerName.delegate = self
        trackerName.isScrollEnabled = false
        return trackerName
    }()
    
    private lazy var textFieldLimitationMessage: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Ограничение 38 символов"
        lable.textColor = .trackerRed
        lable.textAlignment = .center
        lable.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        return lable
    }()
    
    private lazy var clearTextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        return button
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
        removeTextFieldEditing()
        textFieldLimitationMessage.removeFromSuperview()
    }
    
    @objc func inputText(_ sender: UITextField){
        let text = sender.text ?? ""
        trackerName = text
        UIView.animate(withDuration: 0.4) { [self] in
            if trackerName.count <= 38 {
                self.textFieldLimitationMessage.removeFromSuperview()
            } else {
                trackerNameTextField.text = String(trackerName.dropLast())
                self.textFieldVStack.addArrangedSubview(textFieldLimitationMessage)
            }
        }
    }
    
    @objc func clearText(){
        trackerNameTextField.text = ""
    }
    
    @objc func createTracker(){
        let category = self.category ?? "Категория не выбрана"
        
        let tracker = Tracker(
            trackerId: UUID(),
            name: trackerName,
            emoji: trackerEmoji ?? "🤬",
            color: trackerColor ?? UIColor.trackerBlack,
            schedule: trackerSchedule,
            isRegular: regular,
            createDate: Date().removeTimeInfo ?? Date())
        
        createButton.backgroundColor = .trackerBlack
        delegate?.createTracker(category: category, tracker: tracker)
        self.dismiss(animated: false)
        trackerTypeSelectViewController.dismiss(animated: true)
        trackerSchedule = []
        scheduleSubtitle = nil
    }
    
    @objc func cancel(){
        self.dismiss(animated: true)
    }
    
    
    func removeTextFieldEditing() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endTextEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func endTextEditing() {
        trackerNameTextField.endEditing(true)
    }
    
    private func createIsCompleted() -> Bool {
        let trackerNameIsEmpty = trackerName.isEmpty
        let scheduleIsEmpty = trackerSchedule.isEmpty
        let trackerEmojiIsEmpty = trackerEmoji?.isEmpty ?? true
        let categoryIsEmpty = category?.isEmpty ?? true
        return !trackerNameIsEmpty && !scheduleIsEmpty && trackerColorIsSelected && !trackerEmojiIsEmpty && !categoryIsEmpty
    }
    
    private func isCreateButtonEnable() {
        if createIsCompleted() {
            createButton.backgroundColor = .trackerBlack
            createButton.isEnabled = true
        } else {
            createButton.backgroundColor = .trackerDarkGray
            createButton.isEnabled = false
        }
    }
    
    func reloadTable(){
        categoryAndScheduleTableView.reloadData()
    }
    
    private func addSubviews(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLable)
        
        contentView.addSubview(textFieldVStack)
        
        textFieldVStack.addArrangedSubview(layerTextFieldView)
        textFieldVStack.addArrangedSubview(textFieldLimitationMessage)
        
        contentView.addSubview(placeholderLableView)
        contentView.addSubview(trackerNameTextField)
        
        
        contentView.addSubview(categoryAndScheduleTableView)
        contentView.addSubview(emojiAndColors)
        contentView.addSubview(buttonStack)
    }
    
    private func setConstraints(){
        setScrollViewConstraints()
        setScrollViewContentConstraints()
        
        setTitleConstraints()
        
        setTextViewVStackConstraints()
        setLayerTextFieldViewConstrains()
        setTrackerNameConstraints()
        setPlaceholdeTextViewConstraints()
        
        setCategoryAndScheduleTableViewConstraints()
        setEmojiAndColors()
        setButtonStackConstraintsForTecker()
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
    
    private func setTextViewVStackConstraints(){
        NSLayoutConstraint.activate([
            textFieldVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 87),
            textFieldVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textFieldVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textFieldVStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 75)]
        )
    }
    
    private func setLayerTextFieldViewConstrains(){
        NSLayoutConstraint.activate([
            layerTextFieldView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            layerTextFieldView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            layerTextFieldView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setTrackerNameConstraints(){
        NSLayoutConstraint.activate([
            trackerNameTextField.topAnchor.constraint(equalTo: layerTextFieldView.topAnchor),
            trackerNameTextField.leadingAnchor.constraint(equalTo: layerTextFieldView.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: layerTextFieldView.trailingAnchor, constant: -41),
            trackerNameTextField.bottomAnchor.constraint(equalTo: layerTextFieldView.bottomAnchor)
        ])
    }
    
    private func setPlaceholdeTextViewConstraints(){
        NSLayoutConstraint.activate([
            placeholderLableView.topAnchor.constraint(equalTo: layerTextFieldView.topAnchor),
            placeholderLableView.leadingAnchor.constraint(equalTo: layerTextFieldView.leadingAnchor, constant: 20),
            placeholderLableView.trailingAnchor.constraint(equalTo: layerTextFieldView.trailingAnchor, constant: -41),
            placeholderLableView.bottomAnchor.constraint(equalTo: layerTextFieldView.bottomAnchor)
        ])
    }
    
    private func setCategoryAndScheduleTableViewConstraints(){
        NSLayoutConstraint.activate([
            categoryAndScheduleTableView.topAnchor.constraint(equalTo: textFieldVStack.bottomAnchor, constant: 24),
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

extension RegularTrackerCreateViewController: UITableViewDataSource {
    
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

extension RegularTrackerCreateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            let viewController = ScheduleViewController()
            viewController.delegate = self
            viewController.modalPresentationStyle = .popover
            self.present(viewController, animated: true)
        } else {
            let viewController = TrackerCategoriesList(delegate: self)
            viewController.modalPresentationStyle = .popover
            self.present(viewController, animated: true)
        }
    }
}

extension RegularTrackerCreateViewController: UICollectionViewDataSource {
    
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

extension RegularTrackerCreateViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
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
                cell?.backgroundColor = .trackerEmojiSelectionGray
                self.trackerEmoji = self.emoji[indexPath.row]
            } else {
                cell?.layer.cornerRadius = 8
                cell?.layer.borderWidth = 3
                cell?.layer.borderColor = selecctionColors[indexPath.row].cgColor
                self.trackerColor = self.colors[indexPath.row]
                self.trackerColorIsSelected = true
            }
        }
    }
}

extension RegularTrackerCreateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        trackerName = textField.text ?? ""
        return true
    }
}

extension RegularTrackerCreateViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let text = textView.text ?? ""
            trackerName = text
        if text != "" {
            placeholderLableView.isHidden = true
            UIView.animate(withDuration: 0.4) { [self] in
                if trackerName.count <= 38 {
                    self.textFieldLimitationMessage.removeFromSuperview()
                } else {
                    trackerNameTextField.text = String(trackerName.dropLast())
                    self.textFieldVStack.addArrangedSubview(textFieldLimitationMessage)
                }
            }
        } else {
            placeholderLableView.isHidden = false
        }
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        textView.text = ""
//        textView.textColor = .trackerBlack
//    }
//
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        if textView.text == "" {
//            return true
//        } else {
//            return false
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text == "" {
//            textView.text = placeholderText
//            textView.textColor = .trackerDarkGray
//        }
//    }
}

extension RegularTrackerCreateViewController: SelectCategoryForTrackerProtocl {
    func setSelectedCategory(_ category: String) {
        self.category = category
        categoryAndScheduleTableView.reloadData()
    }
}



