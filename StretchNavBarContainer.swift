//
//  StretchNavBarContainer.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 18/04/2021.
//

import UIKit



class StretchNavBarContainer: UIView {

    let xButton = UIButton.make(.x)
    let xButtonAnimation = AnimatableButton("x-icon-data")
    let fractionView: FractionView

    init(frame: CGRect, color: UIColor) {
        fractionView = FractionView(color: color, topValue: 1, bottomValue: 0)

        super.init(frame: frame)

        xButton.tintColor = color
        fractionView.topLabel.textColor = color
        fractionView.bottomLabel.textColor = color

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {}

    private func addSubviewsAndConstraints() {
        addSubview(xButtonAnimation)
        addSubview(xButton)
        addSubview(fractionView)

        let buttonLeftAdjustmentForAnimation = 13

        xButtonAnimation.snp.makeConstraints { (make) in
            make.centerY.equalTo(fractionView.snp.centerY)
            make.left.equalTo(safeAreaLayoutGuide).offset(24)
            make.size.equalTo(26)
        }

        xButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(fractionView.snp.centerY)
            make.left.equalTo(safeAreaLayoutGuide).offset(buttonLeftAdjustmentForAnimation)
            make.size.equalTo(48)
        }

        fractionView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(8)
            make.right.equalTo(safeAreaLayoutGuide).inset(32)
            make.width.equalTo(64)
            make.height.equalTo(64)
        }
    }

    // API
    func animateInXButton() {
        xButtonAnimation.animationView.play()
        UIView.animate(withDuration: 0.1, delay: 0.5, options: UIView.AnimationOptions()) {
            self.xButton.alpha = 1
        }
    }

    func setColor(_ c: UIColor) {
        xButton.tintColor = c
        fractionView.diagonalLine.shapeLayer?.strokeColor = UIColor(hex: "7F7F7F").cgColor
        fractionView.topLabel.textColor = c
        fractionView.bottomLabel.textColor = c
    }
}
