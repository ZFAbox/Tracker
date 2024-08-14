//
//  TrackerCategoriesList.swift
//  Tracker
//
//  Created by Fedor on 14.08.2024.
//

import Foundation
import UIKit

final class TrackerCategoriesList: UIViewController {
    
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
    
    private lazy var emptyCategoryListImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Empty Tracker List") ?? UIImage()
        imageView.image = image
        return imageView
    }()
    
    private lazy var emptyCategoryListText: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = """
        Привычки и события можно
        объединить по смыслу
        """
        text.font = UIFont(name: "SFProDisplay-Medium", size: 12)
        text.tintColor = .trackerBlack
        return text
    }()
    
    lazy var categoriesListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .trackerWhite
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackerCategoriesListCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 75
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.separatorColor = .trackerDarkGray
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    
    @objc func createCategory(){
       //TODO: - Действие добавления категории
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setConstrains()
    }
    
    
    private func addSubviews(){
        view.addSubview(titleLable)
        view.addSubview(createCategoryButton)
    }
    
    private func setConstrains(){
        
    }
}

//MARK: - Delegate and Data Source

extension TrackerCategoriesList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}

extension TrackerCategoriesList: UITableViewDelegate {
    
}
