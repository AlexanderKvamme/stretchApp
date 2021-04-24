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

    func prepareAnimation() {
//        if let f = superview?.frame {
//            frame = f
//        }

        let snapshotRects = textView.getFramesForWords()
        snapshots = snapshotRects.map({ textView.wrappedSnap(at: $0)! })
//            let iv = textView.wrappedSnap(at: selectionRect)!
    }

    func animateIn() {
        let animationDuration = 2.0
        let interItemDelayFactor = 0.075
        let endTime = animationDuration + Double(snapshots.count) * interItemDelayFactor

        textView.alpha = 0
        UIView.animate(withDuration: endTime, delay: endTime, options: UIView.AnimationOptions.init()) {
            // Do nothing
        } completion: { (finished) in
//            self.textView.alpha = 0
//            self.textView.alpha = 1
        }

//        fatalError()

        print("content: ", textView.contentInset)
        print("content: ", textView.contentOffset)
        print("content: ", textView.contentSize)

        snapshots.enumerated().forEach { (i, selectionRect) in
            // Make and add snap
            let iv = snapshots[i]
            let offsetY = abs(textView.contentOffset.y)
            iv.frame.origin.y += CGFloat(offsetY)
            iv.transform = CGAffineTransform(translationX: 0, y: 40)
            addSubview(iv)

            // Animate
            UIView.animate(withDuration: animationDuration*0.4, delay: Double(i)*interItemDelayFactor, options: .curveEaseInOut, animations: {
                iv.transform = CGAffineTransform(translationX: 0, y: -20)
            }, completion: { _ in
                // Move to final position
                UIView.animate(withDuration: animationDuration*0.6, delay: 0, options: .curveEaseInOut, animations: {
                    iv.transform = CGAffineTransform(translationX: 0, y: 0)
//                    iv.alpha = 0
//                    iv.removeFromSuperview()
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
}
