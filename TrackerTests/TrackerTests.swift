//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Fedor on 11.10.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker


final class TrackerTests: XCTestCase {
    
    func testEmptyViewControllerLight() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        guard let date = dateFormatter.date(from: "01.01.2024") else { return }
        let viewModel = TrackerViewModelMock(selectedDate: date, removeAllTrackers: true)
        
        let vc = TrackerViewController(viewModel: viewModel)	
        vc.setDatePickerDate(date: date)
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testEmptyViewControllerDark() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        guard let date = dateFormatter.date(from: "01.01.2024") else { return }
        let viewModel = TrackerViewModelMock(selectedDate: date, removeAllTrackers: true)
        
        let vc = TrackerViewController(viewModel: viewModel)
        vc.setDatePickerDate(date: date)
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    func testLightModeTrackerController() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        guard let date = dateFormatter.date(from: "01.01.2024") else { return }
        let viewModel = TrackerViewModelMock(selectedDate: date, removeAllTrackers: false)
        
        let vc = TrackerViewController(viewModel: viewModel)
        vc.setDatePickerDate(date: date)
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testDarkModeTrackerController() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        guard let date = dateFormatter.date(from: "01.01.2024") else { return }
        let viewModel = TrackerViewModelMock(selectedDate: date, removeAllTrackers: false)
        
        let vc = TrackerViewController(viewModel: viewModel)
        vc.setDatePickerDate(date: date)
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}

