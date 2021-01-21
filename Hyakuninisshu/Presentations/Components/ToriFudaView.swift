//
//  VerticalLabel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/02.
//

import UIKit

class ToriFudaView: UIView {
    var borderWidth: CGFloat = 4.0
    var cornerRadius: CGFloat = 6.0
    var shadowOffset: CGFloat = 2.0
    var fontSize: CGFloat = {
        let baseSize = UIScreen.main.bounds.width
        return baseSize / 22
    }()

    private var _toriFuda: ToriFuda?
    var toriFuda: ToriFuda? {
        get { _toriFuda }
        set(v) {
            _toriFuda = v
            guard let v = v else {
                return
            }
            firstLineView.text = v.firstLine
            secondLineView.text = v.secondLine
        }
    }
    
    private let firstLineView = VerticalLabel()
    private let secondLineView = VerticalLabel()
    
    private let bgColor = UIColor(named: "FudaBackgroundColor")
    private let bgColorTouched = UIColor(named: "FudaBackgroundTouchedColor")
    
    private func setUpView() {
        setUpCardFrame(borderWidth: borderWidth, cornerRadius: cornerRadius, shadowOffset: shadowOffset)
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: fontSize * 4).isActive = true
        heightAnchor.constraint(equalToConstant: fontSize * 12).isActive = true
        backgroundColor = .clear
    }
    
    private func setUpLineView(lineView: VerticalLabel) {
        addSubview(lineView)
        lineView.fontSize = fontSize
        lineView.text = "        "
        lineView.backgroundColor = .clear
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16).isActive = true
        lineView.widthAnchor.constraint(equalToConstant: fontSize).isActive = true

        switch lineView {
        case firstLineView:
            lineView.topAnchor.constraint(equalTo: topAnchor, constant: fontSize * 1).isActive = true
            trailingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: fontSize * 0.75).isActive = true
        case secondLineView:
            lineView.topAnchor.constraint(equalTo: topAnchor, constant: fontSize * 2.3).isActive = true
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: fontSize * 0.75).isActive = true
        default:
            fatalError("unhandled")
        }
    }

    private func setUp() {
        setUpView()
        setUpLineView(lineView: firstLineView)
        setUpLineView(lineView: secondLineView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        subviews[0].backgroundColor = bgColorTouched
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        subviews[0].backgroundColor = bgColor
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        subviews[0].backgroundColor = bgColor
    }
}
