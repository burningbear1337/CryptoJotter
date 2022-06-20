//
//  PortfolioPresenter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 08.06.2022.
//

import UIKit

protocol IPortfolioPresenter: AnyObject {
    func sinkDataToView(view: IPortfolioView)
    func addNewCoin(vc: UIViewController)
}

final class PortfolioPresenter {
    
    private weak var view: IPortfolioView?
    private var router: IPortfolioRouter
    private var coreDataUtility: ICoreDataUtility
    private var networkService: INetworkService
    var addNewCoin: (()->())?
    private let portfolioPublisher = CoinsPublisherManager()
    private var coins: [CoinModel] = []
    private var coinItems: [CoinItem] = []
    
    init(router: IPortfolioRouter, coreDataUtility: ICoreDataUtility, networkService: INetworkService) {
        self.router = router
        self.coreDataUtility = coreDataUtility
        self.networkService = networkService
    }
}

extension PortfolioPresenter: IPortfolioPresenter {
    
    func sinkDataToView(view: IPortfolioView) {
        
        self.fetchData(view: view)
        
        view.textFieldDataWorkflow = { [weak self] text in
            if text != "" {
                let publishedCoins = self?.coins
                let filteredCoins = publishedCoins?.filter({
                    let text = text.uppercased()
                    guard let symbol = $0.symbol?.uppercased() else { return false }
                    guard let name = $0.name?.uppercased() else { return false }
                    return (symbol.contains(text) || name.contains(text))
                })
                self?.portfolioPublisher.newData = filteredCoins
            }
            if text == "" {
                self?.portfolioPublisher.newData = self?.coins
            }
        }
        
        view.coinItemHoldings = { coin in
            if let index = self.coinItems.firstIndex(where: { $0.symbol == coin.symbol }) {
                return "$" + (self.coinItems[index].amount * (coin.currentPrice ?? 0.00)).convertToStringWith2Decimals()
            } else {
                return nil
            }
        }
    }
    
    func addNewCoin(vc: UIViewController) {
        self.router.presentVC(vc: vc)
    }
}

private extension PortfolioPresenter {
    
    func fetchData(view: IPortfolioView) {
        self.view = view
        if !self.portfolioPublisher.subscribers.contains(where: { $0 === view }) {
            self.portfolioPublisher.subscribe(view as! ISubscriber)
        }
        
        self.coreDataUtility.fetchPortfolio { [weak self] coinItems in
            self?.coinItems = coinItems
            guard let data = self?.converterFromItemToModel(coinItems: coinItems) else { return }
            
            self?.portfolioPublisher.newData = data
            self?.coins = data
            view.fetchCoins(coins: data)
        }
    }
    
    func converterFromItemToModel(coinItems: [CoinItem]) -> [CoinModel]
    {
        coinItems.map { coinItem in
            CoinModel(id: "1", symbol: coinItem.symbol ?? "", name: coinItem.symbol ?? "", image: coinItem.image ?? "", currentPrice: coinItem.currentPrice, marketCap: 1, marketCapRank: coinItem.rank, fullyDilutedValuation: 1, totalVolume: 1, high24H: 1, low24H: 1, priceChange24H: coinItem.priceChange24H, priceChangePercentage24H: coinItem.priceChange24H, marketCapChange24H: 1, marketCapChangePercentage24H: 1, circulatingSupply: 1, totalSupply: 1, maxSupply: 1, ath: 1, athChangePercentage: 1, athDate: "1", atl: 1, atlChangePercentage: 1, atlDate: "1", lastUpdated: "1", priceChangePercentage24HInCurrency: 1)
        }
    }
}
