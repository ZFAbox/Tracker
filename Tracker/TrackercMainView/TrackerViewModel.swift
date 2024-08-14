//
//  TrackerViewModel.swift
//  Tracker
//
//  Created by Fedor on 13.08.2024.
//

import Foundation

final class TrackerViewModel {
    
    var currentDate: Date? {
        didSet {
            updateTrackersForCurrentDate(searchedText: "")
            currentDateBinding?(currentDate ?? Date())
        }
    }
    
    var searchedText: String = "" {
        didSet{
            updateTrackersForCurrentDate(searchedText: searchedText)
            searchedTextBinding?(searchedText)
        }
    }

    private(set) var indexPathAndSection: IndexPathAndSection? {
        didSet{
            guard let indexPathAndSection = indexPathAndSection else { return }
            indexPathAndSectionBinding?(indexPathAndSection)
        }
    }
    
    //MARK: - CoreData
    private lazy var trackerCategoryStore = TrackerCategoryStore(delegate: self, currentDate: currentDate, searchedText: searchedText)
    private lazy var trackerRecordStore = TrackerRecordStore()
    
    //MARK: - Bindings
    var indexPathAndSectionBinding: Binding<IndexPathAndSection>?
    var currentDateBinding: Binding<Date>?
    var searchedTextBinding: Binding<String>?

    //MARK: - Collection View Update Methods
    private func updateTrackersForCurrentDate(searchedText: String){
        guard let currentDate = currentDate else {
            print("Нет текущей даты")
            return }
        let weekday = DateFormatter.weekday(date: currentDate)
        let searchText = searchedText.lowercased()
        trackerCategoryStore.updateDateAndText(weekday: weekday, searchedText: searchText)
    }
    
    func addTracker(categoryName: String, tracker: Tracker){
        trackerCategoryStore.addRecord(categoryName: categoryName, tracker: tracker)
    }
    
    func numberOfItemsIn(_ section: Int) -> Int {
        trackerCategoryStore.numberOfItemsInSection(section)
    }
    
    func numberOfSections() -> Int{
        trackerCategoryStore.numberOfSections
    }
    
    func getTracker(for indexPath: IndexPath) -> Tracker? {
        trackerCategoryStore.object(indexPath)
    }
    
    func isCompletedTracker(for id: UUID) -> Bool {
        guard let date = currentDate else {
            print("Нет даты")
            return false }
        return trackerRecordStore.isCompletedTrackerRecords(id: id, date: date)
    }
    
    func isVisibalteTrackersEmpty() -> Bool {
        trackerCategoryStore.isVisibalteTrackersEmpty()
    }
    
    func completedTrackersCount(id:UUID) -> Int {
        trackerRecordStore.completedTrackersCount(id: id)
    }
    
    func isTrackerCompletedToday(id: UUID) -> Bool{
        let isTrackerCompleted = isCompletedTracker(for: id)
        return isTrackerCompleted
    }
    
    func headerTitle(for indexPath: IndexPath) -> String {
        trackerCategoryStore.header(indexPath)
    }
}

//MARK: - Protocols extensinons
extension TrackerViewModel: TrackerStoreUpdateDelegateProtocol {
    func updateTrackers(with indexPathAndSection: IndexPathAndSection) {
        self.indexPathAndSection = indexPathAndSection
    }
}

extension TrackerViewModel: TrackerCollectionViewCellProtocol {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        guard let date = currentDate else {
            assertionFailure("Нет даты")
            return}
        let trackerRecord = TrackerRecord(trackerId: id, trackerDate: date)
        trackerRecordStore.saveTrackerRecord(trackerRecord: trackerRecord)
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        guard let date = currentDate else {
            assertionFailure("Нет даты")
            return}
        trackerRecordStore.deleteTrackerRecord(id: id, currentDate: date)
    }
}

extension TrackerViewModel: HabbitCreateViewControllerProtocol {
    func createTracker(category: String, tracker: Tracker) {
        addTracker(categoryName: category, tracker: tracker)
    }
}

