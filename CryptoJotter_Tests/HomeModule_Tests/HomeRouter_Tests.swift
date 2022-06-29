//
//  HomeRouter_Tests.swift
//  CryptoJotter_Tests
//
//  Created by Miroslav Berezovsky on 29.06.2022.
//

import XCTest
@testable import CryptoJotter

class HomeRouter_Tests: XCTestCase {
    
    private var homeRouter: IHomeRouter!
    private var viewController = DetailsModuleBuilder().build()
    private var coin = CoinModel(id: "Foo", symbol: "Foo", name: "Foo", image: "Foo", currentPrice: 1, marketCap: 1, marketCapRank: 1, fullyDilutedValuation: 1, totalVolume: 1, high24H: 1, low24H: 1, priceChange24H: 1, priceChangePercentage24H: 1, marketCapChange24H: 1, marketCapChangePercentage24H: 1, circulatingSupply: 1, totalSupply: 1, maxSupply: 1, ath: 1, athChangePercentage: 1, athDate: "Foo", atl: 1, atlChangePercentage: 1, atlDate: "Foo", lastUpdated: "Foo", priceChangePercentage24HInCurrency: 1)

    override func setUpWithError() throws {
        self.homeRouter = HomeRouter()
    }

    override func tearDownWithError() throws {
        self.homeRouter = nil
    }
    
    func test_Router_nextVcIsDetails() {
        self.homeRouter.routeToDetails(self.viewController, coin: self.coin)
        XCTAssertNotNil(self.viewController)
    }
}


