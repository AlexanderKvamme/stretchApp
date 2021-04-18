//
//  AnimatableButton.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 18/04/2021.
//

import UIKit
import Lottie



class AnimatableButton: UIView {

    // MARK: - Properties

    let animationView: AnimationView!

    // MARK: - Initializers

    init(_ animation: String) {
        animationView = AnimationView.init(name: animation)

        super.init(frame: .zero)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {

    }

    private func addSubviewsAndConstraints() {
        addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

