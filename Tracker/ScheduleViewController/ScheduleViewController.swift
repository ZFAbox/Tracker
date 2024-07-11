//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Fedor on 11.07.2024.
//

import Foundation
import UIKit

final class ScheduleViewController: UIViewController {
    
    let schedule = [
        Weekdays.Monday.rawValue,
        Weekdays.Tuesday.rawValue,
        Weekdays.Wednesday.rawValue,
        Weekdays.Thursday.rawValue,
        Weekdays.Friday.rawValue,
        Weekdays.Saturday.rawValue,
        Weekdays.Sunday.rawValue
    ]
    
    private lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.text = "Расписание"
        titleLable.tintColor = .trackerBlack
        titleLable.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        return titleLable
    }()
    
    private lazy var scheduleTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.cornerRadius = 16
        table.backgroundColor = .ypWhite
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
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        button.backgroundColor = .trackerBlack
        button.tintColor = .ypWhite
        button.addTarget(self, action: #selector(confirmedButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
        setConstraints()
    }
    
    @objc func confirmedButtonTapped(){
        //TODO: save schedule
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
            scheduleTableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * schedule.count - 1))
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
        schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    func configureCell(_ cell:UITableViewCell, at indexPath: IndexPath){
        cell.textLabel?.text = schedule[indexPath.row]
        let switcher = UISwitch(frame: .zero)
        switcher.setOn(false, animated: true)
        switcher.tag = indexPath.row
        switcher.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        cell.accessoryView = switcher
        cell.backgroundColor = .trackerBackgroundOpacityGray
    }
    
    @objc func switchChanged(_ sender: UISwitch){
    //TODO: - slide switch
    }
}

extension ScheduleViewController: UITableViewDelegate {
    
}
