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

        let datePicker = UIDatePicker()
        datePickerActivate(datePicker: datePicker)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        self.navigationItem.rightBarButtonItem?.tintColor = .trackerBlack
    }
    
    @objc func addTarget(){
        print("Добавить цель")
        let viewController = TrackerTypeSelectViewController()
        viewController.modalPresentationStyle = .popover
        self.present(viewController, animated: true)
    }
    
    func datePickerActivate(datePicker: UIDatePicker){
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        let locale = Locale(identifier: "it_CH")
        datePicker.locale = locale
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(datePickerChangeValue(_ :)), for: .valueChanged)
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 80),
            datePicker.heightAnchor.constraint(equalToConstant: 34)])
    }
    
    @objc func datePickerChangeValue(_ sender: UIDatePicker){
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.NN.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print(formattedDate)
    }
}


