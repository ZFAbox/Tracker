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
//
//    private lazy var trackerCategoryStore = TrackerCategoryStore(delegate: self, currentDate: currentDate, searchedText: searchedText)
//    private lazy var trackerRecordStore = TrackerRecordStore()
//    var completerTrackerId: Set<UUID> = []
//    var completedTrackers: [TrackerRecord] = []
    private(set) var indexPathAndSection: IndexPathAndSection? {
        didSet{
            guard let indexPathAndSection = indexPathAndSection else { return }
            indexPathAndSectionBinding?(indexPathAndSection)
        }
    }
    
    var indexPathAndSectionBinding: Binding<IndexPathAndSection>?

//    var currentDate: Date? {
//        didSet {
//            updateTrackersForCurrentDate(searchedText: nil)
//        }
//    }
//    private var searchedText: String = ""
//
//    private var trackerCellParameters = TrackerCellPrameters(numberOfCellsInRow: 2, height: 148, horizontalSpacing: 10, verticalSpacing: 0)
    
}

extension TrackerViewModel: TrackerStoreUpdateDelegateProtocol {
//    func addTracker(indexPath: IndexPath, insetedSections: Int?) {
//        <#code#>
//    }
    
    func updateTrackers(with indexPathAndSection: IndexPathAndSection) {
        self.indexPathAndSection = indexPathAndSection
    }
    

}

