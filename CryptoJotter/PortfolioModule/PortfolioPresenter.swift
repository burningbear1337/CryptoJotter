//
//  PortfolioPresenter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 08.06.2022.
//

import UIKit

protocol IPortfolioPresenter: AnyObject {
    func sinkDataToView(view: IPortfolioView, vc: UIViewController)
    func addNewCoin(vc: UIViewController)
}

final class PortfolioPresenter {
    
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    
    private weak var view: IPortfolioView?
    private var router: IPortfolioRouter
    private var coreDataUtility: ICoreDataUtility
    private var networkService: INetworkService
    
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
    
    func sinkDataToView(view: IPortfolioView, vc: UIViewController) {
        
        self.fetchData(view: view)
        
        view.routeToDetails = { coin in
            self.router.routeToDetailsViewController(vc: vc, coin: coin)
        }
        
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
        
        view.coinItemHoldings = { [weak self] coin in
            guard let self = self else { return nil }
            if let index = self.coinItems.firstIndex(where: { $0.symbol == coin.symbol }) {
                return (self.coinItems[index].amount * (coin.currentPrice ?? 0.00)).convertToStringWith2Decimals()
            } else {
                return nil
            }
        }
        
        view.deleteCoinFromPortfolio = { [weak self] coin in
            guard let self = self else { return }
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
        
//        view.sortByHoldings = {
//            self.increaseByHoldings.toggle()
//        }
    }
    
    func addNewCoin(vc: UIViewController) {
        self.router.routeToAddCoinViewController(vc: vc)
    }
}

private extension PortfolioPresenter {
    
    func fetchData(view: IPortfolioView) {
        
        self.view = view
        
        if !self.portfolioPublisher.subscribers.contains(where: { $0 === view }) {
            self.portfolioPublisher.subscribe(view as! ISubscriber)
        }
        
        self.networkService.fetchCoinsList(urlsString: urlString) { (result: Result<[CoinModel], Error>) in
            switch result {
            case .success(let coins):
                self.coins = coins
                self.portfolioPublisher.newData = self.coins.filter({ coinModel in
                    self.coinItems.contains { coinItem in
                        coinItem.symbol == coinModel.symbol
                    }
                })
            case .failure(let error):
                print(error)
            }
        }
        
        self.coreDataUtility.fetchPortfolio { coinItems in
            self.coinItems = coinItems
        }
    }
}
 
