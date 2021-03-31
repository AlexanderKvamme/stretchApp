//
//  AKExtensions.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 20/03/2021.
//

import UIKit
import SwiftUI

var TESTING = false

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}

// MARK: - Fonts

func printFonts() {
    for family in UIFont.familyNames {

        let sName: String = family as String
        print("family: \(sName)")

        for name in UIFont.fontNames(forFamilyName: sName) {
            print("-- \(name as String)")
        }
    }
}

extension UIFont {
    static var defaultAlpha: CGFloat = 0.8
}

enum DINWeights: String {
    case black      = "DINRoundPro-Black"
    case bold       = "DINRoundPro-Bold"
    case regular    = "DINRoundPro"
    case medium     = "DINRoundPro-Medium"
    case light      = "DINRoundPro-Light"
}

extension UIFont {
    static func round(_ weight: DINWeights, _ size: CGFloat) -> UIFont {
        UIFont(name: weight.rawValue, size: size)!
    }

    static func fulbo(_ size: CGFloat) -> UIFont {
        UIFont(name: "Fulbo-Argenta", size: size)!
    }
}

extension Font {
    static func round(_ weight: DINWeights, _ size: CGFloat) -> Font {
        Font.custom(weight.rawValue, size: size)
    }

    static func gilroy(_ size: CGFloat) -> Font {
        Font.custom("Fulbo-Argenta", size: size)
    }
}

// UIImageView

extension UIImage {

    enum CustomIcon: String {
        case x = "icon-x"
        case back = "icon-back"
        case pillPlus = "icon-plus-pill"
    }

    static let x = UIImage(named: CustomIcon.x.rawValue)
    static let back = UIImage(named: CustomIcon.back.rawValue)
    static let pillPlus = UIImage(named: CustomIcon.pillPlus.rawValue)
}

// UIDevice

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let screenFrame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
