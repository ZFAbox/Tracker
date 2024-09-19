//
//  TrackerViewModel.swift
//  Tracker
//
//  Created by Fedor on 13.08.2024.
//

import Foundation

final class TrackerViewModel: FilterViewControllerProtocol {
    
    var todayDate: Date? {
        didSet {
            guard let todayDate = todayDate else { return }
            todayDateBinding?(todayDate)
        }
    }
    
    var selectedDate: Date? {
        didSet {
            let selectedDate = selectedDate ?? DateFormatter.removeTime(date: Date())
            updateTrackersForCurrentDate(selectedDate: selectedDate, searchedText: searchedText, selectedFilter: selectedFilter)
            currentDateBinding?(selectedDate)
        }
    }
    
    var searchedText: String = "" {
        didSet{
            let selectedDate = selectedDate ?? DateFormatter.removeTime(date: Date())
            updateTrackersForCurrentDate(selectedDate: selectedDate, searchedText: searchedText, selectedFilter: selectedFilter)
            searchedTextBinding?(searchedText)
        }
    }
    
    var isFilterSelected: Bool = false
    
    var selectedFilter: String = "" {
        didSet{
            if isFilterSelected {
                guard let selectedDate = selectedDate else { return }
                updateTrackersForCurrentDate(selectedDate: selectedDate, searchedText: searchedText, selectedFilter: selectedFilter)
                selectedFilterBinding?(selectedFilter)
            }
        }
    }

    private(set) var indexPathAndSection: IndexPathAndSection? {
        didSet{
            guard let indexPathAndSection = indexPathAndSection else { return }
            indexPathAndSectionBinding?(indexPathAndSection)
        }
    }
    
    //MARK: - CoreData Constants
    
    private lazy var trackerStore = TrackerStore(delegate: self, currentDate: selectedDate, searchedText: searchedText)
    private var trackerRecordStore: TrackerRecordStore
    
    //MARK: - Bindings
    
    var indexPathAndSectionBinding: Binding<IndexPathAndSection>?
    var currentDateBinding: Binding<Date>?
    var todayDateBinding: Binding<Date>?
    var searchedTextBinding: Binding<String>?
    var selectedFilterBinding: Binding<String>?
    
    init() {
        self.selectedDate = Date().removeTimeInfo
        self.trackerRecordStore = TrackerRecordStore()
    }

    //MARK: - Collection View Update Methods
    
    private func updateTrackersForCurrentDate(selectedDate: Date, searchedText: String, selectedFilter: String){
        trackerStore.updateTrackerList(currentDate: selectedDate, searchedText: searchedText, isFilterSelected: isFilterSelected, selectedFilter: selectedFilter)
    }
    
    func numberOfItemsIn(_ section: Int) -> Int {
        trackerStore.numberOfItemsInSection(section)
    }
    
    func numberOfItemsInPinCategory(_ section: Int) -> Int {
        trackerStore.numberOfItemsInSectionPinCategories(section)
    }
    
    func numberOfSections() -> Int{
        trackerStore.numberOfSections
    }
    
    func numberOfSectionsPinCategory() -> Int{
        trackerStore.numberOfPinSections
    }
    
    func getTracker(for indexPath: IndexPath) -> Tracker? {
        trackerStore.object(indexPath)
    }
    
    func getPinTracker(for indexPath: IndexPath) -> Tracker? {
        trackerStore.objectPinCategoris(indexPath)
    }
    
    func isCompletedTracker(for id: UUID) -> Bool {
        guard let date = selectedDate else {
            print("Нет даты")
            return false }
        return trackerRecordStore.isCompletedTrackerRecords(id: id, date: date)
    }
    
    func isCompletedBefore(for id: UUID) -> Bool {
        guard let date = selectedDate else {
            print("Нет даты")
            return false }
        return trackerRecordStore.isCompletedTrackerBefore(id: id, date: date)
    }
    
