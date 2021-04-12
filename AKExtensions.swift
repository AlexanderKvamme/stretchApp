//
//  AKExtensions.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 20/03/2021.
//

import UIKit
import SwiftUI

var TESTING = true


public class ShadowView: UIView {

    // MARK: - Properties

    var offset: CGSize = CGSize(width: 0, height: 0)
    var radius: CGFloat = 30
    var opacity: Float = 0.2
    var color: UIColor = UIColor.black
    var cornerRadius: Float = 0.0
    var isCircle: Bool = false
    var showOnlyOutsideBounds: Bool = false

    // MARK: - Layout

    override public func layoutSubviews() {
        super.layoutSubviews()

        var cornerRadius = self.cornerRadius
        if isCircle {
            cornerRadius = Float(min(frame.height, frame.width) / 2.0)
        }

        if showOnlyOutsideBounds {
            let maskLayer = CAShapeLayer()
            let path = CGMutablePath()
            path.addPath(UIBezierPath(roundedRect: bounds.inset(by: UIEdgeInsets.zero), cornerRadius: CGFloat(cornerRadius)).cgPath)
            path.addPath(UIBezierPath(roundedRect: bounds.inset(by: UIEdgeInsets(top: -offset.height - radius*2, left: -offset.width - radius*2, bottom: -offset.height - radius*2, right: -offset.width - radius*2)), cornerRadius: CGFloat(cornerRadius)).cgPath)
            maskLayer.backgroundColor = UIColor.black.cgColor
            maskLayer.path = path;
            maskLayer.fillRule = .evenOdd
            self.layer.mask = maskLayer
        } else {
            self.layer.masksToBounds = false
        }

        self.layer.shadowOffset = self.offset
        self.layer.shadowRadius = self.radius
        self.layer.shadowOpacity = self.opacity
        self.layer.shadowColor = self.color.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(cornerRadius)).cgPath
    }
}


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
        case animationPlaceholder = "logo-animation-placeholder"
    }

    static let x = UIImage(named: CustomIcon.x.rawValue)
    static let back = UIImage(named: CustomIcon.back.rawValue)
    static let pillPlus = UIImage(named: CustomIcon.pillPlus.rawValue)
    static let animationPlaceholder = UIImage(named: CustomIcon.animationPlaceholder.rawValue)
}

// UIDevice

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let screenFrame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
