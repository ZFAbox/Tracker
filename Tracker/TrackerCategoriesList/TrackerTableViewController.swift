//
//  TrackerTableViewController.swift
//  Tracker
//
//  Created by Fedor on 15.08.2024.
//

import Foundation
import UIKit

protocol TrackerCategoryIsSelectedProtocol{
    func isCategorySelected(isCategorySelected: Bool, selectedCategory: String?)
}

final class TrackerTableViewController: UIViewController {
    
    private var trackerCategoriesViewModel: TrackerCategoriesViewModel
    
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
        tableView.separatorStyle = .none
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    init(delegate: TrackerCategoriesViewModel) {
        self.trackerCategoriesViewModel = delegate
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
        setBindings()
    }
    
    func setBindings(){
        trackerCategoriesViewModel.insertedTableIndexesBinding = { [weak self] _ in
            self?.updateCategoryTableList()
        }
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
            categoriesListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - Delegate and Data Source

extension TrackerTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyCategoryListText.isHidden = !trackerCategoriesViewModel.isCategoriesEmpty()
        emptyCategoryListImage.isHidden = !trackerCategoriesViewModel.isCategoriesEmpty()
        let numberOfItems = trackerCategoriesViewModel.numberOfItemsInSection(section)
        return  numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrackerCategoriesListCell
        let categoryName = trackerCategoriesViewModel.object(at: indexPath)
        cell.categoryName.text = categoryName
        cell.accessoryType = .none
        cell.backgroundColor = .trackerBackgroundOpacityGray
        if indexPath.row == trackerCategoriesViewModel.count() - 1 {
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.separatorView.isHidden = true
        } else {
            cell.layer.cornerRadius = 0
            cell.separatorView.isHidden = false
        }
        return cell
    }
}

extension TrackerTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! TrackerCategoriesListCell
        if cell.accessoryType == .checkmark {
            cell.checkMark.isHidden = true
            trackerCategoriesViewModel.isCategorySelected(isCategorySelected: false, selectedCategory: nil)
        } else {
            cell.checkMark.isHidden = false
            let selectedCategory = cell.categoryName.text
            trackerCategoriesViewModel.isCategorySelected(isCategorySelected: true, selectedCategory: selectedCategory)
            for cellIndex in 0...trackerCategoriesViewModel.count() - 1 {
                if cellIndex != indexPath.row {
                    let otherCell = tableView.cellForRow(at: IndexPath(row: cellIndex, section: 0)) as! TrackerCategoriesListCell
                    otherCell.checkMark.isHidden = true
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "Редактировать", handler: { [weak self] _ in
                    self?.edit(at: indexPath)
                }),
                UIAction(title: "Удалить", attributes: UIMenuElement.Attributes.destructive, handler: { [weak self] _ in
                    self?.remove(at: indexPath)
                })
            ])
        })
    }
    
    func remove(at indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Эта категория точно не нужна?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.trackerCategoriesViewModel.removeCategory(at: indexPath)
        }
        
        let cancelButton = UIAlertAction(title: "Отменить", style: .cancel) {  _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
    }
    
    func edit(at indexPath: IndexPath) {
        let vc = TrackerCategoryEditor(delegate: self, indexPath: indexPath)
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
    }
}

extension TrackerTableViewController: UpdateCategoryListProtocol {
    func editCategory(with category: String, indexPath: IndexPath) {
        trackerCategoriesViewModel.editCategory(at: indexPath, with: category)
        categoriesListTableView.reloadData()
    }
    
    func updateCategoryList(with category: String) {
        trackerCategoriesViewModel.saveCategory(category)
    }
    
    func updateCategoryTableList(){
        categoriesListTableView.reloadData()
    }
}

