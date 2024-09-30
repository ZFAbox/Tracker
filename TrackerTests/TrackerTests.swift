//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Федор Завьялов on 30.09.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker


final class TrackerTests: XCTestCase {

    func testViewController() {
        let viewModel = TrackerViewModel()
        
        var dateComponents = DateComponents()
        dateComponents.year = 1980
        dateComponents.month = 7
        dateComponents.day = 11
        
        let userCalendar = Calendar(identifier: .gregorian)
        let date = userCalendar.date(from: dateComponents)
        
        let vc = TrackerViewController(viewModel: viewModel)
        viewModel.selectedDate = date
        assertSnapshot(of: vc, as: .image)
    }

}

