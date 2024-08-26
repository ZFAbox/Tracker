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
    
    var viewModel: TrackerViewModel
    
    private var trackerCellParameters = TrackerCellPrameters(numberOfCellsInRow: 2, height: 148, horizontalSpacing: 10, verticalSpacing: 0)
    
//MARK: - Views
    
    private lazy var trackerLabel: UILabel = {
        let trackerLabel = UILabel()
        trackerLabel.font = UIFont(name: "SFProDisplay-Bold", size: 34)
        trackerLabel.text = "Трекеры"
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerLabel.textColor = .trackerBlack
        return trackerLabel
    }()
    
    private lazy var searchField: UISearchBar = {
        let searchField = UISearchBar()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = "Поиск"
        searchField.sizeToFit()
        searchField.searchTextField.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        searchField.layer.borderWidth = 1
        searchField.layer.borderColor = UIColor.white.cgColor
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
        emptyTrackerListText.text = "Что будем отслеживать?"
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
        trackerCollectionView.dataSource = self
        trackerCollectionView.delegate = self
        return trackerCollectionView
    }()
    
    private lazy var filterButton: UIButton = {
        let filterButton = UIButton(type: .system)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.backgroundColor = .trackerBlue
        filterButton.layer.cornerRadius = 17
        let filterButtonText = "Фильтры"
        filterButton.setTitle(filterButtonText, for: .normal)
        filterButton.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        filterButton.titleLabel?.tintColor = .trackerWhite
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return filterButton
    }()
    
    init(viewModel: TrackerViewModel) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.performFetches()
        updateTrackerCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        setSublayer()
        setConstrains()
        bindWithTrackerViewModel()
        updateTrackerCollectionView()
    }
    
//MARK: - Bindings
    
    func bindWithTrackerViewModel(){
        viewModel.indexPathAndSectionBinding = { [weak self] indexPathAndSection in
            self?.addTracker(indexPath: indexPathAndSection.indexPath, insetedSections: indexPathAndSection.section)
        }
        viewModel.searchedTextBinding = { [weak self] _ in
            self?.updateTrackerCollectionView()
        }
        viewModel.currentDateBinding = { [weak self] _ in
            self?.updateTrackerCollectionView()
        }
    }
    
    @objc func filterButtonTapped(){
        //TODO: - add filter button action
    }
    
    func updateTrackerCollectionView() {
        trackerCollectionView.reloadData()
        if viewModel.isTrackerExists() {
            let image = UIImage(named: "NoTracker")
            emptyTrackerListImage.image = image
            emptyTrackerListText.text = "Ничего не найдено"
        } else {
            let image = UIImage(named: "Empty Tracker List")
            emptyTrackerListImage.image = image
            emptyTrackerListText.text = "Что будем отслеживать?"
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
    
    func setSublayer(){
        view.addSubview(trackerLabel)
        view.addSubview(searchField)
        view.addSubview(dummyView)
        setDummySublayers()
        view.addSubview(trackerCollectionView)
        view.addSubview(filterButton)
    }
    
    func setDummySublayers(){
        dummyView.addSubview(emptyTrackerListImage)
        dummyView.addSubview(emptyTrackerListText)
    }
    
    func setConstrains(){
        setLableConstrains()
        setSearchFieldConstrains()
        dummyViewConstrains()
        setTrackerCollectionContraints()
        setFilterButtonContraints()
    }
    
    func setLableConstrains(){
        NSLayoutConstraint.activate([
            trackerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            trackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func setSearchFieldConstrains (){
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 16),
            searchField.leadingAnchor.constraint(equalTo: trackerLabel.leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: trackerLabel.trailingAnchor)
        ])
    }
    
    func dummyViewConstrains() {
        NSLayoutConstraint.activate([
            dummyView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            dummyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            dummyView.leadingAnchor.constraint(equalTo: searchField.leadingAnchor),
            dummyView.trailingAnchor.constraint(equalTo: searchField.trailingAnchor)
        ])
        emptyTrackerListImageConstrains()
        emptyTrackerListTextConstrains()
    }
    
    func emptyTrackerListImageConstrains(){
        NSLayoutConstraint.activate([
            emptyTrackerListImage.centerXAnchor.constraint(equalTo: dummyView.centerXAnchor),
            emptyTrackerListImage.centerYAnchor.constraint(equalTo: dummyView.centerYAnchor, constant: -26),
            emptyTrackerListImage.heightAnchor.constraint(equalToConstant: 80),
            emptyTrackerListImage.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func emptyTrackerListTextConstrains(){
        NSLayoutConstraint.activate([
            emptyTrackerListText.centerXAnchor.constraint(equalTo: dummyView.centerXAnchor),
            emptyTrackerListText.topAnchor.constraint(equalTo: emptyTrackerListImage.bottomAnchor, constant: 8)
        ])
    }
    
    func setTrackerCollectionContraints(){
        NSLayoutConstraint.activate([
            trackerCollectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackerCollectionView.leadingAnchor.constraint(equalTo: searchField.leadingAnchor),
            trackerCollectionView.trailingAnchor.constraint(equalTo: searchField.trailingAnchor)
        ])
    }
    
    func setFilterButtonContraints(){
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
        viewModel.numberOfItemsIn(section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        guard let model = viewModel.model(indexPath: indexPath) else { return UICollectionViewCell() }
        cell.configure(with: model)
        cell.delegate = viewModel
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
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! TrackerSupplementaryViewCell
        if id == "header" {
            let headerTitleText = viewModel.headerTitle(for: indexPath)
            headerView.titleLable.text = headerTitleText
            print(headerTitleText)
        } else {
            headerView.titleLable.text = ""
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
        let indexPath = IndexPath(row: 0, section: section)
        
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: collectionView.frame.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let pinAction = UIAction(title: "Закрепить", handler: { [weak self] _ in
            
        })
        let editAction = UIAction(title: "Редактировать", handler: { [weak self] _ in
            
        })
        let removeAction = UIAction(title: "Удалить", attributes: UIMenuElement.Attributes.destructive, handler: { [weak self] _ in
            
        })
        let menuActions = UIMenu(children: [pinAction, editAction, removeAction])
        let contextMenu = UIContextMenuConfiguration { actions in
            menuActions
        }
        return contextMenu
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        let cell = collectionView.cellForItem(at: indexPath) as! TrackerCollectionViewCell
        let selectedView = cell.setSelectedView()
        return UITargetedPreview(view: selectedView)
    }
    
}

extension TrackerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        viewModel.searchedText = searchText
    }
}

extension TrackerViewController {
    
    func addTracker(indexPath: IndexPath, insetedSections: Int?) {
//        trackerCollectionView.performBatchUpdates {
//            if let insetedSections = insetedSections {
//                trackerCollectionView.insertSections([insetedSections])
//            }
//            trackerCollectionView.insertItems(at: [indexPath])
//        }
        updateTrackerCollectionView()
    }
}
