//
//  TrackerTableViewController.swift
//  Tracker
//
//  Created by Fedor on 15.08.2024.
//

import Foundation
import UIKit

protocol TrackerCategoryIsSelectedProtocol{
    func isCategorySelected(_ isCategorySelected: Bool, selectedCategory: String?)
    func updateLayout()
}

final class TrackerTableViewController: UIViewController {
    
    private var categoryList: [String] = ["Спорт", "Домашние дела", "Учеба"]
    
    private var isSelected = false
    
    private var selectedCategory: String?
    
    var delegate: TrackerCategoryIsSelectedProtocol?
    
    
//    "Спорт", "Домашние дела", "Учеба"
    private lazy var placeholderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.sizeToFit()
        return view
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
        text.numberOfLines = 2
        text.textAlignment = .center
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
    
    init(delegate: TrackerCategoryIsSelectedProtocol?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(placeholderView)
        view.addSubview(categoriesListTableView)
        placeholderView.addSubview(emptyCategoryListImage)
        placeholderView.addSubview(emptyCategoryListText)

        setPLaceholderConstraints()
        setPlaceholderImageConstraints()
        setPlaceholderTexConstraints()
        setCatrgoryTableConstraints()
    }
    
    private func setPLaceholderConstraints(){
        NSLayoutConstraint.activate([
            placeholderView.topAnchor.constraint(equalTo: view.topAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setPlaceholderImageConstraints(){
        NSLayoutConstraint.activate([
            emptyCategoryListImage.heightAnchor.constraint(equalToConstant: 80),
            emptyCategoryListImage.widthAnchor.constraint(equalToConstant: 80),
            emptyCategoryListImage.bottomAnchor.constraint(equalTo: placeholderView.centerYAnchor),
            emptyCategoryListImage.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor)
        ])
    }
    
    private func setPlaceholderTexConstraints(){
        NSLayoutConstraint.activate([
            emptyCategoryListText.topAnchor.constraint(equalTo: emptyCategoryListImage.bottomAnchor, constant: 8),
            emptyCategoryListText.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor)
        ])
    }
    
    private func setCatrgoryTableConstraints(){
        NSLayoutConstraint.activate([
            categoriesListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            categoriesListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesListTableView.heightAnchor.constraint(equalToConstant: CGFloat(categoryList.count * 75 - 1))
        ])
    }
}

//MARK: - Delegate and Data Source

extension TrackerTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyCategoryListText.isHidden = !categoryList.isEmpty
        emptyCategoryListImage.isHidden = !categoryList.isEmpty
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrackerCategoriesListCell
        cell.categoryName.text = categoryList[indexPath.row]
        return cell
    }
}

extension TrackerTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! TrackerCategoriesListCell
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            isSelected = false
            selectedCategory = nil
            delegate?.isCategorySelected(isSelected, selectedCategory: selectedCategory)
        } else {
            cell.accessoryType = .checkmark
            isSelected = true
            selectedCategory = cell.categoryName.text
            delegate?.isCategorySelected(isSelected, selectedCategory: selectedCategory)
            for cellIndex in 0...categoryList.count - 1 {
                if cellIndex != indexPath.row {
                    let otherCell = tableView.cellForRow(at: IndexPath(row: cellIndex, section: 0)) as! TrackerCategoriesListCell
                    otherCell.accessoryType = .none
                }
            }
        }
    }
}

extension TrackerTableViewController: UpdateCategoryListProtocol {
    func updateCategoryList(with category: String) {
        categoryList.append(category)
        categoriesListTableView.updateConstraints()
        categoriesListTableView.reloadData()
        print(categoryList)
        categoriesListTableView.layoutIfNeeded()

    }
}

