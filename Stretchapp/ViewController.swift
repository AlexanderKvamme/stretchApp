//
//  ViewController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 20/03/2021.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // MARK: - Settings

    private let workoutButtonSize: CGFloat = 56

    // MARK: - Properties

    private let logoAnimationPlaceholder = UIImageView(image: .animationPlaceholder)
    private let workoutPicker = WorkoutPicker()
    private let newWorkoutButton = NewWorkoutButton()

    // MARK: - Initializers

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        addSubviewsAndConstraints()

//        workoutPicker.updateSnapshot(Workout.dummies)
    }

    override func viewDidAppear(_ animated: Bool) {
        workoutPicker.updateSnapshot(DAO.getWorkouts())

//        let stretchViewController = StretchingViewController(Stretch.forDebugging)
//        stretchViewController.modalPresentationStyle = .fullScreen
//        present(stretchViewController, animated: true, completion: nil)

        // BAM: Show NewWorkoutController

//        let vc = NewWorkoutController(title: "Flex Boys")
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: false)

//        DAO.saveWorkout(testWorkout)
    }

    // MARK: - Methods

    private func setup() {
        view.backgroundColor = UIColor.background

        let newWorkoutTap = UITapGestureRecognizer(target: self, action: #selector(createNewWorkout))
        newWorkoutButton.addGestureRecognizer(newWorkoutTap)
        newWorkoutButton.layer.cornerRadius = workoutButtonSize/2

        logoAnimationPlaceholder.contentMode = .scaleAspectFit

//        horizontalStack.backgroundColor = .green
//        setPicker.backgroundColor = .purple
//        timePicker.backgroundColor = .orange
//        xIcon.backgroundColor = .cyan
//        view.backgroundColor = .green
    }

    private func addSubviewsAndConstraints() {
        view.addSubview(newWorkoutButton)
        newWorkoutButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.right.equalToSuperview().offset(-32)
            make.size.equalTo(workoutButtonSize)
        }

        view.addSubview(logoAnimationPlaceholder)
        logoAnimationPlaceholder.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(90)
            make.top.equalTo(newWorkoutButton.snp.bottom).offset(32)
            make.height.equalTo(logoAnimationPlaceholder.snp.width)
        }

        addChild(workoutPicker)
        view.addSubview(workoutPicker.view)
        workoutPicker.view.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(240)
            make.bottom.equalToSuperview().offset(-32)
        }
    }

    @objc private func createNewWorkout() {
        let textInputScreen = TextInputScreen()
        textInputScreen.delegate = self
        textInputScreen.modalPresentationStyle = .fullScreen
        present(textInputScreen, animated: true)
    }

    @objc private func startStretching() {
        let stretchViewController = StretchingViewController(Stretch.favourites)
        stretchViewController.modalPresentationStyle = .fullScreen
        present(stretchViewController, animated: false, completion: nil)
    }
}

extension ViewController: TextInputReceiver {
    func receiveTextInput(_ str: String) {
        let newWorkoutController = NewWorkoutController(title: str)
        newWorkoutController.modalPresentationStyle = .fullScreen
        present(newWorkoutController, animated: false, completion: nil)
    }
}

