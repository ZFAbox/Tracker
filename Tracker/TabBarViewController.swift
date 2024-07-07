//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Федор Завьялов on 01.06.2024.
//

import Foundation
import UIKit

final class TabBarViewController: UITabBarController {
    
    
    let trackerViewController = TrackerViewController()
    let statisticViewController = StatisticViewController()
    
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
        trackerViewController.currentDate = selectedDate
        
        let weekdayNumber = Calendar.current.dateComponents([.weekday], from: selectedDate).weekday
        guard let weekdayNumber = weekdayNumber else { return }
        var weekday = ""
        switch weekdayNumber {
        case 1: weekday = "Воскресенье"
        case 2: weekday = "Понедельник"
        case 3: weekday = "Вторник"
        case 4: weekday = "Среда"
        case 5: weekday = "Четверг"
        case 6: weekday = "Пятница"
        case 7: weekday = "Суббота"
        default: weekday = "Нет такой даты"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.mm.YYYY"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print(weekday)
    }
}


