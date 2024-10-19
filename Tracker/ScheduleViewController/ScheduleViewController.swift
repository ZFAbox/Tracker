//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Fedor on 11.07.2024.
//

import Foundation
import UIKit

protocol ScheduleViewControllerProtocol {
    var trackerSchedule: [String] { get set }
    var scheduleSubtitle: String? { get set }
    var categoryAndScheduleTableView: UITableView { get set }
}

final class ScheduleViewController: UIViewController {

    private var trackerSchedule: [String] = []
    private var scheduleSubtitle: [String] = []
    var delegate: ScheduleViewControllerProtocol
    
    private lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        let scheduleTitle = NSLocalizedString("scheduleTitle", comment: "")
        titleLable.text = scheduleTitle
        titleLable.tintColor = .titleTextColor
        titleLable.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        return titleLable
    }()
    
    private lazy var scheduleTableView: UITableView = {
        let table = UITableView()
        table.layer.cornerRadius = 16
        table.backgroundColor = .applicationBackgroundColor
        table.dataSource = self
        table.delegate = self
        table.register(ScheduleTableViewCell.self, forCellReuseIdentifier: "cell")
        table.rowHeight = 75
//        table.separatorInset.right = 16
//        table.separatorInset.left = 16
        table.separatorStyle = .none
//        table.separatorColor = .trackerDarkGray
        table.isScrollEnabled = true
        return table
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 16
        let confirmScheduleButtonText = NSLocalizedString("confirmScheduleButtonText", comment: "")
        button.setTitle(confirmScheduleButtonText, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        button.backgroundColor = .darkButtonColor
        button.tintColor = .darkButtonTextColor
        button.addTarget(self, action: #selector(confirmedButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(delegate: ScheduleViewControllerProtocol) {
        self.delegate = delegate
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .applicationBackgroundColor
        addSubviews()
        setConstraints()
    }
    
    @objc func confirmedButtonTapped(){
            delegate.trackerSchedule = trackerSchedule
            delegate.scheduleSubtitle = scheduleSubtitle.joined(separator: ", ")
            delegate.categoryAndScheduleTableView.reloadData()
            self.dismiss(animated: true)
    }
    
    private func addSubviews(){
        [titleLable, scheduleTableView, confirmButton].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
    }
    
    private func setConstraints(){
        setTitleConstraints()
        setScheduleTableViewConstraints()
        setConfirmButtonConstraints()
    }
    
    private func setTitleConstraints(){
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLable.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    private func setScheduleTableViewConstraints(){
        NSLayoutConstraint.activate([
            scheduleTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -24)
        ])
    }
    
    private func setConfirmButtonConstraints(){
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Weekdays.scheduleSubtitlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ScheduleTableViewCell
        configureCell(cell, at: indexPath)
        
        if indexPath.row == 6 {
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
    
    func configureCell(_ cell:ScheduleTableViewCell, at indexPath: IndexPath){
        cell.textLabel?.text = Weekdays.weekdayForIndex(at: indexPath.row).localized
        cell.switchButton.setOn(false, animated: true)
        cell.switchButton.tag = indexPath.row
        cell.switchButton.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        cell.switchButton.onTintColor = .trackerBlue
        cell.backgroundColor = .tableCellBackgoundColor
    }
    
    @objc func switchChanged(_ sender: UISwitch){
        if sender.isOn {
            let weekdayNumber = sender.tag + 1
            trackerSchedule.append( String(weekdayNumber))
            scheduleSubtitle.append(Weekdays.shortWeekdayDescription(weekdayNumber: weekdayNumber))
            scheduleSubtitle = scheduleSubtitle.reorder(by: Weekdays.scheduleSubtitlesArray)
        } else {
            trackerSchedule.removeAll { weekdayNumber in
                let removedWeekdayNumber = String(sender.tag + 1)
                return weekdayNumber == removedWeekdayNumber
            }
            scheduleSubtitle.removeAll { subtitle in
                subtitle == Weekdays.scheduleSubtitlesArray[sender.tag]
            }
        }
        sender.isEnabled = true
    }
}

extension ScheduleViewController: UITableViewDelegate {
    
}

