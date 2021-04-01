//
//  NewWorkoutButton.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 27/03/2021.
//

import UIKit


final class NewWorkoutButton: UIView {

    // MARK: - Properties

    private let iconView = UIImageView(image: UIImage.x)
    private let label = UILabel.make(.fraction)

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
        backgroundColor = UIColor.primaryContrast.withAlphaComponent(0.02)

        layer.cornerRadius = 10
        label.text = "NEW"
        label.font = UIFont.round(.black, 16)

        iconView.transform = iconView.transform.rotated(by: .pi/4)
        iconView.alpha = 0.2
    }

    private func addSubviewsAndConstraints() {
        addSubview(iconView)
        addSubview(label)

        iconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-24)
            make.size.equalTo(16)
        }

        label.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(iconView.snp.left)
        }
    }
}
