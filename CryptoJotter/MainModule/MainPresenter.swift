//
//  MainPresenter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//

import Foundation
import UIKit

protocol IMainPresenter: AnyObject {
    func sinkDataToView(view: IMainView, vc: UIViewController)
}

final class MainPresenter {
    private weak var view: IMainView?
    private var networkService: INetworkService
    private var router: IMainRouter
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    private var sortByRank: Bool = true
    private var sortByPrice: Bool = true
    
    init(networkService: INetworkService, router: IMainRouter) {
        self.networkService = networkService
        self.router = router
    }
}

extension MainPresenter: IMainPresenter {
    func sinkDataToView(view: IMainView, vc: UIViewController) {
        self.view = view
        self.networkService.fetchCoinsList(urlsString: urlString) { (result: Result<[CoinModel], Error>) in
            switch result {
            case .success(let coins):
                let sortedCoins = self.sortCoins(sort: .rank, coins: coins)
                view.setupCoinsList(coins: sortedCoins)
                
                view.sortByRank = {
                    let result = (self.sortByRank == true ? self.sortCoins(sort: .rankRevers, coins: coins) :  self.sortCoins(sort: .rank, coins: coins))
                    view.setupCoinsList(coins: result)
                    self.sortByRank.toggle()
                }
                
                view.sortByPrice = {
                    let result = (self.sortByPrice == true ? self.sortCoins(sort: .priceRevers, coins: coins) :  self.sortCoins(sort: .price, coins: coins))
                    view.setupCoinsList(coins: result)
                    self.sortByPrice.toggle()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        view.tapOnCell = { [weak self] coinModel in
            self?.router.routeToDetails(vc, coin: coinModel)
        }
        
    }
}

private extension MainPresenter {
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
