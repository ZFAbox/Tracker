//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Федор Завьялов on 01.06.2024.
//

import Foundation
import UIKit

final class TabBarViewController: UITabBarController {
    
    let viewModel = TrackerViewModel()
    lazy var trackerViewController = TrackerViewController(viewModel: self.viewModel)
    lazy var statisticViewController = StatisticViewController(viewModel: self.viewModel)
    
    enum TabBars: String {
        case trackers
        case statistic
        
        var localizedText: String {
            switch self {
            case .trackers:
                return NSLocalizedString("trackers", comment: "Trackers screen tab text")
            case .statistic:
                return NSLocalizedString("statistic", comment: "Statistic screen tab text")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        traitCollectionDidChange(.current)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let isDarkStryle = traitCollection.userInterfaceStyle == .dark
        self.tabBar.layer.borderColor = isDarkStryle ? UIColor.trackerBorderDark.cgColor : UIColor.trackerDarkGray.cgColor
        self.tabBar.backgroundColor = isDarkStryle ? .trackerBlack : .trackerWhite
    }
    
    func setupTabBar(){
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.borderColor = UIColor.trackerDarkGray.cgColor
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: TabBars.trackers.localizedText,
            image: UIImage(named: "Circle"), tag: 1
        )
        statisticViewController.tabBarItem = UITabBarItem(
            title: TabBars.statistic.localizedText,
            image: UIImage(named: "Hare"), tag: 2
        )
        
        self.viewControllers = [trackerViewController, statisticViewController]
    }
}


