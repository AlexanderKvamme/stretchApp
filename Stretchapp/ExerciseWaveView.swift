//
//  ExerciseWaveView.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 21/03/2021.
//

import UIKit

enum LogType: String {
    case start = "START"
    case end   = "END"
}

final class TimeLogger {
    
    // MARK: - Properties
    
    private static var logDict = [String: Date]()
    
    // MARK: - Methods
    
    static func log(_ type: LogType, title: String) {
        let key = "\(title)"
        
        switch type {
        case .start:
            logDict[key] = Date()
        case .end:
            let endTime = Date()
            guard let startTime = logDict[key] else {
                print("❌ Could not log end of non-existant network call")
                return
            }
            let duration = endTime.timeIntervalSince1970-startTime.timeIntervalSince1970
            print("⏰ \(key) timed to \(duration.rounded(toPlaces: 1)) seconds.")
            logDict.removeValue(forKey: key)
        }
    }
    
}

private extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

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

extension UIView {
    func copyView<T: UIView>() -> T {
        let copy = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
        copy.accessibilityIdentifier = accessibilityIdentifier
        return copy
    }
}

final class ExerciseView: UIView {

    // MARK: - Properties

    var style: ExerciseSlideStyle
    let textView = UITextView.make(.exercise)
    private var snapshots: [UITextView] = []

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
        textView.backgroundColor = .clear
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
    }

    func reset() {
        snapshots.forEach({ $0.removeFromSuperview() })
        snapshots = []
    }

    func prepareAnimation() {
        reset()
        let rects = textView.getFramesForCharacters()
        rects.enumerated().forEach { (i, selectionRect) in
            // Make and add snapshot
            let tv = UITextView.make(.exercise)
            let entireText = self.textView.text!
            let idx = entireText.index(entireText.startIndex, offsetBy: i)
            let char = entireText[idx]
            tv.text.insert(char, at: entireText.startIndex)
            tv.frame = selectionRect
            tv.textColor = style.foregroundColor
            snapshots.append(tv)
        }
        textView.alpha = 0
    }
    
    func animateIn(skipToEnd: Bool = false) {
        let verticalOffset = textView.contentOffset.y
        let slideInOffset = 16.0

        // Use stored snapshots
        snapshots.enumerated().forEach { (i, iv) in
            // Make and add snapshot
            iv.backgroundColor = .clear
            iv.frame.origin.y -= verticalOffset
            iv.transform = CGAffineTransform(translationX: 0, y: slideInOffset)
            addSubview(iv)
            
            if skipToEnd {
                iv.transform = .identity
                iv.transform = iv.transform.translatedBy(x: 0, y: -safeAreaInsets.top)
                iv.alpha = 1
            } else {
                // Animate words up, overshooting position
                let animationDuration = 0.8
                let interItemDelayFactor = 0.025
                UIView.animate(withDuration: animationDuration*0.3, delay: Double(i)*interItemDelayFactor, options: .curveEaseInOut, animations: {
                    iv.transform = CGAffineTransform(translationX: 0, y: -15)
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

    func animateOut() {
        snapshots.enumerated().forEach { (i, snapshot) in
            UIView.animate(withDuration: 0.5, delay: Double(i)*0.03, options: .curveEaseInOut, animations: {
                snapshot.transform = snapshot.transform.translatedBy(x: 0, y: -10)
                snapshot.alpha = 0
            })
        }
    }
}
