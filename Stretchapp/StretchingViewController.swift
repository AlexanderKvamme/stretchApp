//
//  StretchingViewController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 20/03/2021.
//

import UIKit



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
//        topView.animateIn()
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
        topView.prepareAnimation()
        botView.prepareAnimation()
        view.layoutIfNeeded()

        self.updateStretches()

//        botView.animateIn()

        if hasNextAnimation {
            let stretchLength = stretches[currentAnimationIteration].length
//            Audioplayer.play(.newStretch)
            navBarOver.fractionView.setFraction(String(currentAnimationIteration+2), String(stretches.count))
            navBarUnder.fractionView.setFraction(String(currentAnimationIteration+1), String(stretches.count))

            let isMinuteStretch = stretchLength.type == .minutes
            let animationDuration = stretchLength.amount * (isMinuteStretch ? 60 : 1)

            topView.animateIn()
//            topView.prepareAnimation()
//            botView.alpha = 0.5
//            topView.backgroundColor = .green
//            botView.backgroundColor = .purple
//            view.backgroundColor = .cyan

//            self.setNextLayout()
//                self.botView.textView.alpha = 1
            self.view.layoutIfNeeded()
            self.waveMask.layoutIfNeeded()

            UIView.animate(withDuration: TimeInterval(animationDuration)) {
                self.setNextLayout()
                self.view.layoutIfNeeded()
                self.waveMask.layoutIfNeeded()
            } completion: { (_) in
                print("bam animation outer done")
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

        topView.textView.transform = .identity
        botView.textView.transform = .identity
//        botView.textView.transform = labelAnimateInStartTransform
        topView.setStyle(topStyle)
        botView.setStyle(botStyle)
//        botView.textView.alpha = 0
//        topView.textView.alpha = 1

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

//        self.topView.textView.transform = labelAnimateOutEndTransform
        self.topView.textView.transform = .identity
        self.botView.textView.transform = .identity
    }

    private func setInitialStretch(from stretches: [Stretch]) {
        let firstStretch = stretches[0]
        let secondStretch = stretches[1]

        topView.setStretch(firstStretch)
        print("top: ", firstStretch.title)
        print("bot: ", secondStretch.title)
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

//        override func viewDidAppear(_ animated: Bool) {
//            topView.frame = view.frame
//            view.addSubview(topView)
//
//            topView.setStretch(Stretch.dummy)
//            topView.layoutIfNeeded()
//
//            topView.alpha = 0
//            view.backgroundColor = .primaryContrast
//            testAnimateIn(topView.label)
//        }
//
//        func testAnimateIn(_ textView: UITextView) {
//            let rects = textView.getFramesForWords()
//            rects.enumerated().forEach { (i, selectionRect) in
//                // Make and add snap
//                let iv = textView.wrappedSnap(at: selectionRect)!
//                let offsetY = abs(textView.contentOffset.y)
//                iv.frame = selectionRect
//                iv.frame.origin.y += CGFloat(offsetY)
//                iv.transform = CGAffineTransform(translationX: 0, y: 40)
//                iv.alpha = 0
//                view.addSubview(iv)
//
//                // Animate
//                UIView.animate(withDuration: 0.4, delay: Double(i)*0.075, options: .curveEaseInOut, animations: {
//                    iv.transform = CGAffineTransform(translationX: 0, y: 0)
//                    iv.alpha = 1
//                }, completion: { _ in
//    //                iv.removeFromSuperview()
//
//                    UIView.animate(withDuration: 0.3, delay: 2, options: .curveEaseInOut, animations: {
//                        iv.transform = CGAffineTransform(translationX: 0, y: -10)
//                        iv.alpha = 0
//                    })
//                })
//            }
//        }
