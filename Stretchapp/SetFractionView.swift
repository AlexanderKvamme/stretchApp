//
//  SetFractionView.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 21/03/2021.
//

import UIKit


class SetFractionView: UIView {

    // MARK: - Properties

    var topValue: Int
    var bottomValue: Int

    let topLabel = UILabel.make(.fraction)
    let bottomLabel = UILabel.make(.fraction)
    let diagonalLine = AnimatableDiagonalView()

    // MARK: - Initializers

    init(topValue: Int, bottomValue: Int) {
        self.topValue = topValue
        self.bottomValue = bottomValue

        super.init(frame: .zero)

        topLabel.text = String(topValue)
        bottomLabel.text = String(bottomValue)

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

        diagonalLine.alpha = 0.3
    }

    func animate() {
        diagonalLine.test()
    }

    private func addSubviewsAndConstraints() {
        addSubview(topLabel)
        addSubview(bottomLabel)
        addSubview(diagonalLine)

        topLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }

        diagonalLine.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(24)
        }

        bottomLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
        }
    }
}
