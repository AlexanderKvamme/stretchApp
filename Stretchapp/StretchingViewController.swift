//
//  StretchingViewController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 20/03/2021.
//

import UIKit
import WXWaveView

class StretchNavBarContainer: UIView {
    let xButton = UIButton.make(.x)
    let fractionView = SetFractionView(topValue: 1, bottomValue: 0)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {}

    private func addSubviewsAndConstraints() {
        addSubview(xButton)
        addSubview(fractionView)

        xButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(safeAreaLayoutGuide).offset(40)
            make.size.equalTo(24)
        }

        fractionView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.right.equalTo(safeAreaLayoutGuide).inset(32)
            make.width.equalTo(54)
            make.height.equalTo(64)
        }
    }
}

struct Stretch {
    let title: String
    let length: Int

    static let dummy = Stretch(title: "This is a dummy stretch", length: 30)
    static let completion = Stretch(title: "Congratulations", length: 30)

    static let favourites = [
        Stretch(title: "Hands folded behind back", length: 30),
        Stretch(title: "Low squat", length: 30),
        Stretch(title: "Spinal twist", length: 30),
        Stretch(title: "Back bend", length: 30),
        Stretch(title: "Forward fold", length: 30),
        Stretch(title: "Pigeon pose", length: 30),
        Stretch(title: "Quad bends", length: 30),
        Stretch.completion
    ]
}

class StretchingViewController: UIViewController {

    // MARK: - Properties

    private let labelAnimateOutEndTransform = CGAffineTransform.identity
        .scaledBy(x: 0.8, y: 0.8)
        .translatedBy(x: 0, y: -100)
    private let labelAnimateInStartTransform = CGAffineTransform.identity
        .scaledBy(x: 0.1, y: 0.1)
        .translatedBy(x: 0, y: 500)
    var stretches: [Stretch]
    let navBarContainer = StretchNavBarContainer(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
    let topView = ExerciceView(.light)
    let botView = ExerciceView(.dark)
    var wave = WaveView(frame: .zero, color: .green)
    let waveHeight: CGFloat = 80
    var currentAnimationIteration = 0
    var hasNextAnimation: Bool {
        return currentAnimationIteration < stretches.count-1
    }

    // MARK: - Initializers

    init(_ stretches: [Stretch]) {
        self.stretches = stretches
        self.navBarContainer.backgroundColor = .green
        self.navBarContainer.fractionView.bottomLabel.text = String(stretches.count)

        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .background
        setInitialStretch(from: stretches)
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navBarContainer.fractionView.animate()
        playNextAnimation()
    }

    // MARK: - Methods

    private func playNextAnimation() {
        resetViews()
        view.layoutIfNeeded()

        self.updateStretches()

        if hasNextAnimation {
            let stretchLength = stretches[currentAnimationIteration].length
            Audioplayer.play(.newStretch)
            self.navBarContainer.fractionView.topLabel.text = String(currentAnimationIteration+1)
            UIView.animate(withDuration: TimeInterval(stretchLength)) {
                self.setNextLayout()
                self.botView.label.alpha = 1
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
        topView.setStretch(stretches[currentAnimationIteration])

        if currentAnimationIteration+1 < stretches.count {
            botView.setStretch(stretches[currentAnimationIteration+1])
        }
    }

    private func playCompletionAnimation() {
        Audioplayer.play(.congratulations)
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(resetScreen))
        view.addGestureRecognizer(tapRec)
    }

    @objc private func resetScreen() {
        let stretchViewController = StretchingViewController(stretches)
        stretchViewController.modalPresentationStyle = .fullScreen
        present(stretchViewController, animated: true, completion: nil)
    }

    private func resetViews() {
        wave.removeFromSuperview()

        let topStyle: ExerciceView.ExerciseSlideStyle = currentAnimationIteration%2 == 0 ? .light : .dark
        let botStyle: ExerciceView.ExerciseSlideStyle = currentAnimationIteration%2 == 0 ? .dark : .light

        wave = WaveView(frame: .zero, color: topStyle.foregroundColor)
        wave.backgroundColor = topStyle.backgroundColor

        view.addSubview(wave)

        topView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        botView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 0)
        wave.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: waveHeight)
        topView.label.transform = .identity
        botView.label.transform = labelAnimateInStartTransform
        topView.setStyle(topStyle)
        botView.setStyle(botStyle)
        botView.label.alpha = 0
        topView.label.alpha = 1

        view.bringSubviewToFront(navBarContainer)
    }

    private func setNextLayout() {
        self.topView.frame.origin.y -= screenHeight/2
        self.botView.frame = botEndFrame
        self.wave.frame = CGRect(x: 0, y: -waveHeight, width: screenWidth, height: waveHeight)

        self.topView.label.transform = labelAnimateOutEndTransform
        self.botView.label.transform = .identity

    }

    private var topStartFrame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    private var topEndFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 0)
    private var botEndFrame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    private var botStartFrame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 0)

    private func setInitialStretch(from stretches: [Stretch]) {
        let firstStretch = stretches[0]
        let secondStretch = stretches[1]

        topView.setStretch(firstStretch)
        botView.setStretch(secondStretch)
    }

    private func addSubviewsAndConstraints() {
        view.addSubview(navBarContainer)
        view.addSubview(topView)
        view.addSubview(botView)
        view.addSubview(wave)
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
