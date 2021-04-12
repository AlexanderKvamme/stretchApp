//
//   TextFieldWithCustomCaret.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 12/04/2021.
//

import UIKit

class TextFieldWithCustomCaret: UITextField {

    init(placeholder: String) {
        super.init(frame: .zero)
        
        attributedPlaceholder = makePlaceholder(placeholder)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        let size = CGSize(width: 4, height: 50)
        let y = rect.origin.y - (size.height - rect.size.height)/2+6
        rect = CGRect(origin: CGPoint(x: rect.origin.x+4, y: y), size: size)
        return rect
    }

    private func setup() {
        textAlignment = .center
        textColor = .primaryContrast
        font = UIFont.round(.black, 64)
        adjustsFontSizeToFitWidth = true
    }

    private func makePlaceholder(_ str: String) -> NSAttributedString {
        let font = UIFont.round(.bold, 20)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hex: "#DDDEDE"),
            .font: font
        ]
        let secondString = NSAttributedString(string: str, attributes: attributes)
        return secondString
    }
}



