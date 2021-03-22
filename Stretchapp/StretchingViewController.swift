//
//  StretchingViewController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 20/03/2021.
//

import UIKit
import WXWaveView


class WaveContainer: UIView {
    let waveView = WXWaveView()
    let waveColor: UIColor
    let hackView = UIView()

    init(waveColor: UIColor) {
        self.waveColor = waveColor
        super.init(frame: .zero)

        setup()
        addSubviewsAndConstraints()
        clipsToBounds = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        hackView.backgroundColor = waveColor

        waveView.waveColor = waveColor
        waveView.waveTime = 0
        waveView.angularSpeed = 1
        waveView.waveSpeed = 1
        waveView.wave()
    }

    private func addSubviewsAndConstraints() {
        addSubview(hackView)
        addSubview(waveView)
        
        waveView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.centerY)
            make.left.bottom.right.equalToSuperview()
        }

        clipsToBounds = false
        hackView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(snp.bottom).offset(-1)
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
    let fractionView = SetFractionView(topValue: 2, bottomValue: 5)
    let xButton = UIButton.make(.x)
    let topView = ExerciceWaveView(.light)
    let botView = ExerciceWaveView(.dark)
    var waveContainer = WaveContainer(waveColor: .purple)
    let waveHeight: CGFloat = 80
    var currentAnimationIteration = 0
    var hasNextAnimation: Bool {
        return currentAnimationIteration < stretches.count-1
    }

    // MARK: - Initializers

    init(_ stretches: [Stretch]) {
        self.stretches = stretches

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

        fractionView.animate()
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
        waveContainer.removeFromSuperview()

        let topStyle: ExerciceWaveView.ExerciseSlideStyle = currentAnimationIteration%2 == 0 ? .light : .dark
        let botStyle: ExerciceWaveView.ExerciseSlideStyle = currentAnimationIteration%2 == 0 ? .dark : .light

        waveContainer = WaveContainer(waveColor: topStyle.foregroundColor)
        waveContainer.backgroundColor = topStyle.backgroundColor

        view.addSubview(waveContainer)

        topView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        botView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 0)
        waveContainer.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: waveHeight)
        topView.label.transform = .identity
        botView.label.transform = labelAnimateInStartTransform
        topView.setStyle(topStyle)
        botView.setStyle(botStyle)
        botView.label.alpha = 0
    }

    private func setNextLayout() {
        self.topView.frame.origin.y -= screenHeight/2
        self.botView.frame = botEndFrame
        self.waveContainer.frame = CGRect(x: 0, y: -waveHeight, width: screenWidth, height: waveHeight)

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
        view.addSubview(xButton)
        view.addSubview(fractionView)
        view.addSubview(topView)
        view.addSubview(botView)
        view.addSubview(waveContainer)

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
