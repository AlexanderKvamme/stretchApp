//
//  TextInputScreen.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 03/04/2021.
//

import UIKit

protocol TextInputReceiver {
    func receiveTextInput(_ str: String)
}

final class TextInputScreen: UIViewController, UITextFieldDelegate {

    // MARK: - Properties

    private let nameLabel = UILabel.makeStretchLabel(.inputHeader)
    private let input = TextFieldWithCustomCaret(placeholder: "Workout name")
    private let backButton = UIButton.make(.back)

    var delegate: TextInputReceiver?

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
        backButton.tintColor = .primaryContrast
        nameLabel.text = "Enter workout name"

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
            make.top.equalTo(nameLabel.snp.bottom).offset(-8)
            make.left.right.equalToSuperview().inset(32)
        }
    }

    // MARK: - TextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismiss(animated: false, completion: {
            self.delegate?.receiveTextInput(textField.text ?? "No title given")
        })
        return true
    }
}
