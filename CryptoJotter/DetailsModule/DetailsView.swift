//
//  DetailsView.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import UIKit

protocol IDetailsView: AnyObject {
    func setData(data: CoinModel?)
}

final class CustomDetailsView: UIView {
    
    private var data: CoinModel?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.theme.greenColor
        label.font = AppFont.semibold15.font
        label.textAlignment = .center
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        setupElementsData()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomDetailsView: IDetailsView {
    func setData(data: CoinModel?) {
        self.data = data
        setupElementsData()
    }
}

private extension CustomDetailsView {
    
    func setupElementsData() {
        self.label.text = self.data?.name
    }
    
    func setupLayout() {
        self.setupLabel()
        self.setupIconImage()
    }
    
    func setupLabel() {
        self.addSubview(self.label)
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.label.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.label.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
    
    func setupIconImage() {
        self.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.heightAnchor.constraint(equalToConstant: 24),
            self.imageView.widthAnchor.constraint(equalToConstant: 24),
            self.imageView.centerYAnchor.constraint(equalTo: self.label.centerYAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.label.leadingAnchor, constant: -10),
        ])
    }
}

