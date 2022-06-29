//
//  NetworkService_Tests.swift
//  CryptoJotter_Tests
//
//  Created by Miroslav Berezovsky on 29.06.2022.
//

import XCTest
@testable import CryptoJotter

class NetworkService_Tests: XCTestCase {
    
    private var networkService: INetworkService?

    override func setUpWithError() throws {
        self.networkService = NetworkService()
    }

    override func tearDownWithError() throws {
        self.networkService = nil
    }
    
    func test_fetchCoinsList_success() {
        
        var coins = [CoinModel]()
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
                
        let expectation = XCTestExpectation(description: "Load data within 5 seconds.")
        
        self.networkService?.fetchCoinsList(urlsString: urlString, completion: { (result: Result<[CoinModel], Error>) in
            switch result {
            case .success(let returnedCoins):
                coins = returnedCoins
                expectation.fulfill()
            case .failure(_):
                break
            }
        })
        
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(coins.count, 0)
    }
    
    func test_fetchCoinsList_failure_wrongURL() {
        
        var someError: Error?
        
        let urlString = "https://api.coingecko.com/pi/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
        
        let expectation = XCTestExpectation(description: "NO data loaded within 5 seconds.")
        
        self.networkService?.fetchCoinsList(urlsString: urlString, completion: { (result: Result<[CoinModel], Error>) in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error)
                someError = error
                expectation.fulfill()
            }
        })
        
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(someError)
    }
}
