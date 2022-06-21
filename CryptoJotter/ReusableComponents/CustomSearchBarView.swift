//
//  CustomSearchBar.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 16.06.2022.
//

import UIKit

final class CustomSearchBarView: UIView, UITextFieldDelegate {
    
    lazy var textField = UITextField()
    
    init() {
        super.init(frame: .zero)
        
        self.setuptextField()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CustomSearchBarView {
    func setuptextField() {
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.backgroundColor = UIColor.theme.backgroundColor
        self.textField.layer.cornerRadius = 10
        let emptyView = UIView(frame: .init(x: .zero, y: .zero, width: 16, height: .zero))
        self.textField.placeholder = "Type in coin name or symbol..."
        self.textField.clearButtonMode = .always
        self.textField.leftViewMode = .always
        self.textField.leftView = emptyView
        self.textField.rightViewMode = .always
        self.textField.returnKeyType = .done
        self.textField.autocorrectionType = .no
        self.textField.layer.shadowColor = UIColor.theme.shadowColor?.cgColor
        self.textField.layer.shadowOpacity = 0.1
        self.textField.layer.shadowRadius = 8
        self.textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.textField.delegate = self
    }
    
    func setupLayout() {
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.textField)
        NSLayoutConstraint.activate([
            self.textField.topAnchor.constraint(equalTo: self.topAnchor),
            self.textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.textField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
