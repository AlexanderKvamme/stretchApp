//
//  StretchingViewController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 20/03/2021.
//

import UIKit
import Lottie

class AnimatableButton: UIView {

    // MARK: - Properties

    let animationView: AnimationView!

    // MARK: - Initializers

    init(_ animation: String) {
        animationView = AnimationView.init(name: animation)

        super.init(frame: .zero)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {

    }

    private func addSubviewsAndConstraints() {
        addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}


class StretchNavBarContainer: UIView {

    let xButton = UIButton.make(.x)
    let xButtonAnimation = AnimatableButton("x-icon-data")
    let fractionView: FractionView

    init(frame: CGRect, color: UIColor) {
        fractionView = FractionView(color: color, topValue: 1, bottomValue: 0)

        super.init(frame: frame)

        xButton.tintColor = color
        fractionView.topLabel.textColor = color
        fractionView.bottomLabel.textColor = color

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {}

    private func addSubviewsAndConstraints() {
        addSubview(xButtonAnimation)
        addSubview(xButton)
        addSubview(fractionView)

        let buttonLeftAdjustmentForAnimation = 13

        xButtonAnimation.snp.makeConstraints { (make) in
            make.centerY.equalTo(fractionView.snp.centerY)
            make.left.equalTo(safeAreaLayoutGuide).offset(24)
            make.size.equalTo(26)
        }

        xButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(fractionView.snp.centerY)
            make.left.equalTo(safeAreaLayoutGuide).offset(buttonLeftAdjustmentForAnimation)
            make.size.equalTo(48)
        }

        fractionView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(8)
            make.right.equalTo(safeAreaLayoutGuide).inset(32)
            make.width.equalTo(64)
            make.height.equalTo(64)
        }
    }

    // API
    func animateInXButton() {
        xButtonAnimation.animationView.play()
        UIView.animate(withDuration: 0.1, delay: 0.5, options: UIView.AnimationOptions()) {
            self.xButton.alpha = 1
        }
    }

    func setColor(_ c: UIColor) {
        xButton.tintColor = c
        fractionView.diagonalLine.shapeLayer?.strokeColor = UIColor(hex: "7F7F7F").cgColor
        fractionView.topLabel.textColor = c
        fractionView.bottomLabel.textColor = c
    }
}

struct Stretch: Hashable, Codable {

    // MARK: - Properties

    let uuid: UUID
    let title: String
    let length: Duration

    // MARK: - Initializers

    init(title: String, length: Duration, uuid: UUID = UUID()) {
        self.title = title
        self.length = length
        self.uuid = uuid
    }

    static let dummy = Stretch(title: "This is a dummy stretch", length: Duration(amount: 30, type: .seconds))
    static let completion = Stretch(title: "Congratulations", length: Duration(amount: 30, type: .seconds))
    static let defaultLength = Duration(amount: 90, type: .seconds)
    static let debugLength = Duration(amount: 1, type: .seconds)
    static let favourites = [
        Stretch(title: "Hands folded behind back", length: defaultLength),
        Stretch(title: "Low squat", length: Self.defaultLength),
        Stretch(title: "Spinal twist (one side)", length: Self.defaultLength),
        Stretch(title: "Spinal twist (other side)", length: Self.defaultLength),
        Stretch(title: "Back bend", length: Self.defaultLength),
        Stretch(title: "Forward fold", length: Self.defaultLength),
        Stretch(title: "Pigeon pose (one side)", length: Self.defaultLength),
        Stretch(title: "Pigeon pose (other side)", length: Self.defaultLength),
        Stretch(title: "Quad bends", length: Self.defaultLength),
        Stretch(title: "Happy baby", length: Duration(amount: Self.defaultLength.amount, type: .seconds)),
        Stretch(title: "Back rollers", length: Duration(amount: Self.defaultLength.amount, type: .seconds)),
        Stretch.completion
    ]
    static let forDebugging = [
        Stretch(title: "Hands folded behind back", length: Self.debugLength),
        Stretch(title: "Low squat", length: Self.debugLength),
        Stretch(title: "Spinal twist (one side)", length: Self.debugLength),
        Stretch(title: "Back bend", length: Self.debugLength),
        Stretch(title: "Forward fold", length: Self.debugLength),
        Stretch(title: "Pigeon pose (one side)", length: Self.debugLength),
        Stretch(title: "Backflips", length: Self.debugLength),
        Stretch(title: "Swaggers", length: Self.debugLength),
        Stretch(title: "Jump masters", length: Self.debugLength),
        Stretch.completion
    ]

