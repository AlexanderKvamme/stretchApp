//
//  CustomTextComponents.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 18/04/2021.
//

import UIKit



extension UITextView {

    enum TextViewStyle {
        case exercise
    }

    static func make(_ style: TextViewStyle, text: String = "") -> UITextView {
        let textView = VerticallyCenteredTextView()
        textView.text = text
        textView.font = UIFont.round(.bold, 12)
        textView.textAlignment = .center
        textView.textColor = .primaryContrast

        switch style {
        case .exercise:
            textView.font = UIFont.round(.bold, 40)
        }

        return textView
    }
}

extension UILabel {

    enum LabelStyle {
        case fraction
        case standard
        case exercise
        case header
        case inputHeader
    }

    static func make(_ style: LabelStyle, text: String = "") -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.font = UIFont.round(.bold, 12)
        lbl.textAlignment = .center
        lbl.textColor = .primaryContrast

        switch style {
        case .fraction:
            lbl.font = UIFont.round(.bold, 32)
        case .standard:
            lbl.font = UIFont.round(.bold, 12)
        case .exercise:
            lbl.font = UIFont.round(.bold, 40)
        case .header:
            lbl.font = UIFont.round(.bold, 24)
        case .inputHeader:
            lbl.font = UIFont.round(.bold, 20)
            lbl.textAlignment = .center
        }

        return lbl
    }
}

extension UIButton {

    enum ButtonStyle {
        case x
        case back
        case plusPill
    }

    static func make(_ style: ButtonStyle) -> UIButton {
        let btn = UIButton()
        let imageInset: CGFloat = 12
        btn.imageEdgeInsets = UIEdgeInsets(top: imageInset, left: imageInset, bottom: imageInset, right: imageInset)
        btn.tintColor = .black

        switch style {
        case .x:
            btn.setImage(UIImage.x!.withRenderingMode(.alwaysTemplate), for: .normal)
            btn.tintColor = .primaryContrast
        case .back:
            btn.setImage(UIImage.back!.withRenderingMode(.alwaysTemplate), for: .normal)
            btn.tintColor = .primaryContrast
        case .plusPill:
            btn.setImage(UIImage.x!.withRenderingMode(.alwaysTemplate).withTintColor(.red), for: .normal)
            btn.tintColor = .orange
            btn.layer.cornerRadius = 40
        }
        return btn
    }
}
