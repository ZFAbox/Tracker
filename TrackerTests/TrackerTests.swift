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
        
        assertSnapshot(of: vc, as: .image)
    }
    
//    func lightModeTestTrackerController() {
//        let viewModel = TrackerViewModel()
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd.MM.yyyy"
//        let date = dateFormatter.date(from: "01.01.2024")!
//        viewModel.createFixedTrackerForTest()
//        let vc = TrackerViewController(viewModel: viewModel)
//        vc.setDatePickerDate(date: date)
//        
//        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)), record: true)
//    }
    
    
//    func testDarkModeTestTrackerController() {
//        let viewModel = TrackerViewModel()
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd.MM.yyyy"
//        let date = dateFormatter.date(from: "01.01.2024")!
//        viewModel.createFixedTrackerForTest()
//        let vc = TrackerViewController(viewModel: viewModel)
//        vc.setDatePickerDate(date: date)
//        
//        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)), record: true)
//    }

}

final class TrackerLightModeTest: XCTestCase {
    
    func testLightModeTrackerController() {
        let viewModel = TrackerViewModel()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: "01.01.2024")!
        viewModel.createFixedTrackerForTest()
        let vc = TrackerViewController(viewModel: viewModel)
        vc.setDatePickerDate(date: date)
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)), record: true)
    }
}

