//
//  AddCoinModule_UITest.swift
//  CryptoJotter_UITests
//
//  Created by Miroslav Berezovsky on 29.06.2022.
//

import XCTest

class AddCoinModule_UITest: XCTestCase {
    
    private let app = XCUIApplication()
    
    func test_AddCoinView_UIElementsExistance() {
        
        app.launch()
        let yourPortfolio = app.tabBars["Tab Bar"].buttons["Your Portfolio"]
        XCTAssertTrue(yourPortfolio.waitForExistence(timeout: 5))
        yourPortfolio.tap()
        
        app.navigationBars["Your Portfolio"].buttons["Add to home screen"].tap()
        
        let searchBar = app.textFields["customSearchBarTextField"]
        XCTAssertTrue(searchBar.waitForExistence(timeout: 5))
        searchBar.tap()
        searchBar.typeText("btc")
        
        app.collectionViews/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Bitcoin").element/*[[".cells.containing(.staticText, identifier:\"Bitcoin\").element",".cells.containing(.image, identifier:\"\/Users\/miroslav\/Library\/Developer\/CoreSimulator\/Devices\/B308DC1E-44C6-4F63-B6C9-2FA50590DC6E\/data\/Containers\/Data\/Application\/02536203-520C-4C41-B1B4-29A01F15BAD7\/Library\/Caches\/CoinJotter_images\/bitcoin.png\").element"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        
        app.staticTexts["Current Price:"].tap()
        app.staticTexts["Your holdings:"].tap()
        app.staticTexts["Your deposit:"].tap()
        
        let coinsAmountTextField = app.textFields["coinsAmountTextField"]
        coinsAmountTextField.tap()
        coinsAmountTextField.typeText("\(Double.random(in: 0...1.00))")
        XCTAssertTrue(coinsAmountTextField.exists)
        
        app.buttons["Save"].tap()
        
        sleep(1)
        
        searchBar.tap()
        searchBar.typeText("eth")
        app.collectionViews.cells.containing(.staticText, identifier: "Ethereum").element.tap()
        coinsAmountTextField.tap()
        coinsAmountTextField.typeText("\(Double.random(in: 0...1.00))")
        XCTAssertTrue(coinsAmountTextField.exists)
        
        sleep(1)
        
        app.buttons["Save"].tap()
    }
}
