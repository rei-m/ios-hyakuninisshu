//
//  ActionButton.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/19.
//

import UIKit

@IBDesignable class ActionButton: UIButton {

    @IBInspectable var titleColor: UIColor? = UIColor(named: "SecondaryColor")
    @IBInspectable var bgColor: UIColor? = UIColor(named: "SecondaryContrastTextColor")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    private func setUpView() {
        layer.cornerRadius = 8
    }
    
    override func draw(_ rect: CGRect) {
        layer.backgroundColor = bgColor?.cgColor
        setTitleColor(titleColor, for: .normal)
    }
}
