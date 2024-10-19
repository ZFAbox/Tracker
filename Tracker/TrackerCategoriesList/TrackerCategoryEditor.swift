//
//  TrackerCategoryEditor.swift
//  Tracker
//
//  Created by Федор Завьялов on 19.08.2024.
//

import UIKit

final class TrackerCategoryEditor: UIViewController {
    
    private var categoryName: String
    private var delegate: UpdateCategoryListProtocol
    private var indexPath: IndexPath
    
    init(delegate: UpdateCategoryListProtocol, indexPath: IndexPath, categoryName: String) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.categoryName = categoryName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        let categoryEditTitleText = NSLocalizedString("categoryEditTitleText", comment: "")
        titleLable.text = categoryEditTitleText
        titleLable.textColor = .titleTextColor
        titleLable.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        return titleLable
    }()
    
    private lazy var layerTextFieldView: UIView = {
        let layerTextFieldView = UIView()
        layerTextFieldView.backgroundColor = .textFiledColor
        layerTextFieldView.layer.cornerRadius = 16
        return layerTextFieldView
    }()
    
    private lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.rgbColors(red: 174, green: 175, blue: 180, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 17)!
        ]
        let categoryEditTextFieldPlaceholderText = NSLocalizedString("categoryEditTextFieldPlaceholderText", comment: "")
        textField.attributedPlaceholder = NSAttributedString(string: categoryEditTextFieldPlaceholderText, attributes:attributes)
        textField.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        textField.backgroundColor = .none
        textField.text = categoryName
        textField.textColor = .generalTextColor
        textField.addTarget(self, action: #selector(inputText(_ :)), for: .allEditingEvents)
        textField.delegate = self
        return textField
    }()
    
    private lazy var createCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 16
        let confirmEditButtonText = NSLocalizedString("confirmEditButtonText", comment: "")
        button.setTitle( confirmEditButtonText, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        button.backgroundColor = .activeButtonColor
        button.tintColor = .activeButtonTextColor
        button.addTarget(self, action: #selector(createCategory), for: .touchUpInside)
        return button
    }()
    
    @objc func inputText(_ sender: UITextField){
        let text = sender.text ?? ""
        categoryName = text
        UIView.animate(withDuration: 0.3) {
            self.createCategoryButton.isUserInteractionEnabled = !text.isEmpty
            self.createCategoryButton.backgroundColor = text.isEmpty ? .disableButtonColor : .activeButtonColor
            self.createCategoryButton.tintColor = text.isEmpty ? .disableButtonTextColor : .activeButtonTextColor
        }
    }

    @objc func createCategory(){
        delegate.editCategory(with: categoryName, indexPath: indexPath)
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .applicationBackgroundColor
        hideKeyboardWhenTappedAround()
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews(){
        [titleLable, createCategoryButton, layerTextFieldView, categoryNameTextField].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
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


extension TrackerCategoryEditor: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        categoryName = text
        return true
    }
}
