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
    var delegate: ScheduleViewControllerProtocol //RegularTrackerCreateViewController?
    
    private lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        let scheduleTitle = NSLocalizedString("scheduleTitle", comment: "")
        titleLable.text = scheduleTitle
        titleLable.tintColor = .trackerBlack
        titleLable.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        return titleLable
    }()
    
    private lazy var scheduleTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.cornerRadius = 16
        table.backgroundColor = .trackerWhite
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.rowHeight = 75
        table.separatorInset.right = 16
        table.separatorInset.left = 16
        table.separatorColor = .trackerDarkGray
        table.isScrollEnabled = false
        return table
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        let confirmScheduleButtonText = NSLocalizedString("confirmScheduleButtonText", comment: "")
        button.setTitle(confirmScheduleButtonText, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        button.backgroundColor = .trackerBlack
        button.tintColor = .trackerWhite
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
        view.backgroundColor = .trackerWhite
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
        view.addSubview(titleLable)
        view.addSubview(scheduleTableView)
        view.addSubview(confirmButton)
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
            scheduleTableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * Weekdays.scheduleSubtitlesArray.count))
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    func configureCell(_ cell:UITableViewCell, at indexPath: IndexPath){
        cell.textLabel?.text = Weekdays.weekdayForIndex(at: indexPath.row).localized
        let switcher = UISwitch(frame: .zero)
        switcher.setOn(false, animated: true)
        switcher.tag = indexPath.row
        switcher.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        switcher.onTintColor = .trackerBlue
        cell.accessoryView = switcher
        cell.backgroundColor = .trackerBackgroundOpacityGray
    }
    
    @objc func switchChanged(_ sender: UISwitch){
        if sender.isOn {
            let weekday = Weekdays.weekdayForIndex(at: sender.tag)
            trackerSchedule.append( weekday.localized)
            print("Добален день недели \(weekday.localized)")
            scheduleSubtitle.append(Weekdays.shortWeekdayDescription(weekday: weekday))
            scheduleSubtitle = scheduleSubtitle.reorder(by: Weekdays.scheduleSubtitlesArray)
            print(scheduleSubtitle)
        } else {
            trackerSchedule.removeAll { weekday in
                weekday == Weekdays.weekdayForIndex(at: sender.tag).localized
            }
            scheduleSubtitle.removeAll { subtitle in
                subtitle == Weekdays.scheduleSubtitlesArray[sender.tag]
            }
            print("Удален день недели \(Weekdays.weekdayForIndex(at: sender.tag).localized)")
        }
        print(trackerSchedule)
        sender.isEnabled = true
    }
}

extension ScheduleViewController: UITableViewDelegate {
    
}

