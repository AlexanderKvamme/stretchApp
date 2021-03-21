//
//  ExerciseWaveView.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 21/03/2021.
//

import UIKit
import WXWaveView

final class ExerciceWaveView: UIView {

    enum WaveStyle {
        case light
        case dark

        var foregroundColor: UIColor {
            if self == .light {
                return UIColor.primaryContrast
            } else {
                return UIColor.background
            }
        }

        var backgroundColor: UIColor {
            if self == .light {
                return UIColor.background
            } else {
                return UIColor.primaryContrast
            }
        }
    }

    // MARK: - Properties

    let label = UILabel.make(.exercise)

    let waveHeight = 16
    let waveAnimation = WXWaveView()

    // MARK: - Initializers

    init(_ style: WaveStyle) {
        super.init(frame: .zero)

        self.backgroundColor = backgroundColor
        waveAnimation.waveColor = backgroundColor

        setup(style)
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setStyle(_ style: WaveStyle) {
        label.textColor = style.foregroundColor
        backgroundColor = style.backgroundColor
        waveAnimation.waveColor = style.foregroundColor
        print("bam wavesetting color to ", style.foregroundColor)
//        waveAnimation.waveColor = .cyan
    }

    private func setup(_ style: WaveStyle) {
        setStyle(style)

        clipsToBounds = false
        waveAnimation.waveTime = 0
        waveAnimation.angularSpeed = 2
        waveAnimation.waveSpeed = 1
        waveAnimation.wave()

        label.text = "This is a temporary exercise"
        label.numberOfLines = 0
//        label.adjustsFontSizeToFitWidth = true
    }

    private func addSubviewsAndConstraints() {
        addSubview(waveAnimation)
        waveAnimation.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(snp.top).offset(1)
            make.height.equalTo(waveHeight)
        }

        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: API

    func setStretch(_ stretch: Stretch) {
        label.text = stretch.title
    }
}
