//
//  TrackerCollectioCleeView.swift
//  Tracker
//
//  Created by Fedor on 14.06.2024.
//

import Foundation
import UIKit

class TrackerCollectionViewCell: UICollectionViewCell {
    
    let cardView: UIView = {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    let trackerView: UIView = {
        let trackerView = UIView()
        trackerView.translatesAutoresizingMaskIntoConstraints = false
        trackerView.layer.cornerRadius = 16
        return trackerView
    }()
    
    let emojiView: UIView = {
        let emojiView = UIView()
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.layer.cornerRadius = emojiView.frame.height / 2
        return emojiView
    }()
    
    let emoji: UILabel = {
        let emoji = UILabel()
        emoji.translatesAutoresizingMaskIntoConstraints = false
        emoji.font = UIFont(name: "SFProDisplay-Medium", size: 12)
        return emoji
    }()
    
    let trackerName: UILabel = {
        let trackerName = UILabel()
        trackerName.translatesAutoresizingMaskIntoConstraints = false
        trackerName.font = UIFont(name: "SFProDisplay-Medium", size: 12)
        trackerName.tintColor = .ypWhite
        return trackerName
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstrains()
    }
    
    func addSubviews(){
        self.addSubview(cardView)
    }
    
    func setConstrains(){
        setCardViewConstrains()
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
            emojiView.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12)
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
            trackerName.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            trackerName.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            trackerName.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -12),
            trackerName.topAnchor.constraint(equalTo: emojiView.topAnchor, constant: 12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
