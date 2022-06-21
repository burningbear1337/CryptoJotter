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
    private var coinItems: [CoinItem] = []
    private var coinItemsMapped: [CoinModel] = []
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    private var addCoinPublisher = CoinsPublisherManager()
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
                    guard let symbol = $0.symbol?.uppercased() else { return false }
                    guard let name = $0.name?.uppercased() else { return false }
                    return (symbol.contains(text) || (name.contains(text)))
                })
                self?.addCoinPublisher.newData = filteredCoins
            }
            if text == "" {
                self?.addCoinPublisher.newData = self?.coinItemsMapped
            }
        }
        
        view.saveButtonTap = { [weak self] coin, holdings in
            guard let self = self else { return }
            if let index = self.coinItemsMapped.firstIndex(where: {
                $0.symbol == coin.symbol
            }) {
                let coin = self.coinItems[index]
                if holdings > 0 {
                    self.coreDataUtility.updateCoinInPortfolio(coinItem: coin, amount: holdings)
                } else if holdings < 0 {
                    return
                }
                else {
                    self.coreDataUtility.deleteCoinFromPortfolio(coin: coin)
                }
                self.fetchData(view: view)
            } else {
                self.coreDataUtility.addCoinToPortfolio(coin: coin, amount: holdings)
                self.fetchData(view: view)
            }
        }
        
        view.clickedOnCoin = { [ weak self] coin in
            if let index = self?.coinItemsMapped.firstIndex(where: {
                $0.symbol == coin.symbol
            }) {
                let coin = self?.coinItems[index]
                return coin?.amount.convertToStringWith2Decimals() ?? "Try: 3.1"
            } else {
                return "Try: 3.1"
            }
        }
    }
}

private extension AddCoinPresenter {
    func fetchData(view: IAddCoinView) {
        
        self.addCoinPublisher.subscribe(view as! ISubscriber)
        
        self.networkService.fetchCoinsList(urlsString: urlString) { [weak self] (result: Result<[CoinModel], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let coins):
                self.coins = coins
            case .failure(let error):
                print(error)
            }
        }
        
        self.coreDataUtility.fetchPortfolio { [weak self] coinItems in
            self?.coinItems = coinItems
            guard let data = self?.converterFromItemToModel(coinItems: coinItems) else { return }
            self?.coinItemsMapped = data
            self?.addCoinPublisher.newData = data
        }
    }
    
    func converterFromItemToModel(coinItems: [CoinItem]) -> [CoinModel]
    {
        coinItems.map { coinItem in
            CoinModel(id: nil, symbol: coinItem.symbol ?? "", name: coinItem.symbol ?? "", image: coinItem.image ?? "", currentPrice: coinItem.currentPrice, marketCap: nil, marketCapRank: coinItem.rank, fullyDilutedValuation: nil, totalVolume: nil, high24H: nil, low24H: nil, priceChange24H: coinItem.priceChange24H, priceChangePercentage24H: coinItem.priceChange24H, marketCapChange24H: nil, marketCapChangePercentage24H: nil, circulatingSupply: nil, totalSupply: nil, maxSupply: nil, ath: nil, athChangePercentage: nil, athDate: nil, atl: nil, atlChangePercentage: nil, atlDate: nil, lastUpdated: nil, priceChangePercentage24HInCurrency: nil)
        }
    }
}

