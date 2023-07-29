//
//  CelebrationController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 02/05/2021.
//

import UIKit
import AKKIT

final class CelebrationViewController: UIViewController {

    // MARK: - Initializers

    let header = UITextView.make(.exercise)
    let textView = UILabel.make(.exercise)
    let button = ButtonWithBackground("Nice!")
    private var snapshots: [UIView] = []
    var style: ExerciseSlideStyle = .light
    private var workout: Workout
    
    let confettiView = ConfettiView()

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
        confettiView.startConfetti()
    }

    // MARK: - Methods

    private func setup() {
        view.backgroundColor = .background
        modalPresentationStyle = .fullScreen

        header.text = workout.duration.toString()
        header.textColor = .primaryContrast
        header.font = UIFont.round(.bold, 140)
        textView.font = UIFont.round(.regular, 24)
        textView.numberOfLines = 0
        confettiView.frame = view.frame

        // Hack
        DispatchQueue.main.async {
            self.textView.attributedText = self.makeCelebrationText()
        }

        button.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
    }

    private func addSubviewsAndConstraints() {
        [header, textView, button, confettiView].forEach({ view.addSubview($0) })

        header.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(240)
            make.bottom.equalTo(view.snp.centerY)
        }
        
        header.backgroundColor = .clear

        textView.snp.makeConstraints { (make) in
            make.top.equalTo(header.snp.bottom)
            make.left.right.equalToSuperview().inset(16)
        }

        button.snp.makeConstraints { (make) in
            make.left.right.equalTo(textView).inset(16)
            make.height.equalTo(58)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }

    @objc private func popToRoot() {
//        dismiss(animated: false, completion: nil)
        print("tryna POP")
//        navigationController?.dismiss(animated: false)
        navigationController?.popToRootViewController(animated: true)
//        dismiss(animated: false)
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
        let rects = header.getFramesForCharacters(in: view)
        
        rects.enumerated().forEach { (i, selectionRect) in
            // Make and add snapshot
            let tv = header.copyView() as! UITextView
            let entireText = self.header.text!
            let idx = entireText.index(entireText.startIndex, offsetBy: i)
            let char = entireText[idx]
            tv.text.insert(char, at: entireText.startIndex)
            tv.frame = selectionRect
            tv.textColor = style.foregroundColor
            snapshots.append(tv)
        }
        
        header.alpha = 0
    }
    
    func getVerticalInsetForCenterAlignment(textView: UITextView) -> CGFloat {
        // Get the content size of the text in the UITextView
        let textHeight = textView.contentSize.height
        
        // Get the height of the UITextView
        let textViewHeight = textView.bounds.size.height
        
        // Calculate the vertical inset
        let verticalInset = (textViewHeight - textHeight) / 2.0
        
        return verticalInset
    }
    
    func animateIn(skipToEnd: Bool = false) {
        let slideInOffset = 40.0
        
        // Use stored snapshots
        snapshots.enumerated().forEach { (i, iv) in
            // Make and add snapshot
            iv.backgroundColor = .clear
            iv.transform = CGAffineTransform(translationX: 0, y: slideInOffset)
            view.addSubview(iv)
            
            if skipToEnd {
                iv.transform = .identity
                iv.alpha = 1
            } else {
                // Animate words up, overshooting position
                let animationDuration = 0.8
                let interItemDelayFactor = 0.025
                UIView.animate(withDuration: animationDuration*0.3, delay: Double(i)*interItemDelayFactor, options: .curveEaseInOut, animations: {
                    iv.transform = CGAffineTransform(translationX: 0, y: -25)
                    iv.alpha = 1
                }, completion: { _ in
                    // Move down to final position
                    UIView.animate(withDuration: animationDuration*0.7, delay: 0, options: .curveEaseInOut, animations: {
                        iv.transform = .identity
                    }, completion: {_ in
                        // No need to do anything
                    })
                })

            }
        }
    }

}

