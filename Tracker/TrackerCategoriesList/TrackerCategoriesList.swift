//
//  TrackerCategoriesList.swift
//  Tracker
//
//  Created by Fedor on 14.08.2024.
//

import Foundation
import UIKit

protocol SelectCategoryForTrackerProtocl {
    func setSelectedCategory(_ category: String)
}

final class TrackerCategoriesList: UIViewController {
    
    var trackerCategoriesViewModel: TrackerCategoriesViewModel
    
    private var trackerTableViewController: TrackerTableViewController?
    
    private lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        let categoryListTitle = NSLocalizedString("categoryListTitle", comment: "")
        titleLable.text = categoryListTitle
        titleLable.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        return titleLable
    }()
    
    private lazy var createCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        let createCategoryButtonText = NSLocalizedString("createCategoryButtonText", comment: "")
        button.setTitle(createCategoryButtonText, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        button.backgroundColor = .trackerBlack
        button.tintColor = .trackerWhite
        button.addTarget(self, action: #selector(createCategory), for: .touchUpInside)
        return button
    }()
    
    init(delegate: SelectCategoryForTrackerProtocl?) {
        self.trackerCategoriesViewModel = TrackerCategoriesViewModel(delegate: delegate)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        addSubviews()
        setConstraints()
        setTableView()
    }
    
    @objc func createCategory(){
        if trackerCategoriesViewModel.isCategorySelected {
            trackerCategoriesViewModel.setCategory()
            self.dismiss(animated: true)
        } else {
            guard let trackerTableViewController = trackerTableViewController else { return }
            let vc = TrackerCategoryCreate(delegate: trackerTableViewController)
            vc.modalPresentationStyle = .popover
            self.present(vc, animated: true)
        }
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
        trackerTableViewController = TrackerTableViewController(delegate: trackerCategoriesViewModel )
        guard let trackerTableViewController = trackerTableViewController else { return }
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








