//
//  StatisticsElement.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 08.06.2022.
//

import UIKit

final class StatisticsElement: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.theme.secondaryColor
        label.font = AppFont.regular13.font
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.theme.accentColor
        label.font =  AppFont.semibold15.font
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func injectData(title: String?, price: String?, suffix: String, isGrowing: UIColor? = nil) {
        self.titleLabel.text = title
        guard let price = price else { return }
        self.infoLabel.text = "\(String(describing: price)) "+suffix
        self.infoLabel.textColor = isGrowing ?? UIColor.theme.accentColor
        guard let price = Double(price) else { return }
        self.infoLabel.textColor = price > 0 ? UIColor.theme.accentColor : UIColor.theme.redColor
    }
}

private extension StatisticsElement {
    
    func setupLayout() {
        self.setupTitleLabel()
        self.setupInfoLabel()
    }
    
    func setupTitleLabel() {
        
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        ])
    }
    
    func setupInfoLabel() {
        
        self.addSubview(self.infoLabel)
        
        NSLayoutConstraint.activate([
            self.infoLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        ])
    }
}
