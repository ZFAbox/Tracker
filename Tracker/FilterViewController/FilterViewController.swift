//
//  FilterViewController.swift
//  Tracker
//
//  Created by Fedor on 18.09.2024.
//

import Foundation
import UIKit

protocol FilterViewControllerProtocol {
    var isFilterSelected: Bool { get set }
    var selectedFilter: String { get set }
    var todayDate: Date? { get set }
    var selectedDate: Date? { get set }
}

final class FilterViewController: UIViewController {
    
    private var delegate: FilterViewControllerProtocol
    
    private var filters: [String] = {
        let allTrackers = NSLocalizedString("allTrackers", comment: "")
        let trackerForToday = NSLocalizedString("trackerForToday", comment: "")
        let completedTrackers = NSLocalizedString("completedTrackers", comment: "")
        let notCompletedTracker = NSLocalizedString("notCompletedTracker", comment: "")
        let filters = [allTrackers, trackerForToday, completedTrackers, notCompletedTracker]
        return filters
    }()
    
    private var isFilterSelected: Bool
    private var selectedFilter: String
    
    private lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        let filterTitle = NSLocalizedString("filterTitle", comment: "")
        titleLable.text = filterTitle
        titleLable.textColor = .titleTextColor
        titleLable.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        return titleLable
    }()
    
    private lazy var filtertTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .applicationBackgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 75
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    init(delegate: FilterViewControllerProtocol, isFilterSelected: Bool, selectedFilter: String) {
        self.delegate = delegate
        self.isFilterSelected = isFilterSelected
        self.selectedFilter = selectedFilter
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .applicationBackgroundColor
        addSubviews()
        setConstrints()
        traitCollectionDidChange(.current)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        let trackerForToday = NSLocalizedString("trackerForToday", comment: "")
        if selectedFilter == trackerForToday {
            delegate.todayDate = Date.removeTimeStamp(fromDate: Date())
        }
        delegate.isFilterSelected = isFilterSelected
        delegate.selectedFilter = selectedFilter
    }
    
    private func addSubviews() {
        [titleLable, filtertTableView].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
    }
    
    private func setConstrints() {
        setTitleConstraints()
        setFilterTableViewConstraints()
    }
    
    private func setTitleConstraints(){
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLable.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setFilterTableViewConstraints() {
        NSLayoutConstraint.activate([
            filtertTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            filtertTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filtertTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filtertTableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * filters.count))
        ])
    }
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilterTableViewCell
        let filterNameText = filters[indexPath.row]
        cell.setFilterNameText(filterNameText)
        cell.backgroundColor = .tableCellBackgoundColor
        cell.checkMarkIsHidden(!((isFilterSelected == true) && (filters[indexPath.row] == selectedFilter)))
        cell.separateViewIsHidden(indexPath.row == filters.count - 1)
        return cell
    }
}

extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! FilterTableViewCell
        if !cell.isCheckMarkHidden()  {
            cell.checkMarkIsHidden(true)
            isFilterSelected = false
            selectedFilter = ""
        } else {
            cell.checkMarkIsHidden(false)
            selectedFilter = cell.getFilterNameText()
            isFilterSelected = true
            for cellIndex in 0...filters.count - 1 {
                if cellIndex != indexPath.row {
                    let otherCell = tableView.cellForRow(at: IndexPath(row: cellIndex, section: 0)) as! FilterTableViewCell
                    otherCell.checkMarkIsHidden(true)
                }
            }
        }
    }
}

