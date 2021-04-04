//
//  ButtonWithBackground.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 04/04/2021.
//

import UIKit


final class ButtonWithBackground: UIButton {

    // MARK: - Properties

    private let label = UILabel.make(.exercise)

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setup() {
        backgroundColor = .green
        layer.cornerRadius = 22
    }

    func addSubviewsAndConstraints() {
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

