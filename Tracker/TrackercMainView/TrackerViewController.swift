//
//  ViewController.swift
//  Tracker
//
//  Created by Федор Завьялов on 31.05.2024.
//
import Foundation
import UIKit

final class TrackerViewController: UIViewController{

//MARK: - Constants
    
    var viewModel: TrackerViewModelProtocol
    
    private var trackerCellParameters = TrackerCellPrameters(numberOfCellsInRow: 2, height: 148, horizontalSpacing: 10, verticalSpacing: 0)
    
//MARK: - Views

    private lazy var addTracckerButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Tracker Add Plus")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .trackerBlack
        button.addTarget(self, action: #selector(addTarget), for: .touchUpInside)
        return button
        
    }()

    private lazy var datePicker: UIDatePicker = {
      let datePicker = UIDatePicker(frame: .zero)
        datePicker.isEnabled = true
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        let locale = Locale(identifier: "ru_CH")
        datePicker.locale = locale
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(datePickerChangeValue(_ :)), for: .valueChanged)
      return datePicker
    }()
    
    private lazy var datePickerLable: UILabel = {
        let trackerLabel = UILabel()
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerLabel.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        let trackerMainLable = DateFormatter().prepareDatePickerString(date: Date())
        trackerLabel.text = trackerMainLable
        trackerLabel.textColor = .trackerBlack
        trackerLabel.backgroundColor = .trackerGray
        trackerLabel.layer.cornerRadius = 8
        trackerLabel.clipsToBounds = true
        trackerLabel.textAlignment = .center
        trackerLabel.isUserInteractionEnabled = false
        return trackerLabel
    }()

    private lazy var trackerLabel: UILabel = {
        let trackerLabel = UILabel()
        trackerLabel.font = UIFont(name: "SFProDisplay-Bold", size: 34)
        let trackerMainLable = NSLocalizedString("trackMainLable", comment: "Main Lable")
        trackerLabel.text = trackerMainLable
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerLabel.textColor = .trackerBlack
        return trackerLabel
    }()
    
    let searchFieldPlaceholder = NSLocalizedString("searchFieldPlaceholder", comment: "search field placeholder")
    
    private lazy var searchField: UISearchBar = {
        let searchField = UISearchBar()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.searchTextField.attributedPlaceholder = NSAttributedString(string: searchFieldPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.trackerDarkGray])
        searchField.sizeToFit()
        searchField.searchTextField.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        searchField.layer.borderWidth = 1
        searchField.isTranslucent = false
        searchField.barTintColor = .trackerWhite
        searchField.layer.borderColor = UIColor.trackerWhite.cgColor
        searchField.delegate = self
        return searchField
    }()
    
    private lazy var emptyTrackerListImage: UIImageView = {
        let emptyTrackerListImage = UIImageView()
        emptyTrackerListImage.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Empty Tracker List") ?? UIImage()
        emptyTrackerListImage.image = image
        return emptyTrackerListImage
    }()
    
    private lazy var emptyTrackerListText: UILabel = {
        let emptyTrackerListText = UILabel()
        emptyTrackerListText.translatesAutoresizingMaskIntoConstraints = false
        let emtyTrackerPlaceholderText = NSLocalizedString("emtyTrackerPlaceholderText", comment: "Text of empty placeholder")
        emptyTrackerListText.text = emtyTrackerPlaceholderText
        emptyTrackerListText.font = UIFont(name: "SFProDisplay-Medium", size: 12)
        emptyTrackerListText.tintColor = .trackerBlack
        return emptyTrackerListText
    }()
    
    private lazy var dummyView: UIView = {
        let dummyView = UIView()
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        dummyView.sizeToFit()
        return dummyView
    }()
    
    private lazy var trackerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let trackerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        trackerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        trackerCollectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "trackerCell")
        trackerCollectionView.register(TrackerSupplementaryViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        trackerCollectionView.backgroundColor = .trackerWhite
        trackerCollectionView.dataSource = self
        trackerCollectionView.delegate = self
        trackerCollectionView.alwaysBounceVertical = true
        return trackerCollectionView
    }()
    
    private lazy var filterButton: UIButton = {
        let filterButton = UIButton(type: .system)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.backgroundColor = .trackerBlue
        filterButton.layer.cornerRadius = 17
        let filterButtonText = NSLocalizedString("filterButtonText", comment: "Text of filter button")
        filterButton.setTitle(filterButtonText, for: .normal)
        filterButton.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        filterButton.titleLabel?.tintColor = .trackerWhite
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return filterButton
    }()
    
    init(viewModel: TrackerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.performFetches()
        updateTrackerCollectionView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.screenOpenMetrica()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.screenClosedMetrica()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        hideKeyboardWhenTappedAround()
        setSublayer()
        setConstrains()
        bindWithTrackerViewModel()
        updateTrackerCollectionView()
        traitCollectionDidChange(.current)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .trackerBlack
            trackerCollectionView.backgroundColor = .trackerBlack
            trackerLabel.textColor = .trackerWhite
            searchField.tintColor = .trackerWhite
            searchField.layer.borderColor = UIColor.trackerBlack.cgColor
            searchField.layer.backgroundColor = UIColor.trackerBlack.cgColor
            searchField.barTintColor = .trackerBlack
            searchField.searchTextField.attributedPlaceholder = NSAttributedString(string: searchFieldPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.trackerWhite])
            
        } else {
            view.backgroundColor = .trackerWhite
            trackerCollectionView.backgroundColor = .trackerWhite
            trackerLabel.textColor = .trackerBlack
            searchField.barTintColor = .trackerWhite
            searchField.layer.borderColor = UIColor.trackerWhite.cgColor
            searchField.layer.backgroundColor = UIColor.trackerWhite.cgColor
            searchField.searchTextField.attributedPlaceholder = NSAttributedString(string: searchFieldPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.trackerDarkGray])
        }
    }
    
