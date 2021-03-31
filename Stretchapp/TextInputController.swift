//
//  TextInputController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 29/03/2021.
//

import UIKit

let stepperFrame = CGRect(x: 0, y: 0, width: 222, height: 64)
let testOptions = ["30 s", "45 s", "60 s", "90 s", "2 m", "3 m", "4 m", "5 m", "6 m", "7 m", "8 m", "9 m"]

final class TextInputController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties

    private let nameLabel = UILabel.make(.header)
    private let input = UITextField()
    private let backButton = UIButton.make(.back)
    private let superStepper = SuperStepper(frame: stepperFrame, options: testOptions)
    private let stepperShadow = ShadowView(frame: stepperFrame)

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .primaryContrast

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        backButton.tintColor = .background
        nameLabel.text = "Stretch name"
        nameLabel.textColor = .background
        nameLabel.textAlignment = .center
        nameLabel.alpha = 0.8
        input.placeholder = "Forward fold"
        input.textAlignment = .center
        input.font = UIFont.round(.black, 64)
        input.adjustsFontSizeToFitWidth = true
        input.delegate = self

        backButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        input.becomeFirstResponder()
    }

    @objc private func exit() {
        dismiss(animated: false)
    }

    private func addSubviewsAndConstraints() {
        view.addSubview(backButton)
        view.addSubview(nameLabel)
        view.addSubview(input)
        view.addSubview(stepperShadow)
        view.addSubview(superStepper)

        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.size.equalTo(48)
        }

        nameLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(backButton.snp.bottom).offset(24)
            make.height.equalTo(48)
        }

        input.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(32)
        }

        stepperShadow.snp.makeConstraints { (make) in
            make.top.equalTo(superStepper.snp.top).offset(10)
            make.centerX.equalTo(superStepper)
            make.size.equalTo(superStepper.frame.size)
        }

        superStepper.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(superStepper.frame.size)
            make.top.equalTo(input.snp.bottom).offset(24)
        }
    }

    // MARK: - TextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let vc = TimeInputController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
        return true
    }
}
