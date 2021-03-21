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

    private let labelAnimateOutEndTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    private let labelAnimateInStartTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)

    var strethces: [Stretch]
    let fractionView = SetFractionView(topValue: 2, bottomValue: 5)
    let xButton = UIButton.make(.x)
    let topWaveView = ExerciceWaveView(.light)
    let botWaveView = ExerciceWaveView(.dark)
    var currentAnimationIteration = 0
    var hasNextAnimation: Bool {
        return currentAnimationIteration < strethces.count-1
    }

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        fractionView.animate()
        botWaveView.waveAnimation.wave()
        topWaveView.waveAnimation.wave()

        playNextAnimation()
    }

    // MARK: - Methods

    private func playNextAnimation() {
        resetViews()
        view.layoutIfNeeded()

        self.updateStretches()

        if hasNextAnimation {
            UIView.animate(withDuration: 10) {
                self.setNextLayout()
                self.view.layoutIfNeeded()
            } completion: { (_) in
                self.currentAnimationIteration += 1
                self.playNextAnimation()
            }
        } else {
            playCompletionAnimation()
        }
    }

    private func updateStretches() {
        topWaveView.setStretch(strethces[currentAnimationIteration])

        if currentAnimationIteration+1 < strethces.count {
            botWaveView.setStretch(strethces[currentAnimationIteration+1])
        }
    }

    private func playCompletionAnimation() {
        view.backgroundColor = .green
        topWaveView.backgroundColor = .green
        botWaveView.backgroundColor = .green
    }

    private func resetViews() {
        topWaveView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        botWaveView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 0)

        topWaveView.label.transform = .identity
        botWaveView.label.transform = labelAnimateInStartTransform

        let topStyle: ExerciceWaveView.WaveStyle = currentAnimationIteration%2 == 0 ? .light : .dark
        let botStyle: ExerciceWaveView.WaveStyle = currentAnimationIteration%2 == 0 ? .dark : .light

        topWaveView.setStyle(topStyle)
        botWaveView.setStyle(botStyle)
    }

    private func setNextLayout() {
        self.topWaveView.frame.origin.y -= screenHeight/2
        self.botWaveView.frame = botEndFrame

        self.topWaveView.label.transform = labelAnimateOutEndTransform
        self.botWaveView.label.transform = .identity
    }

    private var topStartFrame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    private var topEndFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 0)
    private var botEndFrame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    private var botStartFrame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 0)

    private func setInitialStretch(from stretches: [Stretch]) {
        let firstStretch = stretches[0]
        let secondStretch = stretches[1]

        topWaveView.setStretch(firstStretch)
        botWaveView.setStretch(secondStretch)
    }

    private func setup() { }

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

//        topWaveView.snp.makeConstraints { (make) in
//            make.top.left.right.equalToSuperview()
//            make.bottom.equalTo(botWaveView.snp.top)
//        }
//
//        botWaveView.snp.makeConstraints { (make) in
//            make.top.equalTo(view.snp.top).offset(screenHeight)
//            make.left.right.bottom.equalToSuperview()
//        }
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
