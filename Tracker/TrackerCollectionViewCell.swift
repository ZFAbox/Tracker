//
//  TrackerCollectioCleeView.swift
//  Tracker
//
//  Created by Fedor on 14.06.2024.
//

import Foundation
import UIKit

class TrackerCollectionViewCell: UICollectionViewCell {
    
    var count = 0
    
    var delegate: TrackerViewController?
    
    var trackerId: UUID?
    
    var dates:[Date] = []
    
    let cardView: UIView = {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    let trackerView: UIView = {
        let trackerView = UIView()
        trackerView.translatesAutoresizingMaskIntoConstraints = false
        trackerView.layer.cornerRadius = 16
        trackerView.backgroundColor = .trackerGreen
        return trackerView
    }()
    
    let emojiView: UIView = {
        let emojiView = UIView()
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.layer.cornerRadius = 12
        emojiView.backgroundColor = .ypWhite
        emojiView.layer.opacity = 0.7
        return emojiView
    }()
    
    let emoji: UILabel = {
        let emoji = UILabel()
        emoji.translatesAutoresizingMaskIntoConstraints = false
        emoji.text = "😂"
        emoji.font = UIFont(name: "SFProDisplay-Medium", size: 12)
        return emoji
    }()
    
    let trackerNameLable: UILabel = {
        let trackerNameLable = UILabel()
        trackerNameLable.translatesAutoresizingMaskIntoConstraints = false
        trackerNameLable.text = "Бегать по утрам"
        trackerNameLable.font = UIFont(name: "SFProDisplay-Medium", size: 12)
        trackerNameLable.textColor = .ypWhite
        return trackerNameLable
    }()
    
    let dayMarkLable: UILabel = {
        let dayMarkLable = UILabel()
        dayMarkLable.translatesAutoresizingMaskIntoConstraints = false
        dayMarkLable.text = "0 дней"
        dayMarkLable.font = UIFont(name: "SFProDisplay-Medium", size: 12)
        dayMarkLable.textColor = .trackerBlack
        return dayMarkLable
    }()
    
    
    let dayMarkButton: UIButton = {
        let dayMarkButton = UIButton(type: .system)
        dayMarkButton.translatesAutoresizingMaskIntoConstraints = false
        dayMarkButton.backgroundColor = .trackerGreen
        dayMarkButton.layer.cornerRadius = 17
        let buttonImage = UIImage(named: "Tracker Plus")
        dayMarkButton.setImage(buttonImage, for: .normal)
        dayMarkButton.tintColor = .ypWhite
        dayMarkButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return dayMarkButton
    }()
    
    
    
    var isTrackerTapped: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstrains()
        
    }
    
    
    func isButtonStateOn() -> Bool {
        guard let delegate = self.delegate, let trackerId = self.trackerId, let date = delegate.currentDate else { return false }
        if delegate.completerTrackerId.contains(trackerId) {
            var records: [TrackerRecord] = []
            for trackerRecord in delegate.completedTrackers {
                if trackerRecord.tackerDate == date {
                    records.append(trackerRecord)
                }
            }
            if records.isEmpty {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    func trackerButtonState(){
        guard let delegate = self.delegate, let trackerId = self.trackerId else { return }
        var records: [TrackerRecord] = []
        isTrackerTapped = isButtonStateOn()
        if isTrackerTapped {
            for record in delegate.completedTrackers {
                if record.trackerId == trackerId {
                    records.append(record)
                }
            }
            let buttonImage = UIImage(named: "Tracker Done")
            self.dayMarkButton.layer.opacity = 0.7
            self.dayMarkButton.setImage(buttonImage, for: .normal)
            self.count = records.count
        } else {
            let buttonImage = UIImage(named: "Tracker Plus")
            self.dayMarkButton.layer.opacity = 1
            self.dayMarkButton.setImage(buttonImage, for: .normal)
            self.count = records.count
        }
    }

//        for tracker in delegate.complitedTrackers {
//            if tracker.trackerId == trackerId, tracker.tackerDates.contains(date) {
//                isTrackerTapped = true
//                let buttonImage = UIImage(named: "Tracker Done")
//                self.dayMarkButton.layer.opacity = 0.7
//                self.dayMarkButton.setImage(buttonImage, for: .normal)
//                self.count = tracker.tackerDates.count
//            } else {
//                isTrackerTapped = false
//                let buttonImage = UIImage(named: "Tracker Plus")
//                self.dayMarkButton.layer.opacity = 1
//                self.dayMarkButton.setImage(buttonImage, for: .normal)
//                self.count = tracker.tackerDates.count
//            }
//        }
    
    @objc func buttonTapped(){
        if !isTrackerTapped {
            UIView.animate(withDuration: 0.2, delay: 0) {
                guard let delegate = self.delegate, let trackerId = self.trackerId, let date = delegate.currentDate  else {return}
                self.dates.append(date)
                self.count = self.dates.count
                self.dayMarkLable.text = self.count.daysEnding()
                let buttonImage = UIImage(named: "Tracker Done")
                self.dayMarkButton.layer.opacity = 0.7
                self.dayMarkButton.setImage(buttonImage, for: .normal)
            }
           
        }else {
            UIView.animate(withDuration: 0.2, delay: 0) {
                self.dates.removeLast()
                self.count = self.dates.count
                self.dayMarkLable.text = self.count.daysEnding()
                let buttonImage = UIImage(named: "Tracker Plus")
                self.dayMarkButton.layer.opacity = 1
                self.dayMarkButton.setImage(buttonImage, for: .normal)
            }
        }
        isTrackerTapped = !isTrackerTapped
    }
    
    func addSubviews(){
        self.addSubview(cardView)
        cardView.addSubview(trackerView)
        trackerView.addSubview(emojiView)
        trackerView.addSubview(emoji)
        trackerView.addSubview(trackerNameLable)
        cardView.addSubview(dayMarkLable)
        self.addSubview(dayMarkButton)
    }
    
    func setConstrains(){
        setCardViewConstrains()
        setTrackerViewConstrains()
        setEmojiViewConstrains()
        setEmojiConstrains()
        setTrackerNameConstrains()
        setDayMarkLable()
        setDayMarkButton()
    }
    
    func setCardViewConstrains(){
        NSLayoutConstraint.activate([
            cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cardView.topAnchor.constraint(equalTo: self.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
    

    func setTrackerViewConstrains(){
        NSLayoutConstraint.activate([
        trackerView.topAnchor.constraint(equalTo: cardView.topAnchor),
        trackerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
        trackerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
        trackerView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func setEmojiViewConstrains(){
        NSLayoutConstraint.activate([
            emojiView.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func setEmojiConstrains(){
        NSLayoutConstraint.activate([
            emoji.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor)
        ])
    }
    
    func setTrackerNameConstrains(){
        NSLayoutConstraint.activate([
            trackerNameLable.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            trackerNameLable.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            trackerNameLable.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -12)
        ])
    }
    
    func setDayMarkLable(){
        NSLayoutConstraint.activate([
            dayMarkLable.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            dayMarkLable.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 16)])
    }
    
    func setDayMarkButton(){
        NSLayoutConstraint.activate([
            dayMarkButton.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            dayMarkButton.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 8),
            dayMarkButton.heightAnchor.constraint(equalToConstant: 34),
            dayMarkButton.widthAnchor.constraint(equalToConstant: 34)
        ])

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
