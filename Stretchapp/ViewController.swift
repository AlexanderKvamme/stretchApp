//
//  ViewController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 20/03/2021.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties

    private let timePickerStack = UIStackView()
    private let setPicker = TimePickerView()
    private let xIcon = UIView()
    private let timePicker = TimePickerView()

    // MARK: - Initializers

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setup()
        addSubviewsAndConstraints()
    }


    private func setup() {
        view.backgroundColor = UIColor.primary
    }

    private func addSubviewsAndConstraints() {

    }

}

