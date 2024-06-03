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
        let rightNavigationLable = UILabel()
        rightNavigationLable.backgroundColor = .red
        rightNavigationLable.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.YY"
        let date = dateformatter.string(from: Date())
        rightNavigationLable.text = date
        let datePicker = UIDatePicker()
//        let locale = Locale(identifier: "ru")
//        datePicker.locale = locale
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date

//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: date, style: .plain, target: self, action: #selector(datePickerActivate))
        self.navigationItem.rightBarButtonItem?.tintColor = .trackerBlack
        self.navigationItem.rightBarButtonItem?.customView?.layer.backgroundColor = CGColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        
    }
    
    @objc func addTarget(){
        print("Добавить цель")
    }
    
    @objc func datePickerActivate(){
        let datePicker = UIDatePicker()
//        let locale = Locale(identifier: "ru")
//        datePicker.locale = locale
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .automatic
    }
}


