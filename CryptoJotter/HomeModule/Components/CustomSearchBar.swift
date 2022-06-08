//
//  CustomSearchBar.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 06.06.2022.
//

//import UIKit
//
//final class CustomSearchBar: UIView {
//
//    lazy var textField: UITextField = {
//        let textField = UITextField()
//        textField.translatesAutoresizingMaskIntoConstraints = true
//        textField.attributedPlaceholder = NSAttributedString(
//            string: "Type coin name...",
//            attributes: [
//                NSAttributedString.Key.font : AppFont.regular13.font as Any,
//                NSAttributedString.Key.foregroundColor: UIColor.theme.secondaryColor as Any
//            ]
//        )
//        textField.backgroundColor = UIColor.theme.secondaryBackgroundColor
//        textField.layer.cornerRadius = 55
//
//        let emptyView = UIView(frame: .init(x: .zero, y: .zero, width: 16, height: .zero))
//        textField.leftViewMode = .always
//        textField.leftView = emptyView
//        textField.rightViewMode = .always
//        textField.rightView = emptyView
//        return textField
//    }()
//
//    public var delegate: UITextViewDelegate? {
//        get {
//            return nil
//        }
//        set {
//            self.textField.delegate = newValue as? UITextFieldDelegate
//        }
//    }
//
//    init() {
//        super.init(frame: .zero)
//        self.setupLayout()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//private extension CustomSearchBar {
//    func setupLayout() {
//        self.textField.addSubview(self.textField)
//        self.textField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        self.textField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        self.textField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        self.textField.heightAnchor.constraint(equalToConstant: 55).isActive = true
//    }
//}
