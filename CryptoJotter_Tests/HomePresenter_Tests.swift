//
//  HomePresenter_Tests.swift
//  CryptoJotter_Tests
//
//  Created by Miroslav Berezovsky on 29.06.2022.
//

import XCTest
@testable import CryptoJotter

class HomePresenter_Tests: XCTestCase {
    
    private var homePresenter: IHomePresenter!
    private var networkService: INetworkService!
    private var homeRouter: IHomeRouter!
    
    private var coins = [CoinModel]()
    
    override func setUpWithError() throws {
        self.homeRouter = HomeRouter()
    }

    override func tearDownWithError() throws {
        self.homePresenter = nil
    }

    func test_HomePresenter_sinkDataToView_success() {
        
        let expectation = XCTestExpectation(description: "Loading data within 5 sec.")
                        
        self.networkService = MockNetworkService()
        self.homeRouter = HomeRouter()
        self.homePresenter = HomePresenter(networkService: self.networkService, router: self.homeRouter)
        
        self.networkService.fetchCoinsList(urlsString: "") { (result: Result<[CoinModel], Error>) in
            switch result {
            case .success(let returnedCoins):
                self.coins = returnedCoins
                expectation.fulfill()
            case .failure(_):
                break
            }
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(self.coins.count, 0)
    }
}


