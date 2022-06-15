//
//  MainViewCell.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//

import UIKit

final class MainViewCell: UITableViewCell {
        
    private lazy var coinIndex: UILabel = {
        let label = UILabel()
        label.font = AppFont.regular13.font
        label.textColor = UIColor.theme.secondaryColor
        label.textAlignment = .center
        return label
    }()
    
    private lazy var coinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
        
    private lazy var coinName: UILabel = {
        let label = UILabel()
        label.font = AppFont.semibold17.font
        label.textColor = UIColor.theme.accentColor
        return label
    }()
    
    private lazy var coinPrice: UILabel = {
        let label = UILabel()
        label.font = AppFont.semibold15.font
        label.textColor = UIColor.theme.accentColor
        return label
    }()
    
    private lazy var coinPriceChange24H: UILabel = {
        let label = UILabel()
        label.font = AppFont.regular13.font
        label.textColor = UIColor.theme.secondaryColor
        return label
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainViewCell {
    func injectData(coin: CoinModel, index: Int) {
        self.coinIndex.text = coin.marketCapRank?.converToStringWith0Decimals()
        
        let coinImageService = CoinImageService(coin: coin)
        coinImageService.setCoinImage { image in
            DispatchQueue.main.async {
                self.coinImage.image = image
            }
        }
        
        self.coinName.text = coin.symbol.uppercased()
        self.coinPrice.text = "$\(coin.currentPrice.convertToStringWith2Decimals())"
        self.coinPriceChange24H.text = "\(coin.priceChangePercentage24H?.convertToStringWith2Decimals() ?? "N/A")%"
        
        self.coinPriceChange24H.textColor = setColor(data: coin)
    }
}

private extension MainViewCell {
    func setupLayout() {
        self.backgroundColor = UIColor.theme.backgroundColor
        self.selectionStyle = .none
        self.setupCoinIndex()
        self.setupCoinImage()
        self.setupCoinName()
        self.setupCoinPrice()
        self.setupCoinPriceChange24H()
    }
    
    func setupCoinIndex() {
        self.contentView.addSubview(self.coinIndex)
        self.coinIndex.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.coinIndex.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.coinIndex.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func setupCoinImage() {
        self.contentView.addSubview(self.coinImage)
        self.coinImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.coinImage.heightAnchor.constraint(equalToConstant: 35),
            self.coinImage.widthAnchor.constraint(equalToConstant: 35),
            self.coinImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.coinImage.leadingAnchor.constraint(equalTo: self.coinIndex.trailingAnchor, constant: 10),
        ])
    }
    
    func setupCoinName() {
        self.contentView.addSubview(self.coinName)
        self.coinName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.coinName.leadingAnchor.constraint(equalTo: self.coinImage.trailingAnchor,constant: 10),
            self.coinName.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func setupCoinPrice() {
        self.contentView.addSubview(self.coinPrice)
        self.coinPrice.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.coinPrice.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.coinPrice.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
        ])
    }
    
    func setupCoinPriceChange24H() {
        self.contentView.addSubview(self.coinPriceChange24H)
        self.coinPriceChange24H.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.coinPriceChange24H.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.coinPriceChange24H.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        ])
    }
        
    func setColor(data: CoinModel) -> UIColor {
        guard let priceChange24H = data.priceChange24H else { return UIColor.clear}
        if priceChange24H > 0 {
            return UIColor.theme.greenColor ?? UIColor.clear
        } else {
            return UIColor.theme.redColor ?? UIColor.clear
        }
    }
}
