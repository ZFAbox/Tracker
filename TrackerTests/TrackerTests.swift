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
        let record = false
        let viewModel = TrackerViewModel()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: "01.01.2024")!
        let vc = TrackerViewController(viewModel: viewModel)
        vc.setDatePickerDate(date: date)
        
        assertSnapshot(of: vc, as: .image, record: record)
    }
    
    func testLightModeTrackerController() {
        
        let record = false
        
        let viewModel = TrackerViewModel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: "01.01.2024")!

        let vc = TrackerViewController(viewModel: viewModel)
        vc.setDatePickerDate(date: date)
        
        if record {
            viewModel.createFixedTrackerForTest()
            assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)), record: record)
        } else {
            assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)), record: record)
        }

    }
    
    func testDarkModeTrackerController() {
        
        let record = false
        
        let viewModel = TrackerViewModel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: "01.01.2024")!

        let vc = TrackerViewController(viewModel: viewModel)
        vc.setDatePickerDate(date: date)
        
        if record {
            viewModel.createFixedTrackerForTest()
            assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)), record: record)
        } else {
            assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)), record: record)
        }

    }

}

