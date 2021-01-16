//
//  YomiFudaView.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/02.
//

import UIKit
import Combine

@IBDesignable class YomiFudaView: UIView {
    @IBInspectable var borderWidth: CGFloat = 6.0
    @IBInspectable var cornerRadius: CGFloat = 6.0
    @IBInspectable var shadowOffset: CGFloat = 2.0
    @IBInspectable var fontSize: CGFloat = 17.0

    public var _yomiFuda: YomiFuda?
    public var yomiFuda: YomiFuda? {
        get { _yomiFuda }
        set(v) {
            _yomiFuda = v
            v?.firstLine.enumerated().forEach {
                (firstLineView.arrangedSubviews[$0.offset] as! UILabel).text = String($0.element)
            }
            v?.secondLine.enumerated().forEach {
                (secondLineView.arrangedSubviews[$0.offset] as! UILabel).text = String($0.element)
            }
            v?.thirdLine.enumerated().forEach {
                (thirdLineView.arrangedSubviews[$0.offset] as! UILabel).text = String($0.element)
            }
        }
    }
    
    private let borderColor = UIColor(named: "AccentColor")
    
    private let firstLineView = UIStackView()
    private let secondLineView = UIStackView()
    private let thirdLineView = UIStackView()

    private var cancellables = [AnyCancellable]()

    private func setUpView() {
        setUpCardFrame(borderWidth: borderWidth, cornerRadius: cornerRadius, shadowOffset: shadowOffset)
        widthAnchor.constraint(equalToConstant: fontSize * 8).isActive = true
    }
        
    private func setUpLineView(lineView: UIStackView, count: Int) {
        lineView.axis = .vertical
        addSubview(lineView)
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.spacing = 1
        
        for _ in 0..<count {
            let label = UILabel() // 6
            lineView.addArrangedSubview(label)
            label.font = UIFont.systemFont(ofSize: fontSize)
            label.textColor = .black
            label.heightAnchor.constraint(equalToConstant: fontSize).isActive = true
            label.text = " "
            label.alpha = 0
        }
    }
    
    private func setUp() {
        setUpView()
        setUpLineView(lineView: thirdLineView, count: 6)
        setUpLineView(lineView: secondLineView, count: 8)
        setUpLineView(lineView: firstLineView, count: 6)
                
        secondLineView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        secondLineView.topAnchor.constraint(equalTo: topAnchor, constant: fontSize * 3).isActive = true
        secondLineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: fontSize * -2).isActive = true
        firstLineView.leadingAnchor.constraint(equalTo: secondLineView.trailingAnchor, constant: 8).isActive = true
        firstLineView.topAnchor.constraint(equalTo: topAnchor, constant: fontSize * 2).isActive = true
        thirdLineView.trailingAnchor.constraint(equalTo: secondLineView.leadingAnchor, constant: -8).isActive = true
        thirdLineView.topAnchor.constraint(equalTo: topAnchor, constant: fontSize * 4).isActive = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    public func startAnimation(_ condition: AnimationSpeedCondition) {
        guard let yomiFuda = _yomiFuda else {
            return
        }

        var arrangedSubviews: [UIView] = []
        arrangedSubviews += firstLineView.arrangedSubviews[0...yomiFuda.firstLine.count - 1]
        arrangedSubviews += secondLineView.arrangedSubviews[0...yomiFuda.secondLine.count - 1]
        arrangedSubviews += thirdLineView.arrangedSubviews[0...yomiFuda.thirdLine.count - 1]
        
        Timer.publish(every: 0.6, on: .main, in: .default)
            .autoconnect()
            .measureInterval(using: RunLoop.main)
            .zip(arrangedSubviews.publisher)
            .sink { _, view in
                UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: {
                    view.alpha = 1
                })
            }
            .store(in: &cancellables)
    }
    
    public func stopAnimation() {
        cancellables.forEach { $0.cancel() }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
