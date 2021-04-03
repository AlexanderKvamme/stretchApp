//
//  SetFractionView.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 21/03/2021.
//

import UIKit


class FractionView: UIView {

    // MARK: - Properties

    var topValue: Int
    var bottomValue: Int

    let topLabel = UILabel.make(.fraction)
    let bottomLabel = UILabel.make(.fraction)
    let diagonalLine: AnimatableDiagonalView

    // MARK: - Initializers

    init(color: UIColor, topValue: Int, bottomValue: Int) {
        self.topValue = topValue
        self.bottomValue = bottomValue
        self.diagonalLine = AnimatableDiagonalView(color)

        super.init(frame: .zero)

        topLabel.text = "1"
        bottomLabel.text = ""

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        //        backgroundColor = .purple
        //        topLabel.backgroundColor = .green
        //        bottomLabel.backgroundColor = .orange
        //        diagonalLine.backgroundColor = .brown
    }

    func animate() {
        diagonalLine.drawLineAnimation()
    }

    private func addSubviewsAndConstraints() {
        addSubview(topLabel)
        addSubview(bottomLabel)
        addSubview(diagonalLine)

        let hOffset = 4
        let vOffset = 8
        
        topLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-vOffset)
            make.left.equalToSuperview().offset(-hOffset)
            make.right.equalTo(snp.centerX)//.offset(-hOffset)
        }

        diagonalLine.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(24)
        }

        bottomLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(vOffset)
            make.right.equalToSuperview().offset(hOffset)
            make.left.equalTo(snp.centerX)//.offset(hOffset)
        }

        bottomLabel.adjustsFontSizeToFitWidth = true
        bottomLabel.textAlignment = .left
        topLabel.textAlignment = .right
        topLabel.adjustsFontSizeToFitWidth = true
    }

    // API

    func setFraction(_ top: String, _ bottom: String) {
        topLabel.text = top
        bottomLabel.text = bottom
    }
}
