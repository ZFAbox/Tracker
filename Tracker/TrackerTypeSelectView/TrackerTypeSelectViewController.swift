//
//  TrackerTypeSelectViewController.swift
//  Tracker
//
//  Created by Fedor on 18.06.2024.
//

import Foundation
import UIKit

final class TrackerTypeSelectViewController: UIViewController {
    
    
    private var buttonsView: UIView = {
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        return buttonsView
    }()
    
    private lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.text = "Создание трекера"
        titleLable.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        return titleLable
    }()
    
    private lazy var habbitButton: UIButton = {
        let habbitButton = UIButton(type: .system)
        habbitButton.translatesAutoresizingMaskIntoConstraints = false
        habbitButton.layer.cornerRadius = 16
        habbitButton.setTitle("Привычка", for: .normal)
        habbitButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        habbitButton.backgroundColor = .trackerBlack
        habbitButton.tintColor = .ypWhite
        habbitButton.addTarget(self, action: #selector(habbitButtonTapped), for: .touchUpInside)
        return habbitButton
    }()
    
    
    private lazy var notRegularButton: UIButton = {
        let notRegularButton = UIButton(type: .system)
        notRegularButton.translatesAutoresizingMaskIntoConstraints = false
        notRegularButton.layer.cornerRadius = 16
        notRegularButton.setTitle("Нерегулярное событие", for: .normal)
        notRegularButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        notRegularButton.backgroundColor = .trackerBlack
        notRegularButton.tintColor = .ypWhite
        notRegularButton.addTarget(self, action: #selector(notRegularButtonTapped), for: .touchUpInside)
        return notRegularButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
        setConstrains()
    }
    
    @objc func habbitButtonTapped(){
        //TODO: - move to habbit screen
        let viewController = HabbitCreateViewController()
        viewController.modalPresentationStyle = .popover
        self.present(viewController, animated: true)
    }
    
    @objc func notRegularButtonTapped(){
        //TODO: - move to notRegular screen
    }
    
    func addSubviews(){
        view.addSubview(titleLable)
        view.addSubview(buttonsView)
        buttonsView.addSubview(habbitButton)
        buttonsView.addSubview(notRegularButton)
    }
    
    func setConstrains(){
        setButtonViewConstarins()
        setHabbitButtonConstrains()
        setNotRegularButtonConstrains()
        setTitleConstrains()
    }
    
    func setButtonViewConstarins(){
        NSLayoutConstraint.activate([
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: 136)
        ])
    }
    
    func setHabbitButtonConstrains(){
        NSLayoutConstraint.activate([
            habbitButton.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            habbitButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            habbitButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor),
            habbitButton.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    func setNotRegularButtonConstrains(){
        NSLayoutConstraint.activate([
            notRegularButton.topAnchor.constraint(equalTo: habbitButton.bottomAnchor, constant: 16),
            notRegularButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            notRegularButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor),
            notRegularButton.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    func setTitleConstrains(){
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLable.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
}
