//
//  NewWorkoutButton.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 27/03/2021.
//

import UIKit
import Lottie


final class NewWorkoutButton: UIButton {

    // MARK: - Properties

    private let animationView = AnimationView.init(name: "x-icon-data")
    var pulsateOnAppear = false

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

    func animate() {
        if animationView.currentProgress == 0 {
            animationView.play()
        } else {
            pulse()
        }
    }

    private func pulse() {
        guard pulsateOnAppear else { return }

        let existingBg = backgroundColor
        let duration = 0.15
        let scaleUp: CGFloat = 1.4

        UIView.animate(withDuration: duration) {
            self.animationView.transform = self.animationView.transform.scaledBy(x: scaleUp, y: scaleUp)
            self.backgroundColor = UIColor.primaryContrast.withAlphaComponent(0.05)
        } completion: { (done) in
            UIView.animate(withDuration: duration) {
                let trans = CGAffineTransform.identity.rotated(by: .pi/4)
                self.animationView.transform = trans
                self.backgroundColor = existingBg
            }
        }
    }
}
