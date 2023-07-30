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

//    private let animationView = AnimationView.init(name: "data")
    private let animationView = VFontAnimationVC_1()
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

    override func viewWillAppear(_ animated: Bool) {
//        animationView.transform = CGAffineTransform.identity
    }
    
    override func viewDidAppear(_ animated: Bool) {
        workoutPicker.updateSnapshot(DAO.getWorkouts())

        addTapGestures()

        newWorkoutButton.animate()
        animateInLogo()
        
        // Present TestViewController
//        let testVC = CelebrationViewController(workout: .dummy)
//        testVC.modalPresentationStyle = .fullScreen
    }

    // MARK: - Methods

    @objc func playAnimation() {
//        animationView.play()
    }

    private func addTapGestures() {
//        let tr = UITapGestureRecognizer(target: self, action: #selector(playAnimation))
//        animationView.addGestureRecognizer(tr)
    }

    private func animateInLogo() {
//        UIView.animate(withDuration: 0.6) {
//            let scale: CGFloat = 0.99
//            self.animationView.transform = self.animationView.transform.scaledBy(x: scale, y: scale).translatedBy(x: 0, y: -5)
//        }
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

        view.addSubview(animationView.view)
        animationView.view.snp.makeConstraints { (make) in
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
}

extension ViewController: TextInputReceiver {
    func receiveTextInput(_ str: String) {
        let newWorkoutController = NewWorkoutController(title: str)
        newWorkoutController.modalPresentationStyle = .fullScreen
        present(newWorkoutController, animated: false, completion: nil)
    }
}

