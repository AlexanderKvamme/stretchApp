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

    var style: ExerciseSlideStyle
    let textView = UITextView.make(.exercise)
    private var snapshots: [UIView] = []

    // MARK: - Initializers

    init(_ style: ExerciseSlideStyle) {
        self.style = style
        super.init(frame: screenFrame)

        setup()
        setStyle(style)
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }

    func setStyle(_ style: ExerciseSlideStyle) {
        self.style = style
        textView.textColor = style.foregroundColor
        backgroundColor = style.backgroundColor
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
        prepareAnimation()
    }

    func prepareAnimation() {
        textView.alpha = 1
        
        let snapshotRects = textView.getFramesForCharacters()
        snapshots = snapshotRects.map({ textView.wrappedSnap(at: $0)! })
        snapshots.forEach({ $0.tintColor = style.foregroundColor })
        snapshots.forEach({ $0.backgroundColor = .orange })
    }

    /// When the topview appears, it should immediately be set equal to the bottomviews endstate, for the transition to appear seamless
    /// The aniamtion is basically the botview, moving up to replace the topview, so the botview's endstate must be equal to the
    /// topView's beginning state
    func setAnimationEndState() {
//        textView.alpha = 1
    }
    
    func animateIn() {
        
        textView.alpha = 1

        setNeedsLayout()
        layoutIfNeeded()
        
        // Make snapshots and place them on top of the views
        let rects = textView.getFramesForCharacters()
        let verticalOffset = textView.contentOffset.y
        let slideInOffset = 40.0
        
        rects.enumerated().forEach { (i, selectionRect) in
            // Make and add snapshot
            let iv = textView.wrappedSnap(at: selectionRect)!
            iv.frame = selectionRect
            iv.frame.origin.y -= verticalOffset // Fit over origal text
            iv.transform = CGAffineTransform(translationX: 0, y: slideInOffset)
            addSubview(iv)
            
//            textView.alpha = 0
            
            // Animate
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, delay: Double(i)*0.02, options: .curveEaseInOut, animations: {
                    iv.transform = .identity
                    iv.alpha = 1
//                    iv.backgroundColor = .random()
                }, completion: { _ in
                    //                    iv.removeFromSuperview()
                    //                    UIView.animate(withDuration: 0.3, delay: 2, options: .curveEaseInOut, animations: {
                    //                        print("done")
                    //                        iv.transform = CGAffineTransform(translationX: 0, y: 0)
                    //                    })
                })
            }
        }
        
        textView.alpha = 0
    }

    func animateOut() {
        UIView.animate(withDuration: 0.8) {
            self.textView.alpha = 0
        }
    }
}
