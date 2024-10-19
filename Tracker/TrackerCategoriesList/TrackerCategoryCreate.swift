//
//  TrackerCategoryCreate.swift
//  Tracker
//
//  Created by Fedor on 16.08.2024.
//

import UIKit

protocol UpdateCategoryListProtocol {
    
    func updateCategoryList(with category: String)
    func updateCategoryTableList()
    func editCategory(with category: String, indexPath: IndexPath)
}

final class TrackerCategoryCreate: UIViewController {
    
    private var categoryName: String = ""
    private var delegate: UpdateCategoryListProtocol
    
    init(delegate: UpdateCategoryListProtocol) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        let categoryCreateTitleText = NSLocalizedString("categoryCreateTitleText", comment: "")
        titleLable.text = categoryCreateTitleText
        titleLable.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        return titleLable
    }()
    
    private lazy var layerTextFieldView: UIView = {
        let layerTextFieldView = UIView()
        layerTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        layerTextFieldView.backgroundColor = .trackerBackgroundOpacityGray
        layerTextFieldView.layer.cornerRadius = 16
        return layerTextFieldView
    }()
    
    private lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.rgbColors(red: 174, green: 175, blue: 180, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 17)!
        ]
        let categoryCreateTextFieldPlaceholderText = NSLocalizedString("categoryCreateTextFieldPlaceholderText", comment: "")
        textField.attributedPlaceholder = NSAttributedString(string: categoryCreateTextFieldPlaceholderText, attributes:attributes)
        textField.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        textField.backgroundColor = .none
        textField.addTarget(self, action: #selector(inputText(_ :)), for: .allEditingEvents)
        textField.delegate = self
        return textField
    }()
    
    private lazy var createCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        let confirmCreateButtonText = NSLocalizedString("confirmCreateButtonText", comment: "")
        button.setTitle(confirmCreateButtonText, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        button.backgroundColor = .trackerDarkGray
        button.tintColor = .trackerWhite
        button.addTarget(self, action: #selector(createCategory), for: .touchUpInside)
        return button
    }()
    
    @objc func inputText(_ sender: UITextField){
        let text = sender.text ?? ""
        categoryName = text
        UIView.animate(withDuration: 0.3) {
            self.createCategoryButton.isEnabled = !text.isEmpty
            self.createCategoryButton.backgroundColor = text.isEmpty ? .trackerDarkGray : .trackerBlack
        }
    }

    @objc func createCategory(){
        delegate.updateCategoryList(with: categoryName)
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        hideKeyboardWhenTappedAround()
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews(){
        view.addSubview(titleLable)
        view.addSubview(createCategoryButton)
        view.addSubview(layerTextFieldView)
        view.addSubview(categoryNameTextField)
    }
    
    private func setConstraints(){
        setTitleConstraints()
        setCreateButtonConstraints()
        setLayerTextFieldViewConstrains()
        setCategoryNameConstraints()
    }
    
    private func setTitleConstraints(){
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLable.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    private func setLayerTextFieldViewConstrains(){
        NSLayoutConstraint.activate([
            layerTextFieldView.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            layerTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            layerTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            layerTextFieldView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setCategoryNameConstraints(){
        NSLayoutConstraint.activate([
            categoryNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            categoryNameTextField.leadingAnchor.constraint(equalTo: layerTextFieldView.leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setCreateButtonConstraints(){
        NSLayoutConstraint.activate([
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}


extension TrackerCategoryCreate: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        categoryName = text
        return true
    }
}

