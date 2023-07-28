//
//  ButtonWithBackground.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 04/04/2021.
//

import UIKit


final class ButtonWithBackground: UIButton {

    // MARK: - Properties

    private let label = UILabel.makeStretchLabel(.exercise)

    // MARK: - Initializers

    init(_ title: String) {
        label.text = title.uppercased()

        super.init(frame: .zero)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setup() {
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous

        label.textColor = .background
        label.font = UIFont.round(.bold, 16)
        backgroundColor = .primaryContrast
    }

    func addSubviewsAndConstraints() {
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
}

