//
//  ExerciseWaveView.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 21/03/2021.
//

import UIKit


final class ExerciceWaveView: UIView {

    // MARK: - Properties

    let label = UILabel.make(.exercise)

    // MARK: - Initializers

    init(_ backgroundColor: UIColor) {
        super.init(frame: .zero)

        self.backgroundColor = backgroundColor

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        label.textColor = .red
        label.backgroundColor = .orange
        label.text = "This is a temporary exercise"
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
    }

    private func addSubviewsAndConstraints() {
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
