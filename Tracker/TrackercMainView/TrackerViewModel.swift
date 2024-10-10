//
//  TrackerViewModel.swift
//  Tracker
//
//  Created by Fedor on 13.08.2024.
//

import Foundation

final class TrackerViewModel: TrackerViewModelProtocol, FilterViewControllerProtocol {
    
    var todayDate: Date? {
        didSet {
            guard let todayDate = todayDate else { return }
            selectedDate = todayDate
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
            guard let selectedDate = selectedDate else { return }
            updateTrackersForCurrentDate(selectedDate: selectedDate, searchedText: searchedText, selectedFilter: selectedFilter)
                selectedFilterBinding?(selectedFilter)
        }
    }

    private(set) var indexPathAndSection: IndexPathAndSection? {
        didSet{
            guard let indexPathAndSection = indexPathAndSection else { return }
            indexPathAndSectionBinding?(indexPathAndSection)
        }
    }
    
    //MARK: - CoreData Constants
    
    private lazy var trackerStore = TrackerStore(delegate: self)//, currentDate: selectedDate, searchedText: searchedText)
    private var trackerRecordStore: TrackerRecordStore
    
    //MARK: - Bindings
    
    var indexPathAndSectionBinding: Binding<IndexPathAndSection>?
    var currentDateBinding: Binding<Date>?
    var todayDateBinding: Binding<Date>?
    var searchedTextBinding: Binding<String>?
    var selectedFilterBinding: Binding<String>?
    
    //MARK: - Metrica
    
    private var metrica: Metrica
    
    init() {
        self.selectedDate = Date().removeTimeInfo
        self.trackerRecordStore = TrackerRecordStore()
        self.metrica = Metrica()
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

    
    //MARK: - Metrica Methods
    
    func screenOpenMetrica() {
        metrica.screenOpen()
    }
    
    func screenClosedMetrica() {
        metrica.screenClosed()
    }
    
    func addTrackerMetrica() {
        metrica.addTracker()
    }
    
    func completeTracker() {
        metrica.completeTracker()
    }
    
    func filterTrackerMetrica() {
        metrica.filterTracker()
    }
    
    func editTrackerMetrica() {
        metrica.editTracker()
    }
    
    func deleteTrackerMetrica() {
        metrica.deleteTracker()
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
            isCompletedBefore: isCompletedBefore,
            isPined: false,
            metrica: metrica)
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
        isCompletedBefore: isCompletedBefore,
            isPined: true,
            metrica: metrica)
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


extension TrackerViewModel {
    
    func calculateAverage() -> Int {
        return trackerRecordStore.calculateAverage()
    }
    
    func calculateTrackersCompleted() -> Int {
        return trackerRecordStore.calculateTrackersCompleted()
    }
    
    func calculatePerfectDays() -> Int {
        let trackerDates = trackerRecordStore.getCompletedDatesArray()
        var perfectDays = 0
        if trackerDates.isEmpty {
            return 0
        } else {
            for day in trackerDates {
                let completedTrackersPerDay = trackerRecordStore.getCompletedTrackersPerDay(date: day)
                let totalTrackersPerDay = trackerStore.getActiveTrackersPerDay(date: day)
                if completedTrackersPerDay == totalTrackersPerDay {
                    perfectDays += 1
                }
            }
        }
        return perfectDays
    }
    
    func calculateBestPeriod() -> Int {
        
        let trackerDates = trackerRecordStore.getCompletedDatesArray()
        var period = 1
        var perfectDates: [Date] = []
        if trackerDates.isEmpty {
            return 0
        } else {
            for day in trackerDates {
                let completedTrackersPerDay = trackerRecordStore.getCompletedTrackersPerDay(date: day)
                let totalTrackersPerDay = trackerStore.getActiveTrackersPerDay(date: day)
                if completedTrackersPerDay == totalTrackersPerDay {
                    perfectDates.append(day)
                }
            }
        }
        print (perfectDates)
        if perfectDates.count == 0 {
            return 0
        } else if perfectDates.count == 1 {
            return 1
        } else {
            var periods: [Int] = []
            for i in 0...(perfectDates.count - 2) {
                let perfectDayComparison = daysBetweenDate(startDate: perfectDates[i], endDate: perfectDates[i + 1])
                if perfectDayComparison == 1 {
                    period += 1
                    periods.append(period)
                } else {
                    period = 1
                    periods.append(period)
                }
            }
            guard let bestPeriod = periods.max() else { return 0 }
            return bestPeriod
        }
    }
    
    
    func daysBetweenDate(startDate: Date, endDate: Date) -> Int {

        let calendar = Calendar.current

        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        guard let period = components.day else { return 0}
        return period
    }
}

