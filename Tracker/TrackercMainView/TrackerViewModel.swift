//
//  TrackerViewModel.swift
//  Tracker
//
//  Created by Fedor on 13.08.2024.
//

import Foundation

final class TrackerViewModel {
    
//    private var categories: [TrackerCategory] = []
//    private var trackersForCurrentDate: [TrackerCategory] = []
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
    
    private lazy var trackerCategoryStore = TrackerCategoryStore(delegate: self, currentDate: currentDate, searchedText: searchedText)
    private lazy var trackerRecordStore = TrackerRecordStore()
//    var completerTrackerId: Set<UUID> = []
//    var completedTrackers: [TrackerRecord] = []
    private(set) var indexPathAndSection: IndexPathAndSection? {
        didSet{
            guard let indexPathAndSection = indexPathAndSection else { return }
            indexPathAndSectionBinding?(indexPathAndSection)
        }
    }
    
    var indexPathAndSectionBinding: Binding<IndexPathAndSection>?
    var currentDateBinding: Binding<Date>?
    var searchedTextBinding: Binding<String>?

//
//    private var trackerCellParameters = TrackerCellPrameters(numberOfCellsInRow: 2, height: 148, horizontalSpacing: 10, verticalSpacing: 0)
    
    
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
    
    func isCompletedTracker(for id: UUID, and date: Date) -> Bool {
        trackerRecordStore.isCompletedTrackerRecords(id: id, date: date)
    }
    
    func headerTitle(for indexPath: IndexPath) -> String {
        trackerCategoryStore.header(indexPath)
    }
}

extension TrackerViewModel: TrackerStoreUpdateDelegateProtocol {
//    func addTracker(indexPath: IndexPath, insetedSections: Int?) {
//        <#code#>
//    }
    
    func updateTrackers(with indexPathAndSection: IndexPathAndSection) {
        self.indexPathAndSection = indexPathAndSection
    }
    

}

