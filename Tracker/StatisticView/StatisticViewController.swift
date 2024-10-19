//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Федор Завьялов on 01.06.2024.
//

import Foundation
import UIKit

final class StatisticViewController: UIViewController, UITableViewDelegate {
    
    let bestPeriod = NSLocalizedString("bestPeriod", comment: "")
    let perfectDays = NSLocalizedString("perfectDays", comment: "")
    let trackersCompleted = NSLocalizedString("trackersCompleted", comment: "")
    let averageValue = NSLocalizedString("averageValue", comment: "")
    let viewModel: TrackerViewModel
    
    private lazy var statisticSections: [String] = {
        return [bestPeriod, perfectDays, trackersCompleted, averageValue]
    }()
    
    private lazy var staticsticLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont(name: "SFProDisplay-Bold", size: 34)
        let statisticMainLable = NSLocalizedString("statisticMainLable", comment: "Main Lable")
        lable.text = statisticMainLable
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = .trackerBlack
        return lable
    }()
    
    private lazy var statisticTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(StatisticCellView.self, forCellReuseIdentifier: "cell")
        table.rowHeight = 102
        table.backgroundColor = .trackerWhite
        table.separatorStyle = .none
        table.allowsSelection = false
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private lazy var emptyStatisticImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Empty Statistics") ?? UIImage()
        imageView.image = image
        return imageView
    }()
    
    private lazy var emptyStatisticText: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        let emtyStatisticsText = NSLocalizedString("emtyStatisticsText", comment: "Text of empty placeholder")
        lable.text = emtyStatisticsText
        lable.font = UIFont(name: "SFProDisplay-Medium", size: 12)
        lable.tintColor = .trackerBlack
        return lable
    }()
    
    private lazy var emptyStatisticPlaceholderView: UIView = {
        let placeholderView = UIView()
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.sizeToFit()
        return placeholderView
    }()
    
    init(viewModel: TrackerViewModel) {
        self.viewModel = viewModel
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
        let statisticsValues: [Int] = {
            return [viewModel.calculateBestPeriod(),
                    viewModel.calculatePerfectDays(),
                    viewModel.calculateTrackersCompleted(),
                    viewModel.calculateAverage()]
        }()
        let statisticsSum = statisticsValues.reduce(0, +)
        statisticTableView.isHidden = statisticsSum == 0 ? true : false
        traitCollectionDidChange(.current)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let statisticsValues: [Int] = {
            return [viewModel.calculateBestPeriod(),
                    viewModel.calculatePerfectDays(),
                    viewModel.calculateTrackersCompleted(),
                    viewModel.calculateAverage()]
        }()
        let statisticsSum = statisticsValues.reduce(0, +)
        statisticTableView.isHidden = statisticsSum == 0 ? true : false
        statisticTableView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .trackerBlack
            statisticTableView.backgroundColor = .trackerBlack
            staticsticLabel.textColor = .trackerWhite
        } else {
            view.backgroundColor = .trackerWhite
            statisticTableView.backgroundColor = .trackerWhite
            staticsticLabel.textColor = .trackerBlack
        }
    }
    
    private func addSubviews() {
        view.addSubview(staticsticLabel)
        view.addSubview(emptyStatisticPlaceholderView)
        emptyStatisticPlaceholderView.addSubview(emptyStatisticImage)
        emptyStatisticPlaceholderView.addSubview(emptyStatisticText)
        view.addSubview(statisticTableView)
    }
    
    private func setConstraints(){
        setTitleConstraints()
        setStatisticTableConstraints()
        setPlaceholderView()
        setPlaceholderImageConstraints()
        setPlaceholderTextConstraints()
    }
    
    private func setTitleConstraints(){
        NSLayoutConstraint.activate([
            staticsticLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            staticsticLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            staticsticLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setPlaceholderView() {
        
        NSLayoutConstraint.activate([
            emptyStatisticPlaceholderView.topAnchor.constraint(equalTo: staticsticLabel.bottomAnchor),
            emptyStatisticPlaceholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyStatisticPlaceholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emptyStatisticPlaceholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    private func setPlaceholderImageConstraints(){
        NSLayoutConstraint.activate([
            emptyStatisticImage.centerYAnchor.constraint(equalTo: emptyStatisticPlaceholderView.centerYAnchor, constant: -13),
            emptyStatisticImage.centerXAnchor.constraint(equalTo: emptyStatisticPlaceholderView.centerXAnchor),
            emptyStatisticImage.heightAnchor.constraint(equalToConstant: 80),
            emptyStatisticImage.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setPlaceholderTextConstraints() {
        NSLayoutConstraint.activate([
            emptyStatisticText.centerXAnchor.constraint(equalTo: emptyStatisticImage.centerXAnchor),
            emptyStatisticText.topAnchor.constraint(equalTo: emptyStatisticImage.bottomAnchor, constant: 8)
        ])
    }
    
    
    private func setStatisticTableConstraints(){
        NSLayoutConstraint.activate([
            statisticTableView.topAnchor.constraint(equalTo: staticsticLabel.bottomAnchor, constant: 71),
            statisticTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            statisticTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -16)
        ])
    }
    
}

extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        statisticSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatisticCellView
        let cellTitle = statisticSections[indexPath.row]
        cell.statisticSectionName.text = cellTitle
        cell.statisticCountValue.text = {
            switch cellTitle {
            case bestPeriod: return String(viewModel.calculateBestPeriod())
            case perfectDays: return String(viewModel.calculatePerfectDays())
            case trackersCompleted: return String(viewModel.calculateTrackersCompleted())
            case averageValue:  return String(viewModel.calculateAverage())
            default: return "0"
            }
        }()
        cell.setGradientBackground(view: view)
        return cell
    }
    
    
}
