//
//  TrackerCategoriesList.swift
//  Tracker
//
//  Created by Fedor on 14.08.2024.
//

import Foundation
import UIKit

final class TrackerCategoriesList: UIViewController {
    
    private var isCategorySelected: Bool = false
    
    private var selectedCategory: String?
    
    private lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.text = "Категория"
        titleLable.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        return titleLable
    }()
    
    private lazy var createCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        button.backgroundColor = .trackerBlack
        button.tintColor = .trackerWhite
        button.addTarget(self, action: #selector(createCategory), for: .touchUpInside)
        return button
    }()

    @objc func createCategory(){
        
       //TODO: - Действие добавления категории
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        addSubviews()
        setConstraints()
        setTableView()
    }
    
    private func addSubviews(){
        view.addSubview(titleLable)
        view.addSubview(createCategoryButton)
    }
    
    private func setConstraints(){
        setTitleConstraints()
        setCreateButtonConstraints()
    }
    
    private func setTitleConstraints(){
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLable.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    private func setCreateButtonConstraints(){
        NSLayoutConstraint.activate([
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setTableView(){
        let trackerTableViewController = TrackerTableViewController(delegate: self)
        
        guard let trackerTableView = trackerTableViewController.view else { return }
        trackerTableView.translatesAutoresizingMaskIntoConstraints = false
        addChild(trackerTableViewController)
        view.addSubview(trackerTableView)
        
        NSLayoutConstraint.activate([
            trackerTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            trackerTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackerTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackerTableView.bottomAnchor.constraint(equalTo: createCategoryButton.topAnchor, constant: -8)
        ])
        
        trackerTableViewController.didMove(toParent: self)
    }
}

extension TrackerCategoriesList: TrackerCategoryIsSelectedProtocol {
    func isCategorySelected(_ isCategorySelected: Bool, selectedCategory: String?) {
        self.isCategorySelected = isCategorySelected
        self.selectedCategory = selectedCategory
    }
    
    
}




