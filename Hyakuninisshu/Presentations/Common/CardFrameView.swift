//
//  CardFrameView.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/12.
//

import UIKit

@IBDesignable class CardFrameView: UIView {

    @IBInspectable var borderColor: UIColor = UIColor(named: "AccentColor")!
    @IBInspectable var borderWidth: CGFloat = 8.0
    @IBInspectable var cornerRadius: CGFloat = 8.0
    @IBInspectable var shadowOffset: CGFloat = 2.0
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let shadowView = UIView()
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = cornerRadius
        shadowView.layer.cornerRadius = cornerRadius
        shadowView.layer.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        shadowView.layer.masksToBounds = false
        
        let roundView = UIView()
        roundView.layer.borderColor = borderColor.cgColor
        roundView.layer.borderWidth = borderWidth
        roundView.layer.cornerRadius = cornerRadius
        roundView.layer.masksToBounds = true

        addSubview(shadowView)
        addSubview(roundView)
        addFitConstraints(to: roundView)
        addFitConstraints(to: shadowView)
        sendSubviewToBack(roundView)
        sendSubviewToBack(shadowView)

    }
}

