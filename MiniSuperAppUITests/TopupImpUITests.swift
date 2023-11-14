//
//  TopupImpUITests.swift
//  MiniSuperAppUITests
//
//  Created by 천지운 on 11/14/23.
//

import XCTest
import Swifter

final class TopupImpUITests: XCTestCase {
    
    private var app: XCUIApplication!
    private var server: HttpServer!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        server = HttpServer()
        
        app = XCUIApplication()
        app.launch()
    }
    
    func testTopupSuccess() throws {
        // given
        let cardOnFileJsonPath = try TestUtil.path(for: "cardOnFile.json", in: type(of: self))
        server["/cards"] = shareFile(cardOnFileJsonPath)
        
        let topupResponse = try TestUtil.path(for: "topupSuccessResponse.json", in: type(of: self))
        server["/topup"] = shareFile(topupResponse)
        
        // when
        try server.start()
        app.launch()
        
        // then
        app.tabBars.buttons["superpay_home_tab_bar_item"].tap()
        app.buttons["superpay_dashboard_topup_button"].tap()
        
        let textField = app.textFields["topup_enteramount_textfield"]
        textField.tap()
        textField.typeText("10000")
        
        app.buttons["topup_enteramount_confirm_button"].tap()
        
        let balanceText = app.staticTexts.element(matching: .any, identifier: "superpay_dashboard_balance_label").label
        XCTAssertEqual(balanceText, "10,000")
    }
    
}
