//
//  AddCoinPresenter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 16.06.2022.
//

import Foundation

protocol IAddCoinPresenter: AnyObject {
    func sinkDataToView(view: IAddCoinView)
}

final class AddCoinPresenter {
    private var networkService: INetworkService
    private var coreDataUtility: ICoreDataUtility
    private var coins: [CoinModel] = []
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    private var addCoinPublisher = CoinsPublisher()
    init(networkService: INetworkService,coreDataUtility: ICoreDataUtility) {
        self.networkService = networkService
        self.coreDataUtility = coreDataUtility
    }
}

extension AddCoinPresenter: IAddCoinPresenter {
    func sinkDataToView(view: IAddCoinView) {
        self.fetchData(view: view)
        
        view.textFieldDataWorkflow = { [weak self] text in
            if text != "" {
                let publishedCoins = self?.coins
                let filteredCoins = publishedCoins?.filter({
                    let text = text.uppercased()
                    let symbol = $0.symbol.uppercased()
                    let name = $0.name.uppercased()
                    return (symbol.contains(text) || (name.contains(text)))
                })
                self?.addCoinPublisher.newData = filteredCoins
            }
            if text == "" {
                self?.addCoinPublisher.newData = self?.coins
            }
        }
                
        view.saveButtonTap = { coin, holdings in
            self.coreDataUtility.addCoinToPortfolio(coinName: coin.name, amount: holdings)
        }
        
        self.coreDataUtility.fetchPortfolio { coinItems in
            view.fecthDataFromCoreData(coinItems: coinItems)
        }
    }
}

private extension AddCoinPresenter {
    func fetchData(view: IAddCoinView) {
        self.addCoinPublisher.subscribe(view as! ISubscriber)
        self.networkService.fetchCoinsList(urlsString: urlString) { (result: Result<[CoinModel], Error>) in
            switch result {
            case .success(let coins):
                self.addCoinPublisher.newData = coins
                self.coins = coins
            case .failure(let error):
                print(error)
            }
        }
    }
}

