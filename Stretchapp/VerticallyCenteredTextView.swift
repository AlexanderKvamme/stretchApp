//
//  VerticallyCenteredTextView.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 17/04/2021.
//

import UIKit


class VerticallyCenteredTextView: UITextView {
    override var contentSize: CGSize {
        didSet {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        }
    }
}
