//
//  AnimatableDiagonalView.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 21/03/2021.
//

import UIKit


class AnimatableDiagonalView: UIView {

    weak var shapeLayer: CAShapeLayer?
    var color: CGColor

    init(_ color: UIColor) {
        self.color = color.cgColor

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func drawLineAnimation() {
        self.shapeLayer?.removeFromSuperlayer()

        let path = UIBezierPath()
        let frame = self.frame
        let from = CGPoint(x: 0, y: frame.height)
        let to = CGPoint(x: frame.width, y: 0)
        path.move(to: from)
        path.addLine(to: to)

        // create shape layer for that path
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color
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
