//
//  OnboardViewController.swift
//  Tracker
//
//  Created by Fedor on 12.08.2024.
//

import Foundation
import UIKit


final class OnboardViewController: UIViewController{
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var onboardLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.numberOfLines = 3
        lable.font = UIFont(name: "SFProDisplay-Bold", size: 32)
        lable.text = "Отслеживайте только то, что хотите"
        lable.textAlignment = .center
        return lable
    }()
    
    init(image: UIImage, onboardText: String) {
        super.init(nibName: nil, bundle: nil)
        self.imageView.image = image
        self.onboardLable.text = onboardText
        
        view.addSubview(imageView)
        view.addSubview(onboardLable)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            onboardLable.topAnchor.constraint(equalTo: view.centerYAnchor),
            onboardLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onboardLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  16),
            onboardLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
