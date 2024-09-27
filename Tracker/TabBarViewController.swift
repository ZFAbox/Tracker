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
//    lazy var trackerViewController = TrackerViewController(viewModel: self.viewModel, delegate: self.datePicker)
    lazy var trackerViewController = TrackerViewController(viewModel: self.viewModel)
    lazy var statisticViewController = StatisticViewController(viewModel: self.viewModel)
    
//    private lazy var datePicker: UIDatePicker = {
//      let datePicker = UIDatePicker(frame: .zero)
//        datePicker.isEnabled = true
//        datePicker.preferredDatePickerStyle = .compact
//        datePicker.datePickerMode = .date
//        let locale = Locale(identifier: "ru_CH")
//        datePicker.locale = locale
//        datePicker.translatesAutoresizingMaskIntoConstraints = false
//        datePicker.addTarget(self, action: #selector(datePickerChangeValue(_ :)), for: .valueChanged)
//        NSLayoutConstraint.activate([
//            datePicker.widthAnchor.constraint(equalToConstant: 85),
//            datePicker.heightAnchor.constraint(equalToConstant: 34)])
//      return datePicker
//    }()
//    
//    private lazy var datePickerLable: UILabel = {
//        let trackerLabel = UILabel()
//        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
//        trackerLabel.font = UIFont(name: "SFProDisplay-Regular", size: 17)
//        let trackerMainLable = "11.11.11"
//        trackerLabel.text = trackerMainLable
//        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
//        trackerLabel.textColor = .trackerBlack
//        trackerLabel.backgroundColor = .trackerGray
//        trackerLabel.layer.cornerRadius = 8
//        trackerLabel.clipsToBounds = true
//        trackerLabel.textAlignment = .center
//        trackerLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
//        trackerLabel.widthAnchor.constraint(equalToConstant: 77).isActive = true
//        return trackerLabel
//    }()
    
    @objc func tapPicker(){
    }
    
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
//        setupNavigationBar()
//        viewModel.todayDateBinding = { [weak self] date in
//            self?.datePicker.date = Date()
//        }
        traitCollectionDidChange(.current)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle == .dark {
            self.tabBar.layer.borderColor = UIColor.trackerBorderDark.cgColor
            self.tabBar.backgroundColor = .trackerBlack
//            self.navigationController?.navigationBar.backgroundColor = .trackerBlack
//            self.navigationItem.leftBarButtonItem?.tintColor = .trackerWhite
//            self.datePicker.tintColor = .trackerBlue
//            self.datePicker.backgroundColor = .trackerBlack
//            self.datePicker.tintColorDidChange()

//            self.datePicker.layer.backgroundColor = UIColor.trackerWhite.cgColor
//            view.backgroundColor = .trackerBlack
            
        } else {
            self.tabBar.layer.borderColor = UIColor.trackerDarkGray.cgColor
            self.tabBar.backgroundColor = . trackerWhite
//            self.navigationController?.navigationBar.backgroundColor = .trackerWhite
//            self.navigationItem.leftBarButtonItem?.tintColor = .trackerBlack
//            self.datePicker.tintColor = .trackerBlue
//            self.datePicker.backgroundColor = .trackerWhite
//            self.datePicker.tintColorDidChange()
//            self.datePicker.layer. = UIColor.trackerBlack.cgColor
//            view.backgroundColor = .trackerWhite
        }
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
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
//        self.navigationItem.rightBarButtonItem?.customView = datePickerLable
//        self.navigationItem.rightBarButtonItem?.customView?.isUserInteractionEnabled = false
//        self.navigationItem.rightBarButtonItem?.tintColor = .trackerBlack
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
        trackerViewController.viewModel.selectedDate = selectedDate.removeTimeInfo
    }
}


