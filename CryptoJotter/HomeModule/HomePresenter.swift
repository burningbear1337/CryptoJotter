//
//  MainPresenter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//

import Foundation
import UIKit

protocol IHomePresenter: AnyObject {
    func sinkDataToView(view: IHomeView, vc: UIViewController)
    var triggerLoadingView: ((Bool) -> ())? { get set }
}

final class HomePresenter {
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    
    private weak var view: IHomeView?
    private var networkService: INetworkService
    private var router: IHomeRouter
    var triggerLoadingView: ((Bool) -> ())?
    
    private let mainPublisher = CoinsPublisher()
    
    private var sortByRank: Bool = true
    private var sortByPrice: Bool = true
    
    private var coins: [CoinModel] = []
    
    init(networkService: INetworkService, router: IHomeRouter) {
        self.networkService = networkService
        self.router = router
    }
}

extension HomePresenter: IHomePresenter {
    func sinkDataToView(view: IHomeView, vc: UIViewController) {
        self.view = view
        
        self.fetchData(view: view)
        
        view.reloadData = {
            self.fetchData(view: view)
        }
        
        view.tapOnCell = { [weak self] coinModel in
            self?.router.routeToDetails(vc, coin: coinModel)
        }
        
        view.textFieldDataWorkflow = { [weak self] text in
            if text != "" {
                let publishedCoins = self?.coins
                let filteredCoins = publishedCoins?.filter({
                    let text = text.uppercased()
                    let symbol = $0.symbol.uppercased()
                    let name = $0.name.uppercased()
                    return (symbol.contains(text) || (name.contains(text)))
                })
                self?.mainPublisher.newData = filteredCoins
            }
        }
    }
}

private extension HomePresenter {
    func fetchData(view : IHomeView) {
        self.mainPublisher.subscribe(view as! IMainSubscriber)
        self.networkService.fetchCoinsList(urlsString: self.urlString) { [weak self] (result: Result<[CoinModel], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let coins):
                self.mainPublisher.newData = coins
                self.coins = coins
                self.triggerLoadingView?(true)
                view.sortByRank = {
                    
                    let sortedCoins = (self.sortByRank == true ?
                                       self.sortCoins(sort: .rankRevers, coins: self.mainPublisher.newData ?? []) :
                                        self.sortCoins(sort: .rank, coins: self.mainPublisher.newData ?? []))
                    self.mainPublisher.newData = sortedCoins
                    self.sortByRank.toggle()
                }
                
                view.sortByPrice = {
                    let sortedCoins = (self.sortByPrice == true ?
                                       self.sortCoins(sort: .priceRevers, coins: self.mainPublisher.newData ?? []) :
                                        self.sortCoins(sort: .price, coins: self.mainPublisher.newData ?? []))
                    self.mainPublisher.newData = sortedCoins
                    self.sortByPrice.toggle()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    enum SortByOption {
        case rank, rankRevers, price, priceRevers
    }
    
    private func sortCoins(sort: SortByOption, coins: [CoinModel]) -> [CoinModel] {
        var sortedCoins = coins
        switch sort {
        case .rank:
            sortedCoins.sort(by: {$0.marketCapRank ?? 0 < $1.marketCapRank ?? 0})
            return sortedCoins
        case .rankRevers:
            sortedCoins.sort(by: {$0.marketCapRank ?? 0 > $1.marketCapRank ?? 0})
            return sortedCoins
        case .price:
            sortedCoins.sort(by: {$0.currentPrice > $1.currentPrice})
            return sortedCoins
        case .priceRevers:
            sortedCoins.sort(by: {$0.currentPrice < $1.currentPrice})
            return sortedCoins
        }
    }
}
