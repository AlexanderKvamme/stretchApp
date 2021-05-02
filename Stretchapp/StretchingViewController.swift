//
//  StretchingViewController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 20/03/2021.
//

import UIKit



class StretchingViewController: UIViewController {

    // MARK: - Properties

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

        view.backgroundColor = .background
        setInitialStretch(from: stretches)
        navBarOver.xButton.alpha = 0
        navBarUnder.xButton.alpha = 0

        setup()
        addSubviewsAndConstraints()
        topView.backgroundColor = .background
        botView.backgroundColor = .background
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

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
        let isFirstAnimation = currentAnimationIteration == 0
        resetViews()

        topView.prepareAnimation()
        botView.prepareAnimation()

        view.layoutIfNeeded()

        self.updateStretches()

        if hasNextAnimation {
            let nextStretch = stretches[currentAnimationIteration]
            let stretchLength = nextStretch.length
            Audioplayer.play(.newStretch)
            navBarOver.fractionView.setFraction(String(currentAnimationIteration+2), String(stretches.count-1))
            navBarUnder.fractionView.setFraction(String(currentAnimationIteration+1), String(stretches.count-1))

            let isMinuteStretch = stretchLength.type == .minutes
            var animationDuration = stretchLength.amount * (isMinuteStretch ? 60 : 1)
            animationDuration = animationDuration * (nextStretch.isTwoSided ? 2 : 1)

            if isFirstAnimation {
                topView.textView.alpha = 0
                topView.animateIn()
            } else {
                topView.textView.alpha = 1
                topView.setAnimationEndState()
            }

            self.view.layoutIfNeeded()
            self.waveMask.layoutIfNeeded()

            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(animationDuration/2)) {
                // your code here
                self.topView.animateOut()
                self.botView.animateIn()

                if nextStretch.isTwoSided {
                    Audioplayer.play(.newStretch)
                }
            }

            UIView.animate(withDuration: TimeInterval(animationDuration)) {
                self.setNextLayout()
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
        let topStyle: ExerciseSlideStyle = sheetIsLight ? .light : .dark
        let botStyle: ExerciseSlideStyle = sheetIsLight ? .dark : .light

        wave.color = topStyle.foregroundColor
        wave.backgroundColor = topStyle.backgroundColor
        view.addSubview(wave)

        topView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        botView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
        wave.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: waveHeight)
        waveMask.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: waveHeight)

        topView.setStyle(topStyle)
        botView.setStyle(botStyle)

        navBarOver.setColor(topStyle.backgroundColor)
        navBarUnder.setColor(topStyle.foregroundColor)
        view.bringSubviewToFront(navBarUnder)
        view.bringSubviewToFront(navBarOver)

        // Mask hides the top bar, and reveals the one undeneath
        navBarOver.mask = waveMask

        topView.layoutIfNeeded()
        botView.layoutIfNeeded()
    }

    private var topStartFrame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    private var botStartFrame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 0)
    private var topEndFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 0)
    private var botEndFrame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)

    private func setNextLayout() {
        self.topView.frame.origin.y -= screenHeight/2
        self.botView.frame = botEndFrame
        self.wave.frame = CGRect(x: 0, y: -waveHeight, width: screenWidth, height: waveHeight)
        self.waveMask.frame = CGRect(x: 0, y: -waveHeight, width: screenWidth, height: waveHeight)
    }

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

