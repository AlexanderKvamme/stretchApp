//
//  TimeInputController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 29/03/2021.
//

import UIKit

final class TimeInputController: UIViewController {

    // MARK: - Properties

    private let nameLabel = UILabel.make(.header)
    private let input = UITextField()
    private let backButton = UIButton.make(.back)
    private let timePicker = TimePicker()

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
        nameLabel.text = "How long is it tho?"
        nameLabel.textColor = .background
        nameLabel.textAlignment = .center
        input.placeholder = "60 seconds"
        input.textAlignment = .center
        input.font = UIFont.round(.black, 64)
        input.adjustsFontSizeToFitWidth = true
        input.isUserInteractionEnabled = false

        backButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
    }

    @objc private func exit() {
        dismiss(animated: false)
    }

    private func addSubviewsAndConstraints() {
        view.addSubview(backButton)
        view.addSubview(nameLabel)
        view.addSubview(input)
        view.addSubview(timePicker.view)

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

        timePicker.view.snp.makeConstraints { (make) in
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-48)
        }
    }
}

