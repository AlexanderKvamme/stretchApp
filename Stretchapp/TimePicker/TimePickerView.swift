//
//  TimePickerView.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 20/03/2021.
//

import UIKit

enum NumberType {
    case minutes
    case seconds
}

class TimePickerView: UIView {

    // MARK: - Properties

    static let preferredSize = CGSize(width: 160, height: 160)

    var value: Int = 0
    var numberType: NumberType = .minutes

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

    private func setup() {
        backgroundColor = .green
        layer.cornerRadius = 24
    }

    private func addSubviewsAndConstraints() {

    }
}
