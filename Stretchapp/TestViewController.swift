//
//  TestViewController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 17/04/2021.
//

import UIKit


class TestViewController: UIViewController {

    // MARK: - Properties

    let exerciseView = ExerciceView(.dark)

    // MARK: - Methods

    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .primaryContrast
        exerciseView.frame = view.frame
        view.addSubview(exerciseView)

        exerciseView.setStretch(Stretch.dummy)
        exerciseView.animateIn()
    }
    
}

