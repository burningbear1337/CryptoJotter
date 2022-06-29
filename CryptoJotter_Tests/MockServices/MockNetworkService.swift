//
//  MockNetworkService.swift
//  CryptoJotter_Tests
//
//  Created by Miroslav Berezovsky on 29.06.2022.
//

import Foundation
@testable import CryptoJotter

class MockNetworkService: INetworkService {
    
    var coins: [CoinModel]!
    
    init() {
        self.coins = [
            CoinModel(id: "Foo", symbol: "Foo", name: "Foo", image: "Foo", currentPrice: 1, marketCap: 1, marketCapRank: 1, fullyDilutedValuation: 1, totalVolume: 1, high24H: 1, low24H: 1, priceChange24H: 1, priceChangePercentage24H: 1, marketCapChange24H: 1, marketCapChangePercentage24H: 1, circulatingSupply: 1, totalSupply: 1, maxSupply: 1, ath: 1, athChangePercentage: 1, athDate: "Foo", atl: 1, atlChangePercentage: 1, atlDate: "Foo", lastUpdated: "Foo", priceChangePercentage24HInCurrency: 1)
        ]
    }
    
    func fetchCoinsList<CoinModel>(urlsString: String, completion: @escaping (Result<[CoinModel], Error>) -> ()) where CoinModel : Decodable, CoinModel : Encodable {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(.success(self.coins as! [CoinModel]))
        }
    }
    
    func fetchCoinData<CoinModel>(urlsString: String?, completion: @escaping (Result<CoinModel?, Error>) -> ()) where CoinModel : Decodable, CoinModel : Encodable {
    }
}
