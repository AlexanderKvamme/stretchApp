//
//  NewWorkoutButton.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 27/03/2021.
//

import UIKit
import Lottie


final class NewWorkoutButton: UIView {

    // MARK: - Properties

    private let animationView = AnimationView.init(name: "x-icon-data")

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

        animationView.transform = animationView.transform.rotated(by: .pi/4)
    }

    override func layoutSubviews() {
        layer.cornerRadius = frame.size.width/4
        layer.cornerCurve = .continuous
    }

    private func addSubviewsAndConstraints() {
        addSubview(animationView)

        animationView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(16)
        }
    }

    func animateIn() {
        animationView.play()
    }
}
