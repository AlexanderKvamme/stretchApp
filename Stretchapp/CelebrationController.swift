//
//  CelebrationController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 02/05/2021.
//

import UIKit

final class CelebrationViewController: UIViewController {

    // MARK: - Initializers

    let counterLabel = UITextView.make(.exercise)
    let textView = UILabel.make(.exercise)
    let button = ButtonWithBackground("Nice!")
    private var snapshots: [UIView] = []
    var style: ExerciseSlideStyle = .light
    private var workout: Workout

    // MARK: - Properties

    init(workout: Workout) {
        self.workout = workout
        self.workout = Workout.gabos
        super.init(nibName: nil, bundle: nil)
        setup()
        addSubviewsAndConstraints()

        prepareAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidAppear(_ animated: Bool) {
        animateIn()
    }

    // MARK: - Methods

    private func setup() {
        view.backgroundColor = .background

        counterLabel.text = workout.duration.toString()
        counterLabel.textColor = .primaryContrast
        counterLabel.font = UIFont.round(.bold, 200)
        textView.font = UIFont.round(.regular, 24)
        textView.numberOfLines = 0

        // Hack
        DispatchQueue.main.async {
            self.textView.attributedText = self.makeCelebrationText()
        }

        button.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
    }

    private func addSubviewsAndConstraints() {
        [counterLabel, textView, button].forEach({ view.addSubview($0) })

        counterLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(240)
            make.bottom.equalTo(view.snp.centerY)
        }

        textView.snp.makeConstraints { (make) in
            make.top.equalTo(counterLabel.snp.bottom)
            make.left.right.equalToSuperview().inset(16)
        }

        button.snp.makeConstraints { (make) in
            make.left.right.equalTo(textView).inset(16)
            make.height.equalTo(58)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }

    @objc private func popToRoot() {
        dismiss(animated: false, completion: nil)
    }

    private func makeCelebrationText() -> NSAttributedString {
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.primaryContrast,
            .font: UIFont.round(.bold, 26)
        ]
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.primaryContrast,
            .font: UIFont.round(.bold, 20)
        ]
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.primaryContrast.withAlphaComponent(0.5),
            .font: UIFont.round(.regular, 20)
        ]
        let header = NSAttributedString(string: "How wonderful!\n", attributes: headerAttributes)
        let body1 = NSAttributedString(string: "You just finished a whopping total of " , attributes: bodyAttributes)
        let body2 = NSAttributedString(string: " of stretching out!", attributes: bodyAttributes)
        let boldStr = NSAttributedString(string: workout.duration.toString(), attributes: boldAttributes)
        let combination = NSMutableAttributedString()
        combination.append(header)
        combination.append(body1)
        combination.append(boldStr)
        combination.append(body2)
        return combination
    }

    func prepareAnimation() {
        view.setNeedsLayout()
        view.layoutIfNeeded()

        counterLabel.alpha = 1
        
        let snapshotRects = counterLabel.getFramesForCharacters()
        snapshots = snapshotRects.map({ counterLabel.wrappedSnap(at: $0)! })
        snapshots.forEach({ $0.tintColor = style.foregroundColor })
    }

    /// When the topview appears, it should immediately be set equal to the bottomviews endstate, for the transition to appear seamless
    /// The aniamtion is basically the botview, moving up to replace the topview, so the botview's endstate must be equal to the
    /// topView's beginning state
    func setAnimationEndState() {
        counterLabel.alpha = 1
    }

    func animateIn() {
        let animationDuration = 0.8
        let interItemDelayFactor  = 0.1

        counterLabel.alpha = 0

        snapshots.enumerated().forEach { (i, selectionRect) in
            // Make and add  snap
            let iv = snapshots[i]
            let offsetY = abs(counterLabel.contentOffset.y) + counterLabel.frame.minY
            iv.frame.origin.y += CGFloat(offsetY)
            iv.transform = CGAffineTransform(translationX: 0, y: 10)
            iv.alpha = 0

            iv.backgroundColor = .clear
            iv.clipsToBounds = false

            view.addSubview(iv)

            // Animate words up, overshooting position
            UIView.animate(withDuration: animationDuration*0.3, delay: Double(i)*interItemDelayFactor, options: .curveEaseInOut, animations: {
                iv.transform = CGAffineTransform(translationX: 0, y: -25)
                iv.alpha = 1
            }, completion: { _ in
                // Move down to final position
                UIView.animate(withDuration: animationDuration*0.7, delay: 0, options: .curveEaseInOut, animations: {
                    iv.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: {_ in
                    // Remove all snaphots and show the textView
                    if (i == self.snapshots.count-1) {
                        self.counterLabel.alpha = 1
                        self.snapshots.forEach({ $0.removeFromSuperview() })
                        self.snapshots.removeAll()
                    }
                })
            })
        }
    }

}