    func isVisibalteTrackersEmpty() -> Bool {
        trackerStore.isVisibalteTrackersEmpty(searchedText: searchedText, currentDate: selectedDate ?? Date())
    }
    
    func completedTrackersCount(id:UUID) -> Int {
        trackerRecordStore.completedTrackersCount(id: id)
    }
    
    func isTrackerCompletedToday(id: UUID) -> Bool{
        let isTrackerCompleted = isCompletedTracker(for: id)
        return isTrackerCompleted
    }
    
    func headerTitle(for indexPath: IndexPath) -> String {
        trackerStore.header(indexPath)
    }
    
    func headerPinTitle(for indexPath: IndexPath) -> String {
        trackerStore.headerPinCategories(indexPath)
    }
    
    func performFetches() {
        trackerStore.perform()
    }
    
    func isTrackerExists() -> Bool {
        trackerStore.isTrackersExist()
    }
}

//MARK: - Protocols and extensinons
extension TrackerViewModel: TrackerStoreUpdateDelegateProtocol {
    func updateTrackers(with indexPathAndSection: IndexPathAndSection) {
        self.indexPathAndSection = indexPathAndSection
    }
}

extension TrackerViewModel: TrackerCollectionViewCellProtocol {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        guard let date = selectedDate else {
            assertionFailure("Нет даты")
            return}
        let trackerRecord = TrackerRecord(trackerId: id, trackerDate: date)
        trackerRecordStore.saveTrackerRecord(trackerRecord: trackerRecord)
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        guard let date = selectedDate else {
            assertionFailure("Нет даты")
            return}
        trackerRecordStore.deleteTrackerRecord(id: id, currentDate: date)
    }
    
    func model(indexPath: IndexPath) -> TrackerCellModel? {
        guard let tracker = getTracker(for: indexPath) else { return nil }
        let isCompletedToday = isTrackerCompletedToday(id: tracker.trackerId)
        let completedDays = completedTrackersCount(id: tracker.trackerId)
        let isCompletedBefore = isCompletedBefore(for: tracker.trackerId)
        let model = TrackerCellModel(
            tracker: tracker,
            isCompletedToday: isCompletedToday,
            indexPath: indexPath,
            completedDays: completedDays,
            currentDate: selectedDate,
            isCompletedBefore: isCompletedBefore)
        return model
    }
    
    func modelPinCategory(indexPath: IndexPath) -> TrackerCellModel? {
        guard let tracker = getPinTracker(for: indexPath) else { return nil }
        let isCompletedToday = isTrackerCompletedToday(id: tracker.trackerId)
        let completedDays = completedTrackersCount(id: tracker.trackerId)
        let isCompletedBefore = isCompletedBefore(for: tracker.trackerId)
        let model = TrackerCellModel(
            tracker: tracker,
            isCompletedToday: isCompletedToday,
            indexPath: indexPath,
            completedDays: completedDays,
            currentDate: selectedDate,
        isCompletedBefore: isCompletedBefore)
        return model
    }
    
    func pinTracker(indexPath: IndexPath) {
        trackerStore.pinObject(indexPath: indexPath)
    }
    
    func unPinTracker(indexPath: IndexPath) {
        trackerStore.unPinObject(indexPath: indexPath)
    }
    
    func removeTracker(indexPath: IndexPath) {
        trackerStore.removeObject(indexPath: indexPath)
    }
    
    func removePinTracker(indexPath: IndexPath) {
        trackerStore.removePinObject(indexPath: indexPath)
    }
}

extension TrackerViewModel: TrackerCreateViewControllerProtocol {
    func createTracker(category: String, tracker: Tracker) {
        trackerStore.addRecord(categoryName: category, tracker: tracker)
    }
}

extension TrackerViewModel: TrackerUpdateViewControllerProtocol {
    func updateTracker(category: String, tracker: Tracker, indexPath: IndexPath, isPined: Bool) {
        trackerStore.updateRecord(categoryName: category, tracker: tracker, indexPath: indexPath, isPined: isPined)
    }
}

