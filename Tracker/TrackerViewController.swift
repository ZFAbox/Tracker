//
//  ViewController.swift
//  Tracker
//
//  Created by Федор Завьялов on 31.05.2024.
//
import Foundation
import UIKit

final class TrackerViewController: UIViewController {
    
    private lazy var trackerLabel: UILabel = {
        let trackerLabel = UILabel()
        trackerLabel.font = UIFont(name: "SFProDisplay-Bold", size: 34)
        
        trackerLabel.text = "Трекеры"
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerLabel.textColor = .trackerBlack
        return trackerLabel
    }()
    
    private lazy var searchField: UISearchBar = {
        let searchField = UISearchBar()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = "Поиск"
        searchField.sizeToFit()
        searchField.searchTextField.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        searchField.layer.borderWidth = 1
        searchField.layer.borderColor = UIColor.white.cgColor
        return searchField
    }()
    
    private lazy var emptyTrackerListImage: UIImageView = {
        let emptyTrackerListImage = UIImageView()
        emptyTrackerListImage.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Empty Tracker List") ?? UIImage()
        emptyTrackerListImage.image = image
        return emptyTrackerListImage
    }()
    
    private lazy var emptyTrackerListText: UILabel = {
        let emptyTrackerListText = UILabel()
        emptyTrackerListText.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackerListText.text = "Что будем отслеживать?"
        emptyTrackerListText.font = UIFont(name: "SFProDisplay-Medium", size: 12)
        emptyTrackerListText.tintColor = .trackerBlack
        return emptyTrackerListText
    }()
    
    private lazy var dummyView: UIView = {
        let dummyView = UIView()
        dummyView.translatesAutoresizingMaskIntoConstraints = false
//        dummyView.backgroundColor = .blue
        dummyView.sizeToFit()
        return dummyView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        fontNmaes()
        
        setSublayer()
        setConstrains()
        
    }
    
    func fontNmaes(){
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
    
    func setSublayer(){
        view.addSubview(trackerLabel)
        view.addSubview(searchField)
        view.addSubview(dummyView)
        setDummySublayers()
    }
    
    func setDummySublayers(){
        dummyView.addSubview(emptyTrackerListImage)
        dummyView.addSubview(emptyTrackerListText)
    }
    
    func setConstrains(){
        setLableConstrains()
        setSearchFieldConstrains()
        dummyViewConstrains()
    }
    
    func setLableConstrains(){
        NSLayoutConstraint.activate([
            trackerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            trackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func setSearchFieldConstrains (){
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 16),
            searchField.leadingAnchor.constraint(equalTo: trackerLabel.leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: trackerLabel.trailingAnchor)
        ])
    }
    
    func dummyViewConstrains() {
        NSLayoutConstraint.activate([
            dummyView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            dummyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            dummyView.leadingAnchor.constraint(equalTo: searchField.leadingAnchor),
            dummyView.trailingAnchor.constraint(equalTo: searchField.trailingAnchor)
        ])
        emptyTrackerListImageConstrains()
        emptyTrackerListTextConstrains()
    }
    
    func emptyTrackerListImageConstrains(){
        NSLayoutConstraint.activate([
            emptyTrackerListImage.centerXAnchor.constraint(equalTo: dummyView.centerXAnchor),
            emptyTrackerListImage.centerYAnchor.constraint(equalTo: dummyView.centerYAnchor, constant: -26),
            emptyTrackerListImage.heightAnchor.constraint(equalToConstant: 80),
            emptyTrackerListImage.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func emptyTrackerListTextConstrains(){
        NSLayoutConstraint.activate([
            emptyTrackerListText.centerXAnchor.constraint(equalTo: dummyView.centerXAnchor),
            emptyTrackerListText.topAnchor.constraint(equalTo: emptyTrackerListImage.bottomAnchor, constant: 8)
        ])
    }
    
}

