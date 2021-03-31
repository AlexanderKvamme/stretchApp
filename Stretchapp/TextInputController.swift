//
//  TextInputController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 29/03/2021.
//

import UIKit

final class TextInputController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties

    private let nameLabel = UILabel.make(.header)
    private let input = UITextField()
    private let backButton = UIButton.make(.back)

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
        nameLabel.text = "Whats it called?"
        nameLabel.textColor = .background
        nameLabel.textAlignment = .center
        input.placeholder = "swag"
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
    }

    // MARK: - TextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let vc = TimeInputController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
        return true
    }
}

