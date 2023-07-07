//
//  TestViewController.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 17/04/2021.
//

import UIKit


class TestViewController: UIViewController {

    // MARK: - Properties

    let exerciseView = ExerciceView(.dark)

    // MARK: - Methods

    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .primaryContrast
        exerciseView.frame = view.frame
        view.addSubview(exerciseView)

        exerciseView.setStretch(Stretch.dummy)
//        topView.animateIn()
        test()
    }
    
    
    
    
    func test() {
        // Make snapshots and place them on top of the views
        let textView = exerciseView.textView
        let rects = textView.getFramesForCharacters()
        
        rects.enumerated().forEach { (i, selectionRect) in
            // Make and add snap
            let iv = textView.wrappedSnap(at: selectionRect)!
            iv.frame = selectionRect
            iv.transform = CGAffineTransform(translationX: 0, y: 40)
            iv.backgroundColor = .random()
            view.addSubview(iv)
            
            // Animate
            //            DispatchQueue.main.async {
            //                UIView.animate(withDuration: 0.4, delay: Double(i)*0.075, options: .curveEaseInOut, animations: {
            //                    iv.transform = CGAffineTransform(translationX: 0, y: 0)
            //                    iv.alpha = 1
            //                }, completion: { _ in
            //                    //                    iv.removeFromSuperview()
            //                    //                    UIView.animate(withDuration: 0.3, delay: 2, options: .curveEaseInOut, animations: {
            //                    //                        print("done")
            //                    //                        iv.transform = CGAffineTransform(translationX: 0, y: 0)
            //                    //                    })
            //                })
            //            }
        }
        
        textView.alpha = 0
    }
}

