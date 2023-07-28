import UIKit

extension UIColor {
    static let background = UIColor(hex: "#F4F4F4")
    static let primaryContrast = TESTING ? UIColor.red : UIColor.black
    static let card = UIColor(hex: "#EDE9E5")
}

struct Style {
    static let cornerRadius: CGFloat = 24
    static let buttonHeight: CGFloat = 80
}
