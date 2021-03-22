//
//  ExerciseWaveView.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 21/03/2021.
//

import UIKit


final class ExerciceWaveView: UIView {

    enum ExerciseSlideStyle {
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

    // MARK: - Initializers

    init(_ style: ExerciseSlideStyle) {
        super.init(frame: .zero)

        setup(style)
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setStyle(_ style: ExerciseSlideStyle) {
        label.textColor = style.foregroundColor
        backgroundColor = style.backgroundColor
    }

    private func setup(_ style: ExerciseSlideStyle) {
        setStyle(style)

        label.text = "This is a temporary exercise"
        label.numberOfLines = 0
    }

    private func addSubviewsAndConstraints() {
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
