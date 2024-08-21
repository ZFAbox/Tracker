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
            currentDateBinding?(currentDate ?? DateFormatter.removeTime(date: Date()))
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
    
    //MARK: - CoreData Constants
    
    private lazy var trackerCategoryStore = TrackerStore(delegate: self, currentDate: currentDate, searchedText: searchedText)
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
        trackerCategoryStore.updateDateAndText(currentDate: currentDate, searchedText: searchedText)
    }
    
//    func addTracker(categoryName: String, tracker: Tracker){
//        trackerCategoryStore.addRecord(categoryName: categoryName, tracker: tracker)
//    }
    
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
        trackerCategoryStore.isVisibalteTrackersEmpty(searchedText: searchedText, currentDate: currentDate ?? Date())
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
    
    func performFetches() {
        trackerCategoryStore.perform()
        currentDate = nil
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
    
    func model(indexPath: IndexPath) -> TrackerCellModel? {
        guard let tracker = getTracker(for: indexPath) else { return nil }
        let isCompletedToday = isTrackerCompletedToday(id: tracker.trackerId)
        let completedDays = completedTrackersCount(id: tracker.trackerId)
        let model = TrackerCellModel(
            tracker: tracker,
            isCompletedToday: isCompletedToday,
            indexPath: indexPath,
            completedDays: completedDays,
            currentDate: currentDate)
        return model
    }
}

extension TrackerViewModel: TrackerCreateViewControllerProtocol {
    func createTracker(category: String, tracker: Tracker) {
//        addTracker(categoryName: category, tracker: tracker)
        trackerCategoryStore.addRecord(categoryName: category, tracker: tracker)
    }
}

