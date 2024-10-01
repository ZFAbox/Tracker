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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: "01.01.2024")!
        let vc = TrackerViewController(viewModel: viewModel)
        vc.setDatePickerDate(date: date)
        
        assertSnapshot(of: vc, as: .image, record: true)
    }

}

