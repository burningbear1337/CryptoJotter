//
//  HomeView_UITests.swift
//  CryptoJotter_UITests
//
//  Created by Miroslav Berezovsky on 29.06.2022.
//

import XCTest
@testable import CryptoJotter

class HomeView_UITests: XCTestCase {
    
    let app = XCUIApplication()
        
    func test_customSearchBar_exists() {
        
        app.launch()
        
        let navTitle = app.staticTexts["Live Prices"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 5))
        
        let textField = app.textFields["customSearchBarTextField"]
        XCTAssertTrue(textField.exists)
        
        textField.tap()
        textField.typeText("Btc")
        app.tables.cells.staticTexts["BTC"].tap()
        
        app.scrollViews.containing(.staticText, identifier:"Bitcoin").element.swipeDown()
    }
    
    
    func test_HomeViewElementsExistance() {
        
        app.launch()
        
        let yourPortfolio = app.tabBars["Tab Bar"].buttons["Your Portfolio"]
        XCTAssertTrue(yourPortfolio.waitForExistence(timeout: 5))
        
        let livePrices = app.tabBars["Tab Bar"].buttons["Live Prices"]
        XCTAssertTrue(livePrices.exists)
        
        let filterByRankButton = app.buttons["filterByRankButton"]
        XCTAssertTrue(filterByRankButton.exists)
        
        let filterByHoldingsButton = app.buttons["filterByHoldingsButton"]
        XCTAssertFalse(filterByHoldingsButton.exists)
        
        let reloadDataButton = app.buttons["reloadDataButton"]
        XCTAssertTrue(reloadDataButton.exists)
        
        let filterByPriceButton = app.buttons["filterByPriceButton"]
        XCTAssertTrue(filterByPriceButton.exists)
    }
    
}
