//
//  TrackerCollectioCleeView.swift
//  Tracker
//
//  Created by Fedor on 14.06.2024.
//

import Foundation
import UIKit

protocol TrackerCollectionViewCellProtocol: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
    func getAllRecords() -> [TrackerRecord]
    func isTrackerCompletedToday(id: UUID) -> Bool
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    var count = 0
    var delegate: TrackerCollectionViewCellProtocol?
    var tracker: Tracker?
    var trackerId: UUID?
    var completedDays: Int = 0
    var indexPath: IndexPath?
    var isCompletedToday: Bool = false
    var isCompletedBefore: Bool = false
    var metrica: Metrica?
    
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
        emojiView.backgroundColor = .trackerWhite
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
    
    let pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = Asset.Images.pin.image
        imageView.image = image
        imageView.tintColor = .trackerWhite
        return imageView
    }()
    
    let trackerNameLable: UILabel = {
        let trackerNameLable = UILabel()
        trackerNameLable.translatesAutoresizingMaskIntoConstraints = false
        trackerNameLable.text = "Бегать по утрам"
        trackerNameLable.font = UIFont(name: "SFProDisplay-Medium", size: 12)
        trackerNameLable.numberOfLines = 2
        trackerNameLable.textColor = .trackerWhite
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
        let buttonImage = Asset.Images.trackerPlus.image
        dayMarkButton.setImage(buttonImage, for: .normal)
        dayMarkButton.tintColor = .applicationBackgroundColor
        dayMarkButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return dayMarkButton
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstrains()
        traitCollectionDidChange(.current)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        dayMarkLable.textColor = isDarkMode ? .trackerWhite : .trackerBlack
    }
    
    func configure(with model: TrackerCellModel) {
        let tracker = model.tracker
        let selctedDate = model.currentDate
        self.isCompletedToday = model.isCompletedToday
        self.delegate = model.delegate
        self.isCompletedBefore = model.isCompletedBefore
        self.trackerId = tracker.trackerId
        self.completedDays = model.completedDays
        self.indexPath = model.indexPath
        self.metrica = model.metrica
        
        pinImageView.isHidden =  model.isPined ? false : true
        
        let color = tracker.color
        trackerView.backgroundColor = color
        dayMarkButton.backgroundColor = color
        
        trackerNameLable.text = tracker.name
        emoji.text = tracker.emoji
        
        if isCompletedToday {
            trackerDone()
        } else {
            trackerUndone()
        }
        
        if let selectedDate = selctedDate {
            dayMarkButton.isEnabled = selectedDate > Date() ? false : true
        }
    }
    
    @objc func buttonTapped(){
//        print("Записи до нажатия на кнопку \(String(describing: delegate?.getAllRecords()))")
        if let metrica = metrica {
            metrica.report(event: Event.click, screen: Screen.main, item: Item.completeTracker)
        }
        guard let delegate = delegate else { return }
        if isCompletedToday {
            UIView.animate(withDuration: 0.2) {
                guard let trackerId = self.trackerId, let indexPath = self.indexPath else { return }
                delegate.uncompleteTracker(id: trackerId, at: indexPath)
//                print("Удаление записи \(String(describing: delegate.getAllRecords()))")
                self.completedDays -= 1
                self.trackerUndone()
            }
        }else {
            UIView.animate(withDuration: 0.2) {
                guard let trackerId = self.trackerId, let indexPath = self.indexPath else { return }
                delegate.completeTracker(id: trackerId, at: indexPath)
//                print("Добавение записи записи \(String(describing: delegate.getAllRecords()))")
                self.completedDays += 1
                self.trackerDone()
            }
        }
        
        self.isCompletedToday = delegate.isTrackerCompletedToday(id: self.trackerId ?? UUID())
//        print (self.isCompletedToday)
    }
    
    func trackerDone() {
        let buttonImage = Asset.Images.trackerDone.image
        self.dayMarkButton.layer.opacity = 0.7
        self.dayMarkButton.setImage(buttonImage, for: .normal)
        let dayText = L10n.numberOfDays(self.completedDays)
        self.dayMarkLable.text = dayText
    }
    
    func trackerUndone() {
        let buttonImage = Asset.Images.trackerPlus.image
        self.dayMarkButton.layer.opacity = 1
        self.dayMarkButton.setImage(buttonImage, for: .normal)
        let dayText = L10n.numberOfDays(self.completedDays)
        self.dayMarkLable.text = dayText
    }
    
    func setSelectedView() -> UIView {
        return trackerView
    }
    
    func addSubviews(){
        self.addSubview(cardView)
        cardView.addSubview(trackerView)
        trackerView.addSubview(emojiView)
        trackerView.addSubview(emoji)
        trackerView.addSubview(pinImageView)
        trackerView.addSubview(trackerNameLable)
        cardView.addSubview(dayMarkLable)
        self.addSubview(dayMarkButton)
    }
    
    func setConstrains(){
        setCardViewConstrains()
        setTrackerViewConstrains()
        setEmojiViewConstrains()
        setEmojiConstrains()
        setPinCnstraints()
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
    
    func setPinCnstraints() {
        NSLayoutConstraint.activate([
            pinImageView.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            pinImageView.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -4),
            pinImageView.heightAnchor.constraint(equalToConstant: 24),
            pinImageView.widthAnchor.constraint(equalToConstant: 24)
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
