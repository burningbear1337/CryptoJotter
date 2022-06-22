//
//  DetailsView.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import UIKit

protocol IDetailsView: AnyObject {
    func setupCoins(coin: CoinModel?)
    func setCoinsDetailsData(coinDetails: CoinDetailsModel?)
    var sortByCoinName: (()->())? { get set }
    var sortByCoinPrice: (()->())? { get set }
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
    private lazy var priceChange24H = StatisticsElement()
    private lazy var priceChange24HPercantage = StatisticsElement()
    private lazy var currentPrice = StatisticsElement()
    private lazy var marketCapRank = StatisticsElement()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.accentColor
        label.font = AppFont.regular13.font
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private lazy var linkButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = AppFont.semibold15.font
        button.titleLabel?.tintColor = UIColor.theme.accentColor
        return button
    }()
    
    var sortByCoinName: (()->())?
    var sortByCoinPrice: (()->())?
    
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
        self.showHomepageLink(coinDetails)
        self.setupHomePageButton()
        self.coinDetails = coinDetails
    }
    
    func setupCoins(coin: CoinModel?) {
        self.coin = coin
        self.setupImage(coin)
        self.setupElementsData()
    }
}

private extension CustomDetailsView {
    
    func showHomepageLink(_ coinDetails: CoinDetailsModel?) {
        DispatchQueue.main.async {
            self.descriptionLabel.text = coinDetails?.description?.en?.removeHTMLSymbols
            if coinDetails?.links?.homepage == nil {
                self.linkButton.setTitle("", for: .normal)
            } else {
                self.linkButton.setTitle("Home website", for: .normal)
            }
        }
    }
    
    func setupHomePageButton() {
        DispatchQueue.main.async {
            self.linkButton.addTarget(self, action: #selector(self.openWebSite), for: .touchUpInside)
        }
    }
    
    func setupImage(_ coin: CoinModel?) {
        guard let coin = coin else { return }
        let coinImageService = CoinImageService(coin: coin)
        coinImageService.setCoinImage { [weak self] image in
            self?.coinImage.image = image
        }
    }
        
    func setupElementsData() {
        self.coinNameLabel.text = self.coin?.name
        
        let prefix = ((self.coin?.priceChangePercentage24H ?? 0) > 0) ? "▲ " : "▼ "
        let isGrowing = ((self.coin?.priceChangePercentage24H ?? 0) > 0) ? UIColor.theme.greenColor : UIColor.theme.redColor
        
        self.low24H.injectData(
            title: "Lowest 24H",
            price: self.coin?.low24H?.convertToStringWith2Decimals(),
            suffix: "$")
        
        self.high24H.injectData(
            title: "Heightest 24H",
            price: self.coin?.high24H?.convertToStringWith2Decimals(),
            suffix: "$")
        
        self.priceChange24H.injectData(
            title: "Price Change 24H",
            price: prefix + (self.coin?.priceChange24H?.convertToStringWith2Decimals() ?? ""),
            suffix: "$",
            isGrowing: isGrowing)
        
        self.priceChange24HPercantage.injectData(
            title: "% Change 24H",
            price: prefix + (self.coin?.priceChangePercentage24H?.convertToStringWith2Decimals() ?? ""),
            suffix: "%",
            isGrowing: isGrowing)
        
        self.currentPrice.injectData(
            title: "Current Price",
            price: self.coin?.currentPrice?.convertToStringWith2Decimals(),
            suffix: "$")
        
        self.marketCapRank.injectData(
            title: "Market Rank",
            price: self.coin?.marketCapRank?.converToStringWith0Decimals(),
            suffix: "#")
    }
    
    func setupLayout() {
        self.setupScrollView()
        self.setupCoinNameLabel()
        self.setupCoinImage()
        self.setupLowest24H()
        self.setupHigh24H()
        self.setup24HPriceChange()
        self.setup24HPriceChangePercantage()
        self.setupCurrentPrice()
        self.setupMarketCapRank()
        self.setupDescription()
        self.setupLinkButton()
    }
    
    func setupScrollView() {
        self.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.alwaysBounceVertical = true
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
        NSLayoutConstraint.activate([
            self.low24H.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.low24H.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2 - 20),
            self.low24H.topAnchor.constraint(equalTo: self.coinImage.bottomAnchor, constant: 20)
        ])
    }
    
    func setupHigh24H() {
        self.scrollView.addSubview(self.high24H)
        self.high24H.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.high24H.topAnchor.constraint(equalTo: self.low24H.topAnchor),
            self.high24H.leadingAnchor.constraint(equalTo: self.low24H.trailingAnchor),
            self.high24H.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2 - 20),
        ])
    }
    
    func setup24HPriceChange() {
        self.scrollView.addSubview(self.priceChange24H)
        self.priceChange24H.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.priceChange24H.topAnchor.constraint(equalTo: self.low24H.bottomAnchor, constant: 70),
            self.priceChange24H.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.priceChange24H.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2 - 20),
        ])
    }
    
    func setup24HPriceChangePercantage() {
        self.scrollView.addSubview(self.priceChange24HPercantage)
        self.priceChange24HPercantage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.priceChange24HPercantage.topAnchor.constraint(equalTo: self.priceChange24H.topAnchor),
            self.priceChange24HPercantage.leadingAnchor.constraint(equalTo: self.priceChange24H.trailingAnchor),
            self.priceChange24HPercantage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2 - 20)
        ])
    }
    
    func setupCurrentPrice() {
        self.scrollView.addSubview(self.currentPrice)
        self.currentPrice.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.currentPrice.topAnchor.constraint(equalTo: self.priceChange24H.bottomAnchor, constant: 70),
            self.currentPrice.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.currentPrice.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2 - 20),
        ])
    }
    
    func setupMarketCapRank() {
        self.scrollView.addSubview(self.marketCapRank)
        self.marketCapRank.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.marketCapRank.topAnchor.constraint(equalTo: self.currentPrice.topAnchor),
            self.marketCapRank.leadingAnchor.constraint(equalTo: self.currentPrice.trailingAnchor),
            self.marketCapRank.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2 - 20)
        ])
    }
    
    func setupDescription() {
        self.scrollView.addSubview(self.descriptionLabel)
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.currentPrice.bottomAnchor, constant: 70),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
    }
    
    func setupLinkButton() {
        self.scrollView.addSubview(self.linkButton)
        self.linkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.linkButton.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 30),
            self.linkButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.linkButton.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func openWebSite() {
        guard let url = URL(string: coinDetails?.links?.homepage?.first?.replacingOccurrences(of: "http", with: "https") ?? "") else { return }
        UIApplication.shared.open(url)
    }
}

