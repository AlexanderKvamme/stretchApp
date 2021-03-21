//
//  AnimatableDiagonalView.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 21/03/2021.
//

import UIKit


class AnimatableDiagonalView: UIView {

    weak var shapeLayer: CAShapeLayer?

    func test() {
        self.shapeLayer?.removeFromSuperlayer()

        let path = UIBezierPath()
        let frame = self.frame
        path.move(to: CGPoint(x: 0, y: frame.height))
        path.addLine(to: CGPoint(x: frame.width, y: 0))

        // create shape layer for that path
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.path = path.cgPath
        shapeLayer.lineCap = .round

        // animate
        layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 0.3
        shapeLayer.add(animation, forKey: "MyAnimation")

        self.shapeLayer = shapeLayer
    }
}
