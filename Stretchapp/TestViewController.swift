//
//  TestViewController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 17/04/2021.
//

import UIKit



class TestViewController: UIViewController {

    // MARK: - Properties

    let topView = ExerciceView(.dark)

    // MARK: - Methods

    override func viewDidAppear(_ animated: Bool) {
        topView.frame = view.frame
        view.addSubview(topView)

        
        topView.layoutIfNeeded()

//        topView.alpha = 0
        view.backgroundColor = .primaryContrast
//        testAnimateIn(topView.textView)

//        topView.alpha = 0
        topView.animateIn()
    }

//    func testAnimateIn(_ textView: UITextView) {
//        let rects = textView.getFramesForWords()
//        rects.enumerated().forEach { (i, selectionRect) in
//            // Make and add snap
//            let iv = textView.wrappedSnap(at: selectionRect)!
//            let offsetY = abs(textView.contentOffset.y)
//            iv.frame = selectionRect
//            iv.frame.origin.y += CGFloat(offsetY)
//            iv.transform = CGAffineTransform(translationX: 0, y: 40)
//            iv.alpha = 0
//            view.addSubview(iv)
//
//            // Animate
//            UIView.animate(withDuration: 0.4, delay: Double(i)*0.075, options: .curveEaseInOut, animations: {
//                iv.transform = CGAffineTransform(translationX: 0, y: 0)
//                iv.alpha = 1
//            }, completion: { _ in
////                iv.removeFromSuperview()
//
//                UIView.animate(withDuration: 0.3, delay: 2, options: .curveEaseInOut, animations: {
//                    iv.transform = CGAffineTransform(translationX: 0, y: -10)
//                    iv.alpha = 0
//                })
//            })
//        }
//    }
}

