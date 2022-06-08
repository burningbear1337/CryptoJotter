//
//  MainViewCell.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//

import UIKit

final class MainViewCell: UITableViewCell {
    
    static let id = MainViewCell.description()
    
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
    func injectData(data: CoinModel, index: Int) {
        self.coinIndex.text = "\(index+1)"
        
        self.imageLoader(url: data.image)
        
        self.coinName.text = data.symbol.uppercased()
        
        self.coinPrice.text = "$\(doubleConverterTo6(data.currentPrice))"
        
        self.coinPriceChange24H.text = "\(doubleConverterTo2(data.priceChangePercentage24H))%"
        
        self.coinPriceChange24H.textColor = setColor(data: data)
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
    
    func imageLoader(url: String) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.downloadTask(with: request) { url, response, error in
            if let error = error {
                print(error)
            }
            guard let url = url else { return }
            
            let data = try? Data(contentsOf: url)
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                let imageView = UIImageView(image: UIImage(data: data))
                self.coinImage.image = imageView.image
            }
        }.resume()
    }
    
    func doubleConverterTo2(_ num: Double?) -> Double {
        guard let num = num else { return 0.0}
        return Double(round(100*num)/100)
    }
    
    func doubleConverterTo6(_ num: Double?) -> Double {
        guard let num = num else { return 0.0}
        return Double(round(1_000_000*num)/1_000_000)
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
