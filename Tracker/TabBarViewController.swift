//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Федор Завьялов on 01.06.2024.
//

import Foundation
import UIKit

final class TabBarViewController: UITabBarController {
    
    let trackerViewController = TrackerViewController(viewModel: TrackerViewModel())
    let statisticViewController = StatisticViewController()
    
    private lazy var datePicker: UIDatePicker = {
      let datePicker = UIDatePicker(frame: .zero)
        datePicker.isEnabled = true
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        let locale = Locale(identifier: "ru_CH")
        datePicker.locale = locale
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(datePickerChangeValue(_ :)), for: .valueChanged)
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 85),
            datePicker.heightAnchor.constraint(equalToConstant: 34)])
      return datePicker
    }()
    
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
        setupNavigationBar()
    }
    
    func setupTabBar(){
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.borderColor = UIColor.trackerDarkGray.cgColor
       
        trackerViewController.tabBarItem = UITabBarItem(
            title: TabBars.trackers.localizedText,
            image: UIImage(named: "Circle"),
            selectedImage: nil
        )
        statisticViewController.tabBarItem = UITabBarItem(
            title: TabBars.statistic.localizedText,
            image: UIImage(named: "Hare"),
            selectedImage: nil)
        
        self.viewControllers = [trackerViewController, statisticViewController]
    }
    
    func setupNavigationBar(){
        let leftNavigationbuttonImage = UIImage(named: "Tracker Add Plus")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftNavigationbuttonImage, style: .plain, target: self, action: #selector(addTarget))
        self.navigationItem.leftBarButtonItem?.tintColor = .trackerBlack
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
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
    
    @objc func datePickerChangeValue(_ sender: UIDatePicker){
        sender.layer.opacity = 1
        let selectedDate = sender.date
        trackerViewController.viewModel.currentDate = selectedDate.removeTimeInfo
    }
}


