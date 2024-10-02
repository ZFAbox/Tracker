//
//  TrackerTypeSelectViewController.swift
//  Tracker
//
//  Created by Fedor on 18.06.2024.
//

import Foundation
import UIKit

final class TrackerTypeSelectViewController: UIViewController {
    
    weak var viewModel: TrackerViewModelProtocol?
    weak var delegate: TrackerViewController?
    
    private var buttonsView: UIView = {
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        return buttonsView
    }()
    
    private lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        let trackerTypeSelectTitle = NSLocalizedString("trackerTypeSelectTitle", comment: "Tracker type select screen title")
        titleLable.text = trackerTypeSelectTitle
        titleLable.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        return titleLable
    }()
    
    private lazy var habbitButton: UIButton = {
        let habbitButton = UIButton(type: .system)
        habbitButton.translatesAutoresizingMaskIntoConstraints = false
        habbitButton.layer.cornerRadius = 16
        let habbitButtonText = NSLocalizedString("habbitButtonText", comment: "")
        habbitButton.setTitle(habbitButtonText, for: .normal)
        habbitButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        habbitButton.backgroundColor = .trackerBlack
        habbitButton.tintColor = .trackerWhite
        habbitButton.addTarget(self, action: #selector(habbitButtonTapped), for: .touchUpInside)
        return habbitButton
    }()

    private lazy var notRegularButton: UIButton = {
        let notRegularButton = UIButton(type: .system)
        notRegularButton.translatesAutoresizingMaskIntoConstraints = false
        notRegularButton.layer.cornerRadius = 16
        let notRegularButtonText = NSLocalizedString("notRegularButtonText", comment: "")
        notRegularButton.setTitle(notRegularButtonText, for: .normal)
        notRegularButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        notRegularButton.backgroundColor = .trackerBlack
        notRegularButton.tintColor = .trackerWhite
        notRegularButton.addTarget(self, action: #selector(notRegularButtonTapped), for: .touchUpInside)
        return notRegularButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        addSubviews()
        setConstrains()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateTrackerCollectionView()
    }
    
    @objc func habbitButtonTapped(){
        //TODO: - move to habbit screen
        let viewController = RegularTrackerCreateViewController(regular: true, trackerTypeSelectViewController: self)
        viewController.delegate = viewModel
        viewController.modalPresentationStyle = .popover
        self.present(viewController, animated: true)
    }
    
    @objc func notRegularButtonTapped(){
        //TODO: - move to notRegular screen
        let viewController = NotRegularTrackerCreateViewController(regular: false, trackerTypeSelectViewController: self)
        viewController.delegate = viewModel
        viewController.modalPresentationStyle = .popover
        self.present(viewController, animated: true)
    }
    
    private func addSubviews(){
        view.addSubview(titleLable)
        view.addSubview(buttonsView)
        buttonsView.addSubview(habbitButton)
        buttonsView.addSubview(notRegularButton)
    }
    
    private func setConstrains(){
        setButtonViewConstarins()
        setHabbitButtonConstrains()
        setNotRegularButtonConstrains()
        setTitleConstrains()
    }
    
    private func setButtonViewConstarins(){
        NSLayoutConstraint.activate([
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: 136)
        ])
    }
    
    private func setHabbitButtonConstrains(){
        NSLayoutConstraint.activate([
            habbitButton.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            habbitButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            habbitButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor),
            habbitButton.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func setNotRegularButtonConstrains(){
        NSLayoutConstraint.activate([
            notRegularButton.topAnchor.constraint(equalTo: habbitButton.bottomAnchor, constant: 16),
            notRegularButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            notRegularButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor),
            notRegularButton.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func setTitleConstrains(){
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLable.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
}
