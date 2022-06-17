//
//  CustomCollectionViewCell.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 17.06.2022.
//

import UIKit

final class CustomCollectionViewCell: UICollectionViewCell {
    
    private let coinImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var coinTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.theme.accentColor
        label.adjustsFontSizeToFitWidth = true
        label.font = AppFont.semibold15.font
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func injectData(coin: CoinModel) {
        let coinImageService = CoinImageService(coin: coin)
        coinImageService.setCoinImage { image in
            DispatchQueue.main.async {
                self.coinImage.image = image
                self.coinTitle.text = coin.name
            }
        }
    }
}

private extension CustomCollectionViewCell {
    func setupLayout() {
        self.coinImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.coinImage)
        NSLayoutConstraint.activate([
            self.coinImage.heightAnchor.constraint(equalToConstant: 36),
            self.coinImage.widthAnchor.constraint(equalToConstant: 36),
            self.coinImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -12),
            self.coinImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])

        
        self.coinTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.coinTitle)
        NSLayoutConstraint.activate([
            self.coinTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            self.coinTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.coinTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
