//
//   TextFieldWithCustomCaret.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 12/04/2021.
//

import UIKit

class TextFieldWithCustomCaret: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        let size = CGSize(width: 4, height: 50)
        let y = rect.origin.y - (size.height - rect.size.height)/2+6
        rect = CGRect(origin: CGPoint(x: rect.origin.x+4, y: y), size: size)
        return rect
    }
}
