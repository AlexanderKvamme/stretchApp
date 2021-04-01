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

        iconView.transform = iconView.transform.rotated(by: .pi/4)
        iconView.alpha = 0.2
    }

    private func addSubviewsAndConstraints() {
        addSubview(iconView)

        iconView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(16)
        }
    }
}
