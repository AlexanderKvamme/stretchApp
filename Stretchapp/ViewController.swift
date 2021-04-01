//
//  ViewController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 20/03/2021.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // MARK: - Properties

    private let horizontalStack = UIStackView()
    private let setPicker = TimePickerView(10)
    private let xIcon = UIImageView(image: .x)
    private let timePicker = TimePickerView(60)
    private let stretchButton = StretchButton("Stretch")
    private let newWorkoutButton = NewWorkoutButton()

    // MARK: - Initializers

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        addSubviewsAndConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        let stretchViewController = StretchingViewController(Stretch.favourites)
        stretchViewController.modalPresentationStyle = .fullScreen
        present(stretchViewController, animated: true, completion: nil)
    }

    // MARK: - Methods

    private func setup() {
        view.backgroundColor = UIColor.background

        horizontalStack.addArrangedSubview(setPicker)
        horizontalStack.addArrangedSubview(xIcon)
        horizontalStack.addArrangedSubview(timePicker)

        horizontalStack.alignment = .center
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .equalSpacing

        stretchButton.addTarget(self, action: #selector(startStretching), for: .touchDown)

        let newWorkoutTap = UITapGestureRecognizer(target: self, action: #selector(createNewWorkout))
        newWorkoutButton.addGestureRecognizer(newWorkoutTap)

//        horizontalStack.backgroundColor = .green
//        setPicker.backgroundColor = .purple
//        timePicker.backgroundColor = .orange
//        xIcon.backgroundColor = .cyan
//        view.backgroundColor = .green
    }

    private func addSubviewsAndConstraints() {
        view.addSubview(horizontalStack)

        horizontalStack.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(40)
            make.center.equalToSuperview()
            make.height.equalTo(setPicker.snp.height)
        }

        setPicker.snp.makeConstraints { (make) in
            make.size.equalTo(TimePickerView.preferredSize)
        }

        xIcon.snp.makeConstraints { (make) in
            make.size.equalTo(24)
        }

        timePicker.snp.makeConstraints { (make) in
            make.size.equalTo(TimePickerView.preferredSize)
        }

        view.addSubview(stretchButton)
        stretchButton.snp.makeConstraints { (make) in
            make.height.equalTo(Style.buttonHeight)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }

        view.addSubview(newWorkoutButton)
        newWorkoutButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.right.equalToSuperview().offset(-32)
            make.width.equalTo(120)
            make.height.equalTo(56)
        }
    }

    @objc private func createNewWorkout() {
        let newWorkoutController = NewWorkoutController()
        newWorkoutController.modalPresentationStyle = .fullScreen
        present(newWorkoutController, animated: false, completion: nil)
    }

    @objc private func startStretching() {
        let stretchViewController = StretchingViewController(Stretch.favourites)
        stretchViewController.modalPresentationStyle = .fullScreen
        present(stretchViewController, animated: false, completion: nil)
    }
}

