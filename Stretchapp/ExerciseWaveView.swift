//
//  ExerciseWaveView.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 21/03/2021.
//

import UIKit
import WXWaveView

final class ExerciceWaveView: UIView {

    // MARK: - Properties

    let label = UILabel.make(.exercise)

    let waveHeight = 16
    let waveAnimation = WXWaveView()

    // MARK: - Initializers

    init(_ backgroundColor: UIColor) {
        super.init(frame: .zero)

        self.backgroundColor = backgroundColor
        waveAnimation.waveColor = backgroundColor

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        waveAnimation.waveTime = 0
        waveAnimation.angularSpeed = 2
        waveAnimation.waveSpeed = 1
        waveAnimation.wave()

        label.textColor = .background
        label.backgroundColor = .clear
        label.text = "This is a temporary exercise"
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
    }

    private func addSubviewsAndConstraints() {
        addSubview(waveAnimation)
        waveAnimation.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(snp.top)
            make.height.equalTo(waveHeight)
        }

        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
