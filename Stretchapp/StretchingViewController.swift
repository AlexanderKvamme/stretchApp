//
//  StretchingViewController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 20/03/2021.
//

import UIKit



class StretchingViewController: UIViewController {

    // MARK: - Properties

    var workout: Workout
    let navBarOver = StretchNavBarContainer(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100), color: .primaryContrast)
    let navBarUnder = StretchNavBarContainer(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100), color: .background)
    let topView = ExerciseView(.light)
    let botView = ExerciseView(.dark)
    var wave = WaveView(frame: .zero)
    var waveMask = WaveView(frame: .zero, additionalHeight: screenHeight)
    let waveHeight: CGFloat = 80
    var currentAnimationIteration = 0
    var hasNextAnimation: Bool {
        return currentAnimationIteration < workout.stretches.count-1
    }

    // MARK: - Initializers

    init(_ workout: Workout) {
        self.workout = workout

        super.init(nibName: nil, bundle: nil)

        setInitialStretch(from: workout.stretches)
        navBarOver.xButton.alpha = 0
        navBarUnder.xButton.alpha = 0

        addGestureRecognizers()
        addSubviewsAndConstraints()
        
        topView.prepareAnimation()
        botView.prepareAnimation()
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

    private func addGestureRecognizers() {
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
    }

    private func playNextAnimation() {
        let isFirstAnimation = currentAnimationIteration == 0
        resetViews()

        updateStretches()

        if hasNextAnimation {
            let nextStretch = workout.stretches[currentAnimationIteration]
            let stretchLength = nextStretch.duration
            Audioplayer.play(.newStretch)
            navBarOver.fractionView.setFraction(String(currentAnimationIteration+2), String(workout.stretches.count-1))
            navBarUnder.fractionView.setFraction(String(currentAnimationIteration+1), String(workout.stretches.count-1))

            let isMinuteStretch = stretchLength.type == .minutes
            var animationDuration = stretchLength.amount * (isMinuteStretch ? 60 : 1)
            animationDuration = animationDuration * (nextStretch.isTwoSided ? 2 : 1)
            
            if isFirstAnimation {
                topView.animateIn()
            } else {
                topView.animateIn(skipToEnd: true)
            }

            self.view.layoutIfNeeded()
            self.waveMask.layoutIfNeeded()

            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(animationDuration/2)) {
                self.topView.animateOut()
                self.botView.animateIn()

                if nextStretch.isTwoSided {
                    Audioplayer.play(.newStretch)
                }
            }

            let duration = TimeInterval(animationDuration)
            UIView.animate(withDuration: duration) {
                self.setNextLayout()
                self.view.layoutIfNeeded()
                self.waveMask.layoutIfNeeded()
            } completion: { (_) in
                self.currentAnimationIteration += 1
                self.playNextAnimation()
            }

            // The final countdown
            // FIXME: Move out of here
            let isLastAnimation = currentAnimationIteration == workout.stretches.count-2
            if isLastAnimation {
                self.botView.textView.font = UIFont.round(.bold, 40)

                DispatchQueue.main.asyncAfter(deadline: .now() + duration-4) {
                    self.botView.textView.text = "3"
                    self.botView.textView.font = UIFont.round(DINWeights.bold, 40)
                    self.botView.textView.layoutIfNeeded()
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + duration-3) {
                    self.botView.textView.text = "2"
                    self.botView.textView.font = UIFont.round(DINWeights.bold, 60)
                    self.botView.textView.layoutIfNeeded()
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + duration-2) {
                    self.botView.textView.text = "1"
                    self.botView.textView.font = UIFont.round(DINWeights.bold, 100)
                    self.botView.textView.layoutIfNeeded()
                }
            }
        } else {
            presentCelebrationScreen()
        }
    }

    private func updateStretches() {
        topView.setStretch(workout.stretches[currentAnimationIteration])
        topView.prepareAnimation()

        if currentAnimationIteration+1 < workout.stretches.count {
            botView.setStretch(workout.stretches[currentAnimationIteration+1])
            botView.prepareAnimation()
        }
    }

    private func presentCelebrationScreen() {
        Audioplayer.play(.congratulations)

        let celebrationController = CelebrationViewController(workout: workout)
        celebrationController.modalPresentationStyle = .fullScreen
        weak var presentingViewController = self.presentingViewController

        dismiss(animated: false, completion: {
            presentingViewController?.present(celebrationController, animated: false, completion: nil)
        })
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
        topView.frame = view.frame
        botView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
        view.addSubview(topView)
        view.addSubview(botView)
        view.addSubview(wave)
        view.addSubview(navBarUnder)
        view.addSubview(navBarOver)
    }
}

