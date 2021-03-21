//
//  StretchingViewController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 20/03/2021.
//

import UIKit

struct Stretch {
    let title: String
    let length: Int

    static let dummy = Stretch(title: "This is a dummy stretch", length: 30)
    static let completion = Stretch(title: "Congratulations", length: 30)
}


class StretchingViewController: UIViewController {

    // MARK: - Properties

    let fractionView = SetFractionView(topValue: 2, bottomValue: 5)
    let xButton = UIButton.make(.x)

    let topWaveView = ExerciceWaveView(.light)
    let botWaveView = ExerciceWaveView(.dark)

    let strethces: [Stretch]

    // MARK: - Initializers

    init(_ stretches: [Stretch]) {
        self.strethces = stretches

        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .background

        setInitialStretch(from: stretches)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startExerciseAnimationLoop()
    }

    // MARK: - Methods

    private func startExerciseAnimationLoop() {
        fractionView.animate()
        botWaveView.waveAnimation.wave()
        topWaveView.waveAnimation.wave()

        // TODO: The loop
        self.botWaveView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top)
        }

        UIView.animate(withDuration: 15) {
            self.view.layoutIfNeeded()
        }
    }

    private func setInitialStretch(from stretches: [Stretch]) {
        let firstStretch = stretches[0]
        let secondStretch = stretches[1]

        topWaveView.alpha = 0.5
        topWaveView.setStretch(firstStretch)
        botWaveView.setStretch(secondStretch)
    }

    private func setup() {

    }

    private func addSubviewsAndConstraints() {
        view.addSubview(xButton)
        view.addSubview(fractionView)

        view.addSubview(topWaveView)
        view.addSubview(botWaveView)

        xButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.size.equalTo(24)
        }

        fractionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.width.equalTo(54)
            make.height.equalTo(64)
        }

        topWaveView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(botWaveView.snp.top)
        }

        botWaveView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(screenHeight)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension UILabel {

    enum LabelStyle {
        case fraction
        case standard
        case exercise
    }

    static func make(_ style: LabelStyle, text: String = "") -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.font = UIFont.round(.bold, 12)
        lbl.textAlignment = .center
        lbl.textColor = .black

        switch style {
        case .fraction:
            lbl.font = UIFont.round(.bold, 32)
        case .standard:
            lbl.font = UIFont.round(.bold, 12)
        case .exercise:
            lbl.font = UIFont.round(.bold, 40)
        }

        return lbl
    }
}

extension UIButton {

    enum ButtonStyle {
        case x
    }

    static func make(_ style: ButtonStyle) -> UIButton {
        let btn = UIButton()
        btn.tintColor = .black

        switch style {
        case .x:
            btn.setImage(UIImage.x, for: .normal)
            btn.tintColor = .black
        }
        return btn
    }
}
