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

    func test_HomePresenter_sinkDataToView_FetchingData_success() {
        
        let expectation = XCTestExpectation(description: "Loading data within 5 sec.")
                        
        self.networkService = MockNetworkService(coins: nil)
        self.homeRouter = HomeRouter()
        self.homePresenter = HomePresenter(networkService: self.networkService, router: self.homeRouter)
        
        self.networkService.fetchCoinsList(urlsString: "") { (result: Result<[CoinModel], Error>) in
            switch result {
            case .success(let returnedCoins):
                self.coins = returnedCoins
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(self.coins.count, 0)
    }
    
    func test_HomePresenter_sinkDataToView_FetchingData_failure() {
        
        let expectation = XCTestExpectation(description: "Can't load within 5 sec")
        
        self.networkService = MockNetworkService(coins: [])
        self.homeRouter = HomeRouter()
        self.homePresenter = HomePresenter(networkService: self.networkService, router: self.homeRouter)
        
        self.networkService.fetchCoinsList(urlsString: "") { (result: Result<[CoinModel], Error>) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                print(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(self.coins.count, 0)
    }
}


