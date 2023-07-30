//
//  FontAnimation.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 30/07/2023.
//

import UIKit
import AKKIT


// Four throbbing G's vertically
public final class VFontAnimationVC_1: UIViewController {
    
    var timer = Timer()
    lazy var label1 = AnimatedLabel_1()
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label1])
        stack.alignment = .center
        stack.axis = .vertical
        return stack
    }()
    
    // MARK: Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        label1.currentTickerValue = 1/1
        runTimer()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1/100, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        label1.updateTimer()
    }
    
}

final class AnimatedLabel_1: UIView {
    //    var font = Inter(size: 64)
    var font = CrimsonFont(size: 64)
    //    var font = Sono(size: 64)
    //    var font = AnybodyFont(size: 64)
    //    var font = FaustinaFont(size: 64)
    //    var font = EpilogueFont(size: 64)
    var tick = 0.01
    var currentTickerValue = 0.5
    var textLabel: UILabel
    var isTimerRunning = false
    
    override init(frame: CGRect) {
        textLabel = UILabel(frame: frame)
        super.init(frame: frame)
        setup()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        textLabel.text = "Happy\nBending"
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.textColor = .akPrimary
    }
    
    func setupViews() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // Tick from 0 to 1 with autoreverse
    @objc func updateTimer() {
        let minValue: Double = 0
        let maxValue: Double = 1
        if currentTickerValue >= maxValue || currentTickerValue <= minValue {
            tick = tick * -1
        }
        
        currentTickerValue += tick
        currentTickerValue = currentTickerValue.clamped(to: 0...1)
        
        let newFont = font.make(weight: CGFloat(currentTickerValue))
        textLabel.font = newFont
        textLabel.textAlignment = .center
    }
    
}
