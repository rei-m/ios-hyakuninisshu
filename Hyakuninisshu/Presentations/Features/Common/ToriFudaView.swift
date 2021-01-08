//
//  VerticalLabel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/02.
//

import UIKit

@IBDesignable class ToriFudaView: UIView {
    @IBInspectable var borderWidth: CGFloat = 4.0
    @IBInspectable var cornerRadius: CGFloat = 6.0
    @IBInspectable var shadowOffset: CGFloat = 2.0
    @IBInspectable var fontSize: CGFloat = 16.0

    public var _toriFuda: ToriFuda?
    public var toriFuda: ToriFuda? {
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
    
    private func setUpView() {
        setUpCardFrame(borderWidth: borderWidth, cornerRadius: cornerRadius, shadowOffset: shadowOffset)
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: fontSize * 4).isActive = true
        heightAnchor.constraint(equalToConstant: fontSize * 12).isActive = true
        backgroundColor = .clear
    }
    
    private func setUpLineView(lineView: VerticalLabel) {
        addSubview(lineView)
        lineView.backgroundColor = .clear
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16).isActive = true
        lineView.widthAnchor.constraint(equalToConstant: fontSize).isActive = true
        lineView.text = "        "

        switch lineView {
        case firstLineView:
            lineView.topAnchor.constraint(equalTo: topAnchor, constant: fontSize * 1).isActive = true
            trailingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 12).isActive = true
        case secondLineView:
            lineView.topAnchor.constraint(equalTo: topAnchor, constant: fontSize * 2.3).isActive = true
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        default:
            fatalError("unhandled")
        }
    }

    private func setUp() {
        setUpView()
        setUpLineView(lineView: firstLineView)
        setUpLineView(lineView: secondLineView)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

}
