//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Andrew Williamson on 5/31/22.
//

import XCTest
@testable import DisneyMobileApp

class Tests_iOS: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUnserializeComic() throws {
        var comic: SerializedCharacter?
        let data = Comic_Preview.exampleBlob.data(using: .utf8)!
        comic = try JSONDecoder().decode(SerializedCharacter.self, from: data)
        XCTAssertTrue(comic != nil)
    }

    func testTryInvalidAuth() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let tabBar = app.tabBars.firstMatch
        let akField = app.textFields["akField"]
        akField.tap()
        akField.typeText("potato man stan")
        let pkField = app.secureTextFields["pkField"]
        pkField.tap()
        pkField.typeText("never gonna give you the code\n")
        sleep(1)
        let tcButton = app.buttons["tcButton"]
        tcButton.tap()
        sleep(1)
        let comicsTab = tabBar.buttons["Comics List"]
        comicsTab.tap()
        let noKeysMessage = app.staticTexts["noKeysMessage"]
        let doesErrorExist = noKeysMessage.waitForExistence(timeout: 3.0)
        XCTAssertTrue(doesErrorExist)
    }
}
    

