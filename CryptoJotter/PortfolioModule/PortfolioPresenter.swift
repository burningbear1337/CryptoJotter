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
    
    private var increaseByRank: Bool = true
    private var increaseByPrice: Bool = true
    private var increaseByHoldings: Bool = true

    
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
                self?.portfolioPublisher.newData = self?.portfolioPublisher.newData?.filter({
                    let text = text.uppercased()
                    guard let symbol = $0.symbol?.uppercased() else { return false }
                    guard let name = $0.name?.uppercased() else { return false }
                    return (symbol.contains(text) || name.contains(text))
                })
            }
            if text == "" {
                self?.portfolioPublisher.newData = self?.coins
            }
        }
        
        view.coinItemHoldings = { coin in
            if let index = self.coinItems.firstIndex(where: { $0.symbol == coin.symbol }) {
                return (self.coinItems[index].amount * (coin.currentPrice ?? 0.00)).convertToStringWith2Decimals()
            } else {
                return nil
            }
        }
        
        view.deleteCoinFromPortfolio = { coin in
            if let index = self.coinItems.firstIndex(where: { $0.symbol == coin.symbol}) {
                self.coreDataUtility.deleteCoinFromPortfolio(coin: self.coinItems[index])
                self.fetchData(view: view)
            }
        }
        
        view.sortByRank = {
            self.increaseByRank == true ?
            self.portfolioPublisher.newData?.sort(by: { $0.marketCapRank ?? 0 > $1.marketCapRank ?? 0 }) :
            self.portfolioPublisher.newData?.sort(by: { $0.marketCapRank ?? 0 < $1.marketCapRank ?? 0 })
            self.increaseByRank.toggle()
        }
        
        view.sortByPrice = {
            self.increaseByPrice == true ?
            self.portfolioPublisher.newData?.sort(by: { $0.currentPrice ?? 0 > $1.currentPrice ?? 0 }) :
            self.portfolioPublisher.newData?.sort(by: { $0.currentPrice ?? 0 < $1.currentPrice ?? 0 })
            self.increaseByPrice.toggle()
        }
        
        view.sortByHoldings = {
            self.increaseByHoldings.toggle()
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
        }
    }
    
    func converterFromItemToModel(coinItems: [CoinItem]) -> [CoinModel]
    {
        coinItems.map { coinItem in
            CoinModel(id: nil, symbol: coinItem.symbol ?? "", name: coinItem.name ?? "", image: coinItem.image ?? "", currentPrice: coinItem.currentPrice, marketCap: nil, marketCapRank: coinItem.rank, fullyDilutedValuation: nil, totalVolume: nil, high24H: nil, low24H: nil, priceChange24H: coinItem.priceChange24H, priceChangePercentage24H: coinItem.priceChange24H, marketCapChange24H: nil, marketCapChangePercentage24H: nil, circulatingSupply: nil, totalSupply: nil, maxSupply: nil, ath: nil, athChangePercentage: nil, athDate: nil, atl: nil, atlChangePercentage: nil, atlDate: nil, lastUpdated: nil, priceChangePercentage24HInCurrency: nil)
        }
    }
}
