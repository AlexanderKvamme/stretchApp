//
//  Superstepper.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 01/04/2021.
//

import UIKit
// Heavily inspired by: https://dribbble.com/shots/5586623-Stepper-IX

final class SuperStepper: UIButton, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    // MARK: - Properties

    let data: [String]
    var dataViews = [StepperDataView]()
    var dataViewStack = UIStackView()
    let hScroll = UIScrollView()

    // MARK: - Initializers

    init(frame: CGRect, options: [String]) {
        self.data = options

        super.init(frame: frame)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setup() {
        let dataViewSize = CGRect(x: 0, y: 0, width: frame.width/3, height: frame.height)
        dataViews = data.map({ return StepperDataView(frame: dataViewSize, value: $0) })

        dataViews.forEach({ dataViewStack.addArrangedSubview($0) })
        dataViewStack.axis = .horizontal
        dataViewStack.distribution = .fillEqually
        let totalSpacing = CGFloat(dataViews.count - 1) * dataViewStack.spacing
        let contentSize = CGSize(width: dataViewSize.width*CGFloat(dataViews.count) + totalSpacing, height: frame.height)
        dataViewStack.frame.size = contentSize
        hScroll.frame = frame
        hScroll.contentMode = .center
        hScroll.contentSize = contentSize
        hScroll.bounces = true
        hScroll.alwaysBounceHorizontal = true
        hScroll.showsHorizontalScrollIndicator = false
        hScroll.delegate = self

        backgroundColor = .primaryContrast
        layer.cornerRadius = 16
        clipsToBounds = true

        let tr = UILongPressGestureRecognizer(target: self, action: #selector(tapped))
        tr.minimumPressDuration = 0
        tr.cancelsTouchesInView = false
        tr.delaysTouchesBegan = false
        tr.delegate = self
        dataViewStack.addGestureRecognizer(tr)

        updateViewsStyle(hScroll)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }

    var tapOrigin: CGPoint?

    @objc func tapped(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            tapOrigin = sender.location(in: self)

            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: []) {
                self.transform = CGAffineTransform.init(scaleX: 0.98, y: 0.98)
            }
        }

        if sender.state == .ended {
            // On short tap, scroll to target
            let origin = Int(tapOrigin!.x.rounded())
            let new = Int(sender.location(in: self).x.rounded())
            if abs(origin - new) < 3 {
                let loc = sender.location(in: hScroll)
                if let width = dataViews.first?.frame.width {
                    let idx = Int(loc.x/width)
                    hScroll.setContentOffset(CGPoint(x: CGFloat(idx)*width-width, y: 0), animated: true)
                }
            }

            tapOrigin = nil

            // Shake and restore identity transform
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: []) {
                self.transform = CGAffineTransform.identity
            }
        }
    }

    func addSubviewsAndConstraints() {
        addSubview(hScroll)
        hScroll.addSubview(dataViewStack)
    }

    // MARK: - ScrollViewDelegate

    // Snap to points after letting go of scroll touch
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let dataViewWidth = dataViews.first?.frame.width else { return }
        let x = targetContentOffset.pointee.x
        let mod = Int((+x+dataViewWidth/2)/dataViewWidth)
        let newX = CGFloat(mod)*dataViewWidth
        let newEndpoint = CGPoint(x: newX, y: 0)
        targetContentOffset.pointee = newEndpoint
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateViewsStyle(scrollView)
    }

    private func updateViewsStyle(_ scrollView: UIScrollView) {
        for (i, dataView) in dataViews.enumerated() {
            dataView.respondToScrollView(idx: i, container: scrollView)
        }
    }
}


final class StepperDataView: UIView {

    // MARK: - Properties

    private var value: String
    private var label = UILabel.make(.exercise)

    // MARK: - Initializers

    init(frame: CGRect, value: String) {
        self.value = value
        super.init(frame: frame)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setup() {
        label.text = value
        label.textColor = .background
        label.textAlignment = .center
        label.text = value
        label.isUserInteractionEnabled = false
        label.font = UIFont.round(.black, 30)
        isUserInteractionEnabled = false

        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    func addSubviewsAndConstraints() {
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(8)
        }
    }

    // Takes its position and index in container scrollview to calculate state
    func respondToScrollView(idx: Int, container: UIScrollView) {
        guard (-frame.width...container.contentSize.width).contains(container.contentOffset.x) else { return }

        let cellWidth = container.frame.width/3
        let myCenter = CGFloat(idx)*cellWidth + cellWidth/2
        let offset = container.contentOffset.x
        let centerPointingAt = offset+container.frame.width/2
        let distanceFromCenter = abs(centerPointingAt - myCenter)
        let maxCenterToCenterDistance = cellWidth*1.5
        let normalizedDistanceFromCenter = min(abs(distanceFromCenter), maxCenterToCenterDistance)/maxCenterToCenterDistance
        let maxTranslation: CGFloat = 0
        let translation = maxTranslation*(1-normalizedDistanceFromCenter)

        // Keep regular size at max and scale down when offset from the center
        // This to avoid pixelating font
        let maxScale: CGFloat = 0.5
        let scale = 1 - maxScale*(normalizedDistanceFromCenter)

        alpha = 1-normalizedDistanceFromCenter
        label.transform = CGAffineTransform.identity.translatedBy(x: 0, y: translation).scaledBy(x: scale, y: scale)

        // Shake if exactly at center
        if normalizedDistanceFromCenter == 0 {
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred()
        }
    }
}

