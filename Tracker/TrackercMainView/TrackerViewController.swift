//
//  ViewController.swift
//  Tracker
//
//  Created by Федор Завьялов on 31.05.2024.
//
import Foundation
import UIKit

final class TrackerViewController: UIViewController{
    
    private var categories: [TrackerCategory] = [
        TrackerCategory(categoryName: "Повседневное", trackersOfCategory: [
            Tracker(trackerId: UUID(), name: "Игра в теннис", emoji: "🏓", color: UIColor.rgbColors(red: 253, green: 76, blue: 73, alpha: 1), schedule: [Weekdays.Monday.rawValue, Weekdays.Tuesday.rawValue]),
            Tracker(trackerId: UUID(), name: "Ходьба", emoji: "🚶‍♂️", color: UIColor.rgbColors(red: 255, green: 136, blue: 30, alpha: 1), schedule: [Weekdays.Monday.rawValue, Weekdays.Wednesday.rawValue, Weekdays.Friday.rawValue]),
            Tracker(trackerId: UUID(), name: "Рисование", emoji: "🎨", color: UIColor.rgbColors(red: 0, green: 123, blue: 250, alpha: 1), schedule: [Weekdays.Friday.rawValue, Weekdays.Saturday.rawValue])
        ])
    ]
    
    var completerTrackerId: Set<UUID> = []
    var completedTrackers: [TrackerRecord] = []
    private var trackersForCurrentDate: [TrackerCategory] = []
    
    var currentDate: Date? {
        didSet {
            guard let currentDate = currentDate else {
                print("Нет текущей даты")
                return }
            let weekday = DateFormatter.weekday(date: currentDate)
            print(weekday)
            trackersForCurrentDate = categories.compactMap({ category in
                let trackers = category.trackersOfCategory.filter { tracker in
                    let weekdayMatch = tracker.schedule.contains { weekday in
                        weekday == DateFormatter.weekday(date: currentDate)
                    }
                    return weekdayMatch
                }
                print(trackers.count)
                if trackers.isEmpty {
                    return nil
                }
                return TrackerCategory(categoryName: category.categoryName, trackersOfCategory: trackers)
            })
            
            if trackersForCurrentDate.isEmpty {
                trackerCollectionView.isHidden = true
                filterButton.isHidden = true
            } else {
                trackerCollectionView.isHidden = false
                filterButton.isHidden = false
                trackerCollectionView.reloadData()
            }

        }
    }
    
    
    private var trackerCellParameters = TrackerCellPrameters(numberOfCellsInRow: 2, height: 148, horizontalSpacing: 10, verticalSpacing: 0)
    
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
        filterButton.backgroundColor = .lunchScreeBlue
        filterButton.layer.cornerRadius = 17
        let filterButtonText = "Фильтры"
        filterButton.setTitle(filterButtonText, for: .normal)
        filterButton.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        filterButton.titleLabel?.tintColor = .ypWhite
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return filterButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setSublayer()
        setConstrains()
        
        //        guard let currentDate = currentDate else {
        //            print("Нет текущей даты")
        //            return }
        //        let weekday = DateFormatter.weekday(date: currentDate)
        //        for tracker in trackers {
        //            if tracker.schedule.contains(weekday) {
        //                trackersForCurrentDate.append(tracker)
        //            }
        //        }
        //        if trackersForCurrentDate.isEmpty {
        //            trackerCollectionView.isHidden = true
        //        } else {
        //            trackerCollectionView.isHidden = false
        //        }
        
    }
    
    @objc func filterButtonTapped(){
        //TODO: - add filter button action
    }
    
    func fontNames(){
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
    
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

extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(trackersForCurrentDate.count)
        if trackersForCurrentDate.count == 0 {
            return 0
        } else {
            let trackers = trackersForCurrentDate[section].trackersOfCategory
            return trackers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        let tracker = trackersForCurrentDate[indexPath.section].trackersOfCategory[indexPath.row]
        let isCompletedToday = isTrackerCompletedToday(id: tracker.trackerId)
        let completedDays = completedTrackers.filter { trackerRecord in
            trackerRecord.trackerId == tracker.trackerId
        }.count
        cell.configure(with: tracker, isCompletedToday: isCompletedToday, indexPath: indexPath, completedDays: completedDays)
        cell.delegate = self
        return cell
    }
    
    func isTrackerCompletedToday(id: UUID) -> Bool{
        guard let date = currentDate else {
            print("Нет даты")
            return false }
        let isTrackerCompleted =  completedTrackers.contains { trackerRecord in
            let day = Calendar.current.isDate(trackerRecord.tackerDate, inSameDayAs: date)
            return trackerRecord.trackerId == id &&
            trackerRecord.tackerDate == date
        }
        print(isTrackerCompleted)
        return isTrackerCompleted
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
            headerView.titleLable.text = categories[indexPath.section].categoryName
        } else {
            headerView.titleLable.text = ""
        }
        return headerView
    }
}


extension TrackerViewController: TrackerCollectionViewCellProtocol {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        guard let date = currentDate else {
            assertionFailure("Нет даты")
            return}
        let trackerRecord = TrackerRecord(trackerId: id, tackerDate: date)
        completedTrackers.append(trackerRecord)
//        trackerCollectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        guard let date = currentDate else {
            assertionFailure("Нет даты")
            return}
        completedTrackers.removeAll { trackerRecord in
            trackerRecord.trackerId == id &&
            trackerRecord.tackerDate == date
        }
//        trackerCollectionView.reloadItems(at: [indexPath])
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
}


extension TrackerViewController: HabbitCreateViewControllerProtocol {
    func createTracker(category: String, tracker: Tracker) {
        let isCategoryExist = categories.contains { trackerCategory in
            trackerCategory.categoryName == category
        }
        
        var trackers: [Tracker] = []
        if isCategoryExist {
            for eachCategory in categories {
                if eachCategory.categoryName == category {
                    trackers = eachCategory.trackersOfCategory
                    trackers.append(tracker)
                    categories.removeAll { trackerCategory in
                        trackerCategory.categoryName == category
                    }
                    categories.append(TrackerCategory(categoryName: category, trackersOfCategory: trackers))

                }
            }
        } else {
            categories.append(TrackerCategory(categoryName: category, trackersOfCategory: [tracker]))
        }
        trackerCollectionView.isHidden = false
        filterButton.isHidden = false
        trackerCollectionView.reloadData()
    }
}
