//
//  ViewController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 20/03/2021.
//

import UIKit
import Lottie
import SnapKit

fileprivate let workoutButtonSize: CGFloat = 56
fileprivate let workoutPickerHeight: CGFloat = 300

class ViewController: UIViewController {

    // MARK: - Properties

    private let animationView = AnimationView.init(name: "data")
    private let workoutPicker = WorkoutPicker()
    private let workoutPickerShadow = ShadowView(frame: CGRect(x: 0, y: 0, width: screenWidth-48, height: workoutPickerHeight))
    private let newWorkoutButton = NewWorkoutButton()

    // MARK: - Initializers

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        addSubviewsAndConstraints()

        if DAO.getWorkouts().filter({ (workout) -> Bool in
            workout.name == Workout.gabos.name
        }).count == 0 {
            DAO.saveWorkout(Workout.gabos)
        }
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

        newWorkoutButton.animateIn()

        let tr = UITapGestureRecognizer(target: self, action: #selector(playAnimation))
        animationView.addGestureRecognizer(tr)
    }

    // MARK: - Methods

    @objc func playAnimation() {
        animationView.play()
    }

    private func setup() {
        view.backgroundColor = UIColor.background

        let newWorkoutTap = UITapGestureRecognizer(target: self, action: #selector(createNewWorkout))
        newWorkoutButton.addGestureRecognizer(newWorkoutTap)
        workoutPickerShadow.opacity = 0.07
    }

    private func addSubviewsAndConstraints() {
        view.addSubview(newWorkoutButton)
        newWorkoutButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.right.equalToSuperview().offset(-32)
            make.size.equalTo(workoutButtonSize)
        }

        view.addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(newWorkoutButton.snp.bottom).offset(16)
            make.height.equalTo(200)
        }

        addChild(workoutPicker)
        view.addSubview(workoutPickerShadow)
        view.addSubview(workoutPicker.view)
        workoutPicker.view.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(2)
            make.height.equalTo(workoutPickerHeight)
            make.bottom.equalToSuperview()
        }

        workoutPickerShadow.snp.makeConstraints { (make) in
            make.top.equalTo(workoutPicker.view.snp.top).offset(40)
            make.centerX.equalTo(workoutPicker.view)
            make.height.equalTo(workoutPickerHeight/1.5)
            make.width.equalTo(screenWidth-100)
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

