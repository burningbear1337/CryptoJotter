//
//  CryptoJotter_UITestsLaunchTests.swift
//  CryptoJotter_UITests
//
//  Created by Miroslav Berezovsky on 29.06.2022.
//

import XCTest

class CryptoJotter_UITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

//    func testLaunch() throws {
//        let app = XCUIApplication()
//        app.launch()
//
//        let attachment = XCTAttachment(screenshot: app.screenshot())
//        attachment.name = "Launch Screen"
//        attachment.lifetime = .keepAlways
//        add(attachment)
//    }
}
