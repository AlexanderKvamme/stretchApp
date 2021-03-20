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

    static let preferredSize = CGSize(width: Style.buttonHeight, height: Style.buttonHeight)

    var value: Int
    var numberType: NumberType = .minutes

    // MARK: - Initializers

    init(_ initialValue: Int = 0) {
        self.value = initialValue

        super.init(frame: CGRect(origin: .zero, size: Self.preferredSize))

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        backgroundColor = .card
        layer.cornerRadius = Style.cornerRadius
    }

    private func addSubviewsAndConstraints() {
        let lbl = UILabel()
        lbl.text = String(value)
        lbl.textAlignment = .center
        lbl.font = UIFont.round(.black, 40)
        lbl.textColor = .black

        addSubview(lbl)
        lbl.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