    enum CodingKeys: String, CodingKey {
        case uuid
        case title
        case length
    }
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
    let navBarOver = StretchNavBarContainer(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100), color: .primaryContrast)
    let navBarUnder = StretchNavBarContainer(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100), color: .background)
    let topView = ExerciceView(.light)
    let botView = ExerciceView(.dark)
    var wave = WaveView(frame: .zero)
    var waveMask = WaveView(frame: .zero, additionalHeight: screenHeight)
    let waveHeight: CGFloat = 80
    var currentAnimationIteration = 0
    var hasNextAnimation: Bool {
        return currentAnimationIteration < stretches.count-1
    }

    // MARK: - Initializers

    init(_ stretches: [Stretch]) {
        self.stretches = stretches

        super.init(nibName: nil, bundle: nil)

        navBarOver.fractionView.setFraction("1", String(stretches.count))
        navBarUnder.fractionView.setFraction("1", String(stretches.count))

        view.backgroundColor = .background
        setInitialStretch(from: stretches)
        addSubviewsAndConstraints()
        navBarOver.xButton.alpha = 0
        navBarUnder.xButton.alpha = 0

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navBarOver.fractionView.setFraction("1", String(stretches.count))
        navBarUnder.fractionView.setFraction("1", String(stretches.count))
        fadeInViews()
        playNextAnimation()
    }

    // MARK: - Methods

    private func setup() {
        navBarOver.xButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        navBarUnder.xButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
    }

    @objc private func exit() {
        dismiss(animated: false)
    }

    private func fadeInViews() {
        navBarOver.animateInXButton()
        navBarUnder.animateInXButton()
        navBarOver.fractionView.animate()
        navBarUnder.fractionView.animate()

        navBarOver.animateInXButton()
        navBarUnder.animateInXButton()
    }

    private func playNextAnimation() {
        resetViews()
        view.layoutIfNeeded()

        self.updateStretches()

        if hasNextAnimation {
            let stretchLength = stretches[currentAnimationIteration].length
            Audioplayer.play(.newStretch)
            navBarOver.fractionView.setFraction(String(currentAnimationIteration+2), String(stretches.count))
            navBarUnder.fractionView.setFraction(String(currentAnimationIteration+1), String(stretches.count))

            let isMinuteStretch = stretchLength.type == .minutes
            let animationDuration = stretchLength.amount * (isMinuteStretch ? 60 : 1)
            UIView.animate(withDuration: TimeInterval(animationDuration)) {
                self.setNextLayout()
                self.botView.label.alpha = 1
                self.view.layoutIfNeeded()
                self.waveMask.layoutIfNeeded()
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
        let sheetIsLight = currentAnimationIteration%2 == 0
        let topStyle: ExerciceView.ExerciseSlideStyle = sheetIsLight ? .light : .dark
        let botStyle: ExerciceView.ExerciseSlideStyle = sheetIsLight ? .dark : .light

        wave.color = topStyle.foregroundColor
        wave.backgroundColor = topStyle.backgroundColor
        view.addSubview(wave)

        topView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        botView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 0)
        wave.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: waveHeight)
        waveMask.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: waveHeight)

        topView.label.transform = .identity
        botView.label.transform = labelAnimateInStartTransform
        topView.setStyle(topStyle)
        botView.setStyle(botStyle)
        botView.label.alpha = 0
        topView.label.alpha = 1

        navBarOver.setColor(topStyle.backgroundColor)
        navBarUnder.setColor(topStyle.foregroundColor)
        view.bringSubviewToFront(navBarUnder)
        view.bringSubviewToFront(navBarOver)

        // Mask hides the top bar, and reveals the one undeneath
        navBarOver.mask = waveMask
    }

    private func setNextLayout() {
        self.topView.frame.origin.y -= screenHeight/2
        self.botView.frame = botEndFrame
        self.wave.frame = CGRect(x: 0, y: -waveHeight, width: screenWidth, height: waveHeight)
        self.waveMask.frame = CGRect(x: 0, y: -waveHeight, width: screenWidth, height: waveHeight)

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
        view.addSubview(topView)
        view.addSubview(botView)
        view.addSubview(wave)
        view.addSubview(navBarUnder)
        view.addSubview(navBarOver)
    }
}

