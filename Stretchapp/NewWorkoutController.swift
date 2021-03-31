//
//  NewWorkoutController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 28/03/2021.
//

import UIKit

final class NewWorkoutController: UIViewController {

    // MARK: - Properties

    private let backButton = UIButton.make(.back)
    private let wobbler = WobbleView()
    private let nameLabel = UILabel.make(.header)
    private let addButton = UIButton.make(.plusPill)
    private let addButtonBackground = UIView()

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .background

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        backButton.tintColor = .background
        nameLabel.text = "Gabo's Favourites"
        nameLabel.textColor = .background
        nameLabel.textAlignment = .left
        backButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        addButton.tintColor = .background
        addButton.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi/4)
        addButtonBackground.layer.cornerRadius = 64/2
        addButtonBackground.backgroundColor = .primaryContrast

        addButton.addTarget(self, action: #selector(getTextInput), for: .touchUpInside)
    }

    @objc private func getTextInput() {
        let vc = TextInputController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }

    @objc private func exit() {
        dismiss(animated: false)
    }

    private func addSubviewsAndConstraints() {
        wobbler.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi/4).scaledBy(x: 2, y: 4).translatedBy(x: -200, y: -30)
        view.addSubview(wobbler)
        view.addSubview(backButton)
        view.addSubview(nameLabel)
        view.addSubview(addButtonBackground)
        view.addSubview(addButton)

        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.size.equalTo(48)
        }

        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backButton.snp.right).offset(24)
            make.right.equalToSuperview()
            make.height.equalTo(48)
            make.centerY.equalTo(backButton)
        }

        addButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-48)
        }

        addButtonBackground.snp.makeConstraints { (make) in
            make.center.equalTo(addButton)
            make.size.equalTo(64)
        }
    }
}
