//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Федор Завьялов on 01.06.2024.
//

import Foundation
import UIKit

final class TabBarViewController: UITabBarController {
    
    enum TabBars: String {
        case trackers = "Трекеры"
        case statistic = "Статистика"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupNavigationBar()
    }
    
    func setupTabBar(){
        self.tabBar.backgroundColor = .white
        
        let trackerViewController = TrackerViewController()
        let statisticViewController = StatisticViewController()
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: TabBars.trackers.rawValue,
            image: UIImage(systemName: "record.circle.fill"),
            selectedImage: nil
        )
        statisticViewController.tabBarItem = UITabBarItem(
            title: TabBars.statistic.rawValue,
            image: UIImage(systemName: "hare.fill"),
            selectedImage: nil)
        self.viewControllers = [trackerViewController, statisticViewController]
    }
    
    func setupNavigationBar(){
        let leftNavigationbuttonImage = UIImage(systemName: "plus")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftNavigationbuttonImage, style: .plain, target: self, action: #selector(addTarget))
        self.navigationItem.leftBarButtonItem?.tintColor = .trackerBlack
        var datePicker = UIDatePicker()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY"
        let date = dateFormatter.string(from: Date())
        datePicker.preferredDatePickerStyle = .compact
        
        datePicker.datePickerMode = .date
        datePicker.locale
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    @objc func addTarget(){
        print("Добавить цель")
    }
    
}