//MARK: - Bindings
    
    func bindWithTrackerViewModel(){
        viewModel.indexPathAndSectionBinding = { [weak self] indexPathAndSection in
            self?.addTracker(indexPathAndSection: indexPathAndSection)
        }
        viewModel.searchedTextBinding = { [weak self] _ in
            self?.updateTrackerCollectionView()
        }
        viewModel.currentDateBinding = { [weak self] _ in
            self?.updateTrackerCollectionView()
        }
        viewModel.selectedFilterBinding = { [weak self] _ in
            self?.updateTrackerCollectionView()
        }
        
        viewModel.todayDateBinding = { [weak self] date in
        self?.datePicker.date = Date()
            self?.datePickerLable.text = DateFormatter().prepareDatePickerString(date: Date())
        }
    }
    
    @objc func addTarget(){
        viewModel.addTrackerMetrica()
        print("Добавить цель")
        let viewController = TrackerTypeSelectViewController()
        viewController.viewModel = viewModel
        viewController.delegate = self
        viewController.modalPresentationStyle = .popover
        self.present(viewController, animated: true)
    }
    
    @objc func datePickerChangeValue(_ sender: UIDatePicker){
        let selectedDate = sender.date
        datePickerLable.text = DateFormatter().prepareDatePickerString(date: selectedDate)
        viewModel.selectedDate = selectedDate.removeTimeInfo
    }
    
    @objc func filterButtonTapped(){
        viewModel.filterTrackerMetrica()
        let vc = FilterViewController(delegate: viewModel, isFilterSelected: viewModel.isFilterSelected, selectedFilter: viewModel.selectedFilter)
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
    }
    
    //MARK: - Test Method
    
    func setDatePickerDate(date: Date){
        datePicker.date = date
        datePickerLable.text = DateFormatter().prepareDatePickerString(date: date)
    }
    
    func updateTrackerCollectionView() {
        
        trackerCollectionView.reloadData()
        
        if viewModel.isTrackerExists() {
            let image = UIImage(named: "NoTracker")
            emptyTrackerListImage.image = image
            let notFoundTrackerPlaceholderText = NSLocalizedString("notFoundTrackerPlaceholderText", comment: "Text of placeholder when trackers not found")
            emptyTrackerListText.text = notFoundTrackerPlaceholderText
        } else {
            let image = UIImage(named: "Empty Tracker List")
            emptyTrackerListImage.image = image
            let emtyTrackerPlaceholderText = NSLocalizedString("emtyTrackerPlaceholderText", comment: "Text of empty placeholder")
            emptyTrackerListText.text = emtyTrackerPlaceholderText
        }
        
        trackerCollectionView.isHidden = viewModel.isVisibalteTrackersEmpty()
        filterButton.isHidden = viewModel.isVisibalteTrackersEmpty()
    }
    
    func fontNames(){
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
    
//MARK: - Add subview and constraints
    
    private func setSublayer(){
        view.addSubview(trackerLabel)
        view.addSubview(searchField)
        view.addSubview(dummyView)
        setDummySublayers()
        view.addSubview(trackerCollectionView)
        view.addSubview(filterButton)
        view.addSubview(datePicker)
        view.addSubview(datePickerLable)
        view.addSubview(addTracckerButton)
    }
    
    private func setDummySublayers(){
        dummyView.addSubview(emptyTrackerListImage)
        dummyView.addSubview(emptyTrackerListText)
    }
    
    private func setConstrains(){
        setLableConstrains()
        setSearchFieldConstrains()
        dummyViewConstrains()
        setTrackerCollectionContraints()
        setFilterButtonContraints()
        setDatepickerConstraints()
        setAddTrackerButtonConstraints()
    }

    
    private func setLableConstrains(){
        NSLayoutConstraint.activate([
            trackerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            trackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setDatepickerConstraints(){
        NSLayoutConstraint.activate([
            datePickerLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            datePickerLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePickerLable.heightAnchor.constraint(equalToConstant: 34),
            datePickerLable.widthAnchor.constraint(equalToConstant: 77)
        ])
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            datePicker.widthAnchor.constraint(equalToConstant: 77)
        ])
    }
    
    private func setAddTrackerButtonConstraints() {
        NSLayoutConstraint.activate([
        addTracckerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
        addTracckerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
        addTracckerButton.heightAnchor.constraint(equalToConstant: 18),
        addTracckerButton.widthAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func setSearchFieldConstrains (){
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 16),
            searchField.leadingAnchor.constraint(equalTo: trackerLabel.leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: trackerLabel.trailingAnchor)
        ])
    }
    
    private func dummyViewConstrains() {
        NSLayoutConstraint.activate([
            dummyView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            dummyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            dummyView.leadingAnchor.constraint(equalTo: searchField.leadingAnchor),
            dummyView.trailingAnchor.constraint(equalTo: searchField.trailingAnchor)
        ])
        emptyTrackerListImageConstrains()
        emptyTrackerListTextConstrains()
    }
    
    private func emptyTrackerListImageConstrains(){
        NSLayoutConstraint.activate([
            emptyTrackerListImage.centerXAnchor.constraint(equalTo: dummyView.centerXAnchor),
            emptyTrackerListImage.centerYAnchor.constraint(equalTo: dummyView.centerYAnchor, constant: -26),
            emptyTrackerListImage.heightAnchor.constraint(equalToConstant: 80),
            emptyTrackerListImage.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func emptyTrackerListTextConstrains(){
        NSLayoutConstraint.activate([
            emptyTrackerListText.centerXAnchor.constraint(equalTo: dummyView.centerXAnchor),
            emptyTrackerListText.topAnchor.constraint(equalTo: emptyTrackerListImage.bottomAnchor, constant: 8)
        ])
    }
    
    private func setTrackerCollectionContraints(){
        NSLayoutConstraint.activate([
            trackerCollectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35),
            trackerCollectionView.leadingAnchor.constraint(equalTo: searchField.leadingAnchor),
            trackerCollectionView.trailingAnchor.constraint(equalTo: searchField.trailingAnchor)
        ])
    }
    
    private func setFilterButtonContraints(){
        NSLayoutConstraint.activate([
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114)
        ])
    }
}

//MARK: - Delegate and Data Source
extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (viewModel.numberOfSectionsPinCategory() == 1) && (section == 0) {
            return viewModel.numberOfItemsInPinCategory(section)
        } else {
            return viewModel.numberOfItemsIn(section - viewModel.numberOfSectionsPinCategory())
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections() + viewModel.numberOfSectionsPinCategory()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        if (viewModel.numberOfSectionsPinCategory() == 1) && (indexPath.section == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCollectionViewCell
            guard let cell = cell else { return UICollectionViewCell() }
            guard let model = viewModel.modelPinCategory(indexPath: indexPath) else { return UICollectionViewCell() }
            cell.configure(with: model)
            cell.delegate = viewModel
            return cell
        } else {
            let mainSectionsIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - viewModel.numberOfSectionsPinCategory())
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: mainSectionsIndexPath) as? TrackerCollectionViewCell
            guard let cell = cell else { return UICollectionViewCell() }
            guard let model = viewModel.model(indexPath: mainSectionsIndexPath) else { return UICollectionViewCell() }
            cell.configure(with: model)
            cell.delegate = viewModel
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        default:
            id = ""
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! TrackerSupplementaryViewCell
        if (viewModel.numberOfSectionsPinCategory() == 1) && (indexPath.section == 0) {
            if id == "header" {
                let headerTitleText = viewModel.headerPinTitle(for: indexPath)
                headerView.titleLable.text = headerTitleText
                print(headerTitleText)
            } else {
                headerView.titleLable.text = ""
            }
        } else {
            if id == "header" {
                let headerTitleText = viewModel.headerTitle(for: IndexPath(row: indexPath.row, section: indexPath.section - viewModel.numberOfSectionsPinCategory()))
                headerView.titleLable.text = headerTitleText
                print(headerTitleText)
            } else {
                headerView.titleLable.text = ""
            }
        }
        return headerView
            
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = CGFloat(trackerCellParameters.height)
        let width = (CGFloat(collectionView.frame.width) - CGFloat((trackerCellParameters.numberOfCellsInRow - 1)*trackerCellParameters.horizontalSpacing)) / CGFloat(trackerCellParameters.numberOfCellsInRow)
        let size = CGSize(width: width, height: height)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(trackerCellParameters.horizontalSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(trackerCellParameters.verticalSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let headerView = TrackerCollectionHeaderView.shared
        
        if (viewModel.numberOfSectionsPinCategory() == 1) && (section == 0) {
            let headerTitleText = viewModel.headerPinTitle(for: IndexPath(row:0, section: section))
            headerView.titleLable.text = headerTitleText
        } else {
            let headerTitleText = viewModel.headerTitle(for: IndexPath(row: 0, section: (section - viewModel.numberOfSectionsPinCategory())))
            headerView.titleLable.text = headerTitleText
        }
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: collectionView.frame.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return UIContextMenuConfiguration()}
        let pinAction = getPinAction(indexPath: indexPath)
        
        let editText = NSLocalizedString("editText", comment: "")
        let editAction = UIAction(title: editText, handler: { [weak self] _ in
            guard let self = self else { return }
            if (self.viewModel.numberOfSectionsPinCategory() == 1 ) && (indexPath.section == 0) {
                let isPined = true
                let indexPath = indexPath
                guard let tracker = self.viewModel.getPinTracker(for: indexPath) else { return }
                let category = self.viewModel.headerPinTitle(for: indexPath)
                let completedDays = self.viewModel.completedTrackersCount(id: tracker.trackerId)
                self.editTracker(indexPath: indexPath, isPined: isPined, tracker: tracker, category: category, completedDays: completedDays)
            } else {
                let isPined = false
                let indexPath = IndexPath(row: indexPath.row, section: indexPath.section - self.viewModel.numberOfSectionsPinCategory())
                guard let tracker = self.viewModel.getTracker(for: indexPath) else { return }
                let category = self.viewModel.headerTitle(for: indexPath)
                let completedDays = self.viewModel.completedTrackersCount(id: tracker.trackerId)
                self.editTracker(indexPath: indexPath, isPined: isPined, tracker: tracker, category: category, completedDays: completedDays)
            }
        })
        let deletText = NSLocalizedString("deletText", comment: "")
        let removeAction = UIAction(title: deletText, attributes: UIMenuElement.Attributes.destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            let alert = UIAlertController(title: nil, message: "Эта категория точно не нужна?", preferredStyle: .actionSheet)
            let alertDeleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            
                if let indexPath = indexPaths.first {
                    self.removeTracker(indexPath: indexPath)
                }
            }
            let alertCancelAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in
                alert.dismiss(animated: true)
            }
            alert.addAction(alertDeleteAction)
            alert.addAction(alertCancelAction)
            self.present(alert, animated:  true)
        })
        let menuActions = UIMenu(children: [pinAction, editAction, removeAction])
        let contextMenu = UIContextMenuConfiguration(actionProvider:  { actions in
            menuActions
        })
        return contextMenu
    }
    
    func getPinAction(indexPath: IndexPath) -> UIAction {
        if (self.viewModel.numberOfSectionsPinCategory() == 1 ) && (indexPath.section == 0) {
            let pinText = NSLocalizedString("unpinText", comment: "")
            let unPinAction = UIAction(title: pinText, handler: { [weak self] _ in
                guard let self = self else { return }
                self.unPinTracker(indexPath: indexPath)
            })
            return unPinAction
        } else {
            let pinText = NSLocalizedString("pinText", comment: "")
            let pinAction = UIAction(title: pinText, handler: { [weak self] _ in
                guard let self = self else { return }
                    self.pinTracker(indexPath: IndexPath(row: indexPath.row, section: indexPath.section - self.viewModel.numberOfSectionsPinCategory()))
            })
            return pinAction
        }
    }
    
    func pinTracker(indexPath: IndexPath){
        viewModel.pinTracker(indexPath: indexPath)
    }
    
    func unPinTracker(indexPath: IndexPath){
        viewModel.unPinTracker(indexPath: indexPath)
    }
    
    func removeTracker(indexPath: IndexPath) {
                viewModel.deleteTrackerMetrica()
        //        viewModel.removeTracker(indexPath: indexPath)
        
        
        if (self.viewModel.numberOfSectionsPinCategory() == 1 ) && (indexPath.section == 0) {
            self.viewModel.removePinTracker(indexPath: indexPath)
        } else {
            self.viewModel.removeTracker(indexPath: IndexPath(row: indexPath.row, section: indexPath.section - self.viewModel.numberOfSectionsPinCategory()))
        }
    }
    
    func editTracker(indexPath: IndexPath, isPined: Bool,tracker: Tracker, category: String, completedDays: Int) {
        viewModel.editTrackerMetrica()
        if tracker.isRegular {
            let vc = RegularTrackerEditViewController(delegate: viewModel, tracker: tracker, category: category, indexPath: indexPath, isPined: isPined, completedDays: completedDays)
            vc.modalPresentationStyle = .popover
            self.present(vc, animated: true)
        } else {
            let vc = NotRegularTrackerEditViewController(delegate: viewModel, tracker: tracker, category: category, indexPath: indexPath, isPined: isPined, completedDays: completedDays)
            vc.modalPresentationStyle = .popover
            self.present(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        if (self.viewModel.numberOfSectionsPinCategory() == 1 ) && (indexPath.section == 0) {
            let cellIndex = indexPath
            let cell = collectionView.cellForItem(at: cellIndex) as! TrackerCollectionViewCell
            let selectedView = cell.setSelectedView()
            return UITargetedPreview(view: selectedView)
        } else {
            let cellIndex = IndexPath(row: indexPath.row, section: indexPath.section - self.viewModel.numberOfSectionsPinCategory())
            let cell = collectionView.cellForItem(at: cellIndex) as! TrackerCollectionViewCell
            let selectedView = cell.setSelectedView()
            return UITargetedPreview(view: selectedView)
        }
    }
}

extension TrackerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        viewModel.searchedText = searchText
    }
}

extension TrackerViewController {
    
    func addTracker(indexPathAndSection: IndexPathAndSection) {
//        trackerCollectionView.performBatchUpdates {
//            if let insetedSections = indexPathAndSection.section {
//                trackerCollectionView.insertSections([insetedSections])
//            }
//            if let insertIndexPath = indexPathAndSection.insertIndexPath {
//                trackerCollectionView.insertItems(at: [insertIndexPath])
//            }
//            if let deleteIndexPath = indexPathAndSection.deleteIndexPath {
//                trackerCollectionView.deleteItems(at: [deleteIndexPath])
//            }
//            if let deletedSections = indexPathAndSection.deletedSection {
//                trackerCollectionView.deleteSections([deletedSections])
//            }
//            
//        }
        updateTrackerCollectionView()
    }
}
