//
//  StretchappUITests.swift
//  StretchappUITests
//
//  Created by Alexander Kvamme on 04/05/2021.
//

import XCTest

class StretchappUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.


        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMakeSnapshots() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--UITEST")
        setupSnapshot(app)
        app.launch()

        snapshot("0Launch")
        XCUIApplication().collectionViews.staticTexts["2 stretches"].tap()

        let snapInterval: UInt32 = 1
        sleep(snapInterval)
        snapshot("1firststretch")
        sleep(snapInterval)
        snapshot("2firststretch")
        sleep(snapInterval)
        snapshot("3firststretch")
        sleep(snapInterval)
        snapshot("4firststretch")
        sleep(snapInterval)
        snapshot("5firststretch")
        sleep(snapInterval)
        snapshot("6firststretch")
        sleep(snapInterval)
        snapshot("7firststretch")
        sleep(snapInterval)
        snapshot("8firststretch")
        sleep(snapInterval)
        snapshot("9firststretch")
        sleep(snapInterval)
        snapshot("10firststretch")
//        sleep(snapInterval)
//        snapshot("11firststretch")
//        sleep(snapInterval)
//        snapshot("12firststretch")
//        sleep(snapInterval)
//        snapshot("13firststretch")
//        sleep(snapInterval)
//        snapshot("14firststretch")
//        sleep(snapInterval)
//        snapshot("15firststretch")
//        sleep(snapInterval)
//        snapshot("16firststretch")
//        sleep(snapInterval)
//        snapshot("17firststretch")
//        sleep(snapInterval)
//        snapshot("18firststretch")
//        sleep(snapInterval)
//        snapshot("19firststretch")
//        sleep(snapInterval)
//        snapshot("20firststretch")
//        sleep(snapInterval)
//        snapshot("21firststretch")
//        sleep(snapInterval)
//        snapshot("22firststretch")
//        sleep(snapInterval)
//        snapshot("23firststretch")
//        sleep(snapInterval)
//        snapshot("24firststretch")
//        sleep(snapInterval)
//        snapshot("25firststretch")
    }
}

