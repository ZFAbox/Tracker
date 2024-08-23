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
    
    private lazy var pickerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(datePickerChangeValue(_ :))))
        return view
    }()
    
    enum TabBars: String {
        case trackers = "Трекеры"
        case statistic = "Статистика"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackerViewController.viewModel.currentDate = Date().removeTimeInfo
        setupTabBar()
        setupNavigationBar()
        
        view.addSubview(pickerView)
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pickerView.widthAnchor.constraint(equalToConstant: 80),
            pickerView.heightAnchor.constraint(equalToConstant: 34)
        ])
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
        let leftNavigationbuttonImage = UIImage(named: "Tracker Add Plus")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftNavigationbuttonImage, style: .plain, target: self, action: #selector(addTarget))
        self.navigationItem.leftBarButtonItem?.tintColor = .trackerBlack

        let datePicker = UIDatePicker()
        datePickerActivate(datePicker: datePicker)
        pickerView.addSubview(datePicker)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pickerView)
        self.navigationItem.rightBarButtonItem?.tintColor = .trackerBlack
    }
    
    @objc func addTarget(){
        print("Добавить цель")
        let viewController = TrackerTypeSelectViewController()
        viewController.viewModel = trackerViewController.viewModel
        viewController.delegate = trackerViewController
        viewController.modalPresentationStyle = .popover
        self.present(viewController, animated: true)
    }
    
    func datePickerActivate(datePicker: UIDatePicker){
        datePicker.isEnabled = true
        datePicker.layer.opacity = 0
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        let locale = Locale(identifier: "ru_CH")
        datePicker.locale = locale
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(datePickerChangeValue(_ :)), for: .valueChanged)
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 80),
            datePicker.heightAnchor.constraint(equalToConstant: 34)])
    }
    
    @objc func datePickerChangeValue(_ sender: UIDatePicker){
        sender.layer.opacity = 1
        let selectedDate = sender.date
        trackerViewController.viewModel.currentDate = selectedDate.removeTimeInfo
    }
}


