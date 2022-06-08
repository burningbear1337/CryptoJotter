//
//  DetailsView.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import UIKit

protocol IDetailsView: AnyObject {
    func setCoins(coin: CoinModel?)
    func setCoinsDetailsData(coinDetails: CoinDetailsModel?)
}

final class CustomDetailsView: UIView {
    
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private var coin: CoinModel?
    private var coinDetails: CoinDetailsModel?
    
    private lazy var coinNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.theme.greenColor
        label.font = AppFont.semibold17.font
        label.textAlignment = .center
        return label
    }()
    
    private lazy var coinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
        
    private lazy var low24H = StatisticsElement()
    private lazy var high24H = StatisticsElement()
    
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
    func setCoinsDetailsData(coinDetails: CoinDetailsModel?) {
        print(coinDetails?.marketCapRank)
        self.coinDetails = coinDetails
    }
    
    func setCoins(coin: CoinModel?) {
        self.coin = coin
        self.imageLoader(url: coin?.image)
        setupElementsData()
    }
}

private extension CustomDetailsView {
    
    func setupElementsData() {
        self.coinNameLabel.text = self.coin?.name
        self.imageLoader(url: self.coin?.image)
        self.low24H.injectData(title: "Lowest 24H", price: self.coin?.low24H)
        self.high24H.injectData(title: "Heightest 24H", price: self.coin?.high24H)
        
    }
    
    func setupLayout() {
        self.setupScrollView()
        self.setupCoinNameLabel()
        self.setupCoinImage()
        self.setupLowest24H()
        self.setupHugh24H()
    }
    
    func setupScrollView() {
        self.addSubview(self.scrollView)
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
        
    func setupCoinNameLabel() {
        self.scrollView.addSubview(self.coinNameLabel)
        NSLayoutConstraint.activate([
            self.coinNameLabel.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 20),
            self.coinNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.coinNameLabel.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
        ])
    }
    
    func setupCoinImage() {
        self.scrollView.addSubview(self.coinImage)
        NSLayoutConstraint.activate([
            self.coinImage.centerYAnchor.constraint(equalTo: self.coinNameLabel.centerYAnchor),
            self.coinImage.trailingAnchor.constraint(equalTo: self.coinNameLabel.leadingAnchor, constant: -10),
            self.coinImage.heightAnchor.constraint(equalToConstant: 24),
            self.coinImage.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    func setupLowest24H() {
        self.scrollView.addSubview(self.low24H)
        self.low24H.translatesAutoresizingMaskIntoConstraints = false
        self.low24H.layer.borderWidth = 1
        self.low24H.layer.borderColor = UIColor.theme.secondaryColor?.cgColor
        self.low24H.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            self.low24H.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.low24H.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2 - 20),
            self.low24H.topAnchor.constraint(equalTo: self.coinImage.bottomAnchor, constant: 20)
        ])
    }
    
    func setupHugh24H() {
        self.scrollView.addSubview(self.high24H)
        self.high24H.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.high24H.topAnchor.constraint(equalTo: self.low24H.topAnchor),
            self.high24H.leadingAnchor.constraint(equalTo: self.low24H.trailingAnchor),
            self.high24H.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2 - 20),
        ])
    }
    
    
    func imageLoader(url: String?) {
        guard let url = url else { return }
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
}

