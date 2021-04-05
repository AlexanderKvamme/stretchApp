//
//  WorkoutCellView.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 05/04/2021.
//

import UIKit


final class WorkoutCellView: UIView {

    // MARK: - Properties

    let leftLabel = UILabel.make(.header)
    let rightLabel = UILabel.make(.header)
    let background = UIView()

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

    func setup() {
        background.layer.cornerRadius = 22
        background.backgroundColor = .white

        leftLabel.text = "Hands folded behind the back"
        leftLabel.textAlignment = .left
        leftLabel.numberOfLines = 2
        leftLabel.font = UIFont.fulbo(18)

        rightLabel.text = "90 s"
        rightLabel.font = UIFont.fulbo(24)
        rightLabel.textAlignment = .right
        rightLabel.textColor = UIColor(hex: "#FFC73C")
    }

    func addSubviewsAndConstraints() {
        [background, leftLabel, rightLabel].forEach({ addSubview($0) })

        background.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(6)
        }

        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(background).offset(16)
            make.right.equalTo(rightLabel.snp.left).inset(8)
            make.top.bottom.equalTo(background)
        }

        rightLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(background).inset(16)
            make.width.equalTo(100)
        }
    }
}
