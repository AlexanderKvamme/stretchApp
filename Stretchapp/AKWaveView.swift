//
//  AKWaveView.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 25/03/2021.
//

import UIKit
import Combine
import Foundation


class WaveView: UIView {
    let fillLayer = CAShapeLayer()
    var displayLink: CADisplayLink!
    let color: UIColor
    let additionalHeight: CGFloat

    init(frame: CGRect, color: UIColor = .green, additionalHeight: CGFloat = 0) {
        self.additionalHeight = additionalHeight
        self.color = color
        super.init(frame: frame)

        displayLink = CADisplayLink(target: self, selector: #selector(fireTimer))
        displayLink.add(to: .current, forMode: .common)

        layer.addSublayer(fillLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func fireTimer() {
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        let amplitude = frame.height/2
        let time = NSDate.timeIntervalSinceReferenceDate
        let path = UIBezierPath()
        let width = CGFloat(rect.width)
        let height = CGFloat(rect.height)
        let midHeight = height / 2
        let frequency: CGFloat = 3
        let waveLength = width/frequency

        func getY(x: CGFloat) -> CGFloat {
            let phase = CGFloat(time).truncatingRemainder(dividingBy: width)
            let relativeX = x/waveLength
            let sine = sin(relativeX - phase)
            return midHeight+sine*amplitude
        }

        // start at the left center
        let startY = getY(x: 0)
        path.move(to: CGPoint(x: 0, y: startY))

        // now count across individual horizontal points one by one
        for x in stride(from: 0, through: width, by: 1) {
//            // find our current position relative to the wavelength
//            let relativeX: CGFloat = x / wavelength
//            let distanceFromMidWidth = x - midWidth
//            // bring that into the range of -1 to 1
//            let normalDistance = oneOverMidWidth * distanceFromMidWidth
//            let parabola = -(normalDistance * normalDistance) + 1
//            // calculate the sine of that position, adding our phase offset
//            let sine = sin(relativeX + phase)
//            // multiply that sine by our strength to determine final offset, then move it down to the middle of our view
//            let y = parabola * amplitude * sine + midHeight

            let y = getY(x: x)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: width, y: height+1+additionalHeight))
        path.addLine(to: CGPoint(x: 0, y: height+1+additionalHeight))
        clipsToBounds = false
        path.close()

        fillLayer.path = path.cgPath
        fillLayer.fillColor = color.cgColor
    }
}
