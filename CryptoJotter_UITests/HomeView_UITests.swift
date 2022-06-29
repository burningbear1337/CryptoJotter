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
        
        self.app.launch()
        
        let textField = self.app.textFields["Type in coin name or symbol..."]
        XCTAssertTrue(textField.waitForExistence(timeout: 5))
        
        textField.tap()
        textField.typeText("Btc")
    }
    
    func test_tapYourPortfolioButton_exists() {
        
        self.app.launch()
        
        let tabbarButton1 = self.app.tabBars["Tab Bar"].buttons["Live Prices"]
        let tabbarButton2 = self.app.tabBars["Tab Bar"].buttons["Your Portfolio"]
        
        XCTAssertTrue(tabbarButton1.waitForExistence(timeout: 5))
        XCTAssertTrue(tabbarButton2.waitForExistence(timeout: 5))
    }
    
    func test_filtersPlateView() {
        
    }
    
}
