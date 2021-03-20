//
//  StretchButton.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 20/03/2021.
//

import UIKit

class StretchButton: UIButton {

    // MARK: - Properties

    // MARK: - Initializers

    init(_ title: String) {
        super.init(frame: CGRect.zero)

        setTitle(title, for: .normal)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        backgroundColor = .card
        layer.cornerRadius = 24
        titleLabel?.font = UIFont.fulbo(32)
        setTitleColor(.black, for: .normal)
    }

    private func addSubviewsAndConstraints() { }
}
