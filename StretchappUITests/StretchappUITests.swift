//
//  StretchappUITests.swift
//  StretchappUITests
//
//  Created by Alexander Kvamme on 04/05/2021.
//

import XCTest

extension UIView {
    public class func findByAccessibilityIdentifier(identifier: String) -> UIView? {

        guard let window = UIApplication.shared.keyWindow else {
            return nil
        }

        func findByID(view: UIView, someid: String) -> UIView? {
            if view.accessibilityIdentifier == someid { return view }
            for v in view.subviews {
                if let a = findByID(view: v, someid: someid) { return a }
            }
            return nil
        }

        return findByID(view: window, someid: identifier)
    }
}

class StretchappUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func fffftestDeleteWorkout() {
        let app = XCUIApplication()
        app.launchArguments.append("--UITEST")
        setupSnapshot(app)
        app.launch()
        let iconXButton = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 3).buttons["icon x"]
        iconXButton.tap()
    }

    func testMakeNewWorkoutWithTwoStretches() {
        var startNumber = 19

        func numStr() -> String {
            startNumber += 1
            return "\(startNumber)"
        }

        let app = XCUIApplication()
        app.launchArguments.append("--UITEST")
        setupSnapshot(app)
        app.launch()

        let app2 = app
        let newWorkoutButtonElement = app2.buttons["new-workout-button"]
        newWorkoutButtonElement.tap()
        app.textFields["Workout name"].tap()

        snapshot(numStr() + "new-workout-empty-input")

        // Enter "My new workout"
        let mKey = app2.keys["M"]
        mKey.tap()
        app2.keys["y"].tap()
        let mellomromKey = app2.keys["mellomrom"]
        mellomromKey.tap()
        let nKey = app2.keys["n"]
        nKey.tap()
        let eKey = app2.keys["e"]
        eKey.tap()
        let wKey = app2.keys["w"]
        wKey.tap()
        mellomromKey.tap()
        wKey.tap()
        let oKey = app2.keys["o"]
        oKey.tap()
        let rKey = app2.keys["r"]
        rKey.tap()
        let kKey = app2.keys["k"]
        kKey.tap()
        oKey.tap()
        let uKey = app2.keys["u"]
        uKey.tap()
        let tKey = app2.keys["t"]
        tKey.tap()
        let returnButton = app2.buttons["Return"]
        returnButton.tap()

        // Tap 'New workout' button
        app.buttons["new-stretch-button"].tap()

        // Enter 'Back bending'
        let bKey = app.keys["B"]
        bKey.tap()
        let aKey = app.keys["a"]
        aKey.tap()
        let cKey = app.keys["c"]
        cKey.tap()
        kKey.tap()
        app2.keys["mellomrom"].tap()
        let bKey2 = app2.keys["b"]
        bKey2.tap()
        eKey.tap()
        nKey.tap()
        let dKey = app2.keys["d"]
        dKey.tap()
        let iKey = app2.keys["i"]
        iKey.tap()
        nKey.tap()
        let gKey = app2.keys["g"]
        gKey.tap()

        snapshot(numStr() + "new-stretch-back-bending-input")

        // Swipe and press 'enter'
        app2.staticTexts["90 s"].tap()
        app2.buttons["Return"].tap()

        sleep(1) // TODO: Wait for button animation to finish in a better way

        // Make another stretch
        app.buttons["new-stretch-button"].tap()

        // Enter 'Forward folding'
        let fKey = app.keys["F"]
        fKey.tap()
        oKey.tap()
        rKey.tap()
        app2.keys["w"].tap()
        aKey.tap()
        rKey.tap()
        dKey.tap()
        mellomromKey.tap()
        let fKey2 = app2.keys["f"]
        fKey2.tap()
        oKey.tap()
        let lKey = app2.keys["l"]
        lKey.tap()
        dKey.tap()
        iKey.tap()
        nKey.tap()
        gKey.tap()
        app2.staticTexts["60 s"].tap()
        returnButton.tap()

        snapshot(numStr() + "new-workout-creation-with-two-stretches")

        app2.staticTexts["SAVE"].tap()
        assert(true)
    }

    func fffftestMakeSnapshots() throws {
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

