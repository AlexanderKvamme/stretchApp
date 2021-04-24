//
//  ExerciseWaveView.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 21/03/2021.
//

import UIKit

enum ExerciseSlideStyle {
    case light
    case dark

    var foregroundColor: UIColor {
        if self == .light {
            return UIColor.primaryContrast
        } else {
            return UIColor.background
        }
    }

    var backgroundColor: UIColor {
        if self == .light {
            return UIColor.background
        } else {
            return UIColor.primaryContrast
        }
    }
}



final class ExerciceView: UIView {

    // MARK: - Properties

    let textView = UITextView.make(.exercise)
    private var snapshots: [UIImageView] = []

    // MARK: - Initializers

    init(_ style: ExerciseSlideStyle) {
        super.init(frame: screenFrame)

        setup(style)
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setStyle(_ style: ExerciseSlideStyle) {
        textView.textColor = style.foregroundColor
        backgroundColor = style.backgroundColor
    }

    private func setup(_ style: ExerciseSlideStyle) {
        setStyle(style)
        textView.text = "This is a temporary exercise"
        textView.backgroundColor = .clear
        textView.backgroundColor = .purple
    }

    private func addSubviewsAndConstraints() {
        addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: API

    func setStretch(_ stretch: Stretch) {
        textView.text = stretch.title
        setNeedsLayout()
        layoutIfNeeded()
        prepareAnimation()
        textView.alpha = 0
    }

    func prepareAnimation() {
        textView.alpha = 1
        let snapshotRects = textView.getFramesForWords()
        snapshots = snapshotRects.map({ textView.wrappedSnap(at: $0)! })
    }

    /// When the topview appears, it should immediately be set equal to the bottomviews endstate, for the transition to appear seamless
    /// The aniamtion is basically the botview, moving up to replace the topview, so the botview's endstate must be equal to the
    /// topView's beginning state
    func setAnimationEndState() {
        textView.alpha = 1
    }

    func animateIn() {
        let animationDuration = 2.0
        let interItemDelayFactor = 0.075

        textView.alpha = 0

        snapshots.enumerated().forEach { (i, selectionRect) in
            // Make and add snap
            let iv = snapshots[i]
            let offsetY = abs(textView.contentOffset.y)
            iv.frame.origin.y += CGFloat(offsetY)
            iv.transform = CGAffineTransform(translationX: 0, y: 100)
            addSubview(iv)

            // Animate words up, overshooting position
            UIView.animate(withDuration: animationDuration*0.4, delay: Double(i)*interItemDelayFactor, options: .curveEaseInOut, animations: {
                iv.transform = CGAffineTransform(translationX: 0, y: -20)
            }, completion: { _ in
                // Move down to final position
                UIView.animate(withDuration: animationDuration*0.6, delay: 0, options: .curveEaseInOut, animations: {
                    iv.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: {_ in
                    // Remove all snaphots and show the textView
                    if (i == self.snapshots.count-1) {
                        self.textView.alpha = 1
                        self.snapshots.forEach({ $0.removeFromSuperview() })
                    }
                })
            })
        }
    }

    func animateOut() {
        UIView.animate(withDuration: 0.8) {
            self.textView.alpha = 0
        }
    }
}
