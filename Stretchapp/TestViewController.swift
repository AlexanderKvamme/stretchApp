//
//  TestViewController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 17/04/2021.
//

import UIKit
import AKKIT


class TestViewController: UIViewController {

    // MARK: - Properties

    let exerciseView = ExerciseView(.dark)

    // MARK: - Methods

    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .primaryContrast
        exerciseView.frame = view.frame
        view.addSubview(exerciseView)

        exerciseView.setStretch(Stretch.dummy)
        exerciseView.animateIn()
        
        let test = ConfettiView()
        view.addSubview(test)
        test.startConfetti()
    }
    
}

