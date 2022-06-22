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
}

final class HomePresenter {
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    
    private weak var view: IHomeView?
    private var networkService: INetworkService
    private var router: IHomeRouter
    
    private let mainPublisher = CoinsPublisherManager()
    
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
                let filteredCoins = publishedCoins?
                    .filter({
                        let text = text.uppercased()
                        guard let symbol = $0.symbol?.uppercased() else { return false }
                        guard let name = $0.name?.uppercased() else { return false }
                        return (symbol.contains(text) || (name.contains(text)))
                    })
                self?.mainPublisher.newData = filteredCoins
            }
            if text == "" {
                self?.mainPublisher.newData = self?.coins
            }
        }
    }
}

private extension HomePresenter {
    func fetchData(view : IHomeView) {
        
        self.view = view
        
        if !self.mainPublisher.subscribers.contains(where: { $0 === view}) {
            self.mainPublisher.subscribe(view as! ISubscriber)
        }
        
        self.networkService.fetchCoinsList(urlsString: self.urlString) { [weak self] (result: Result<[CoinModel], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let coins):
                self.mainPublisher.newData = coins
                self.coins = coins
                view.sortByRank = {
                    if self.sortByRank {
                        self.mainPublisher.newData?.sort(by: { $0.marketCapRank ?? 0 > $1.marketCapRank ?? 0})
                        self.sortByRank.toggle()
                        return true
                        
                    } else {
                        self.mainPublisher.newData?.sort(by: { $0.marketCapRank ?? 0 < $1.marketCapRank ?? 0})
                        self.sortByRank.toggle()
                        return false
                    }
                }
                
                view.sortByPrice = {
                    if self.sortByPrice {
                        self.mainPublisher.newData?.sort(by: { $0.currentPrice ?? 0 > $1.currentPrice ?? 0})
                        self.sortByPrice.toggle()
                        return true
                    } else {
                        self.mainPublisher.newData?.sort(by: { $0.currentPrice ?? 0 < $1.currentPrice ?? 0})
                        self.sortByPrice.toggle()
                        return false
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
