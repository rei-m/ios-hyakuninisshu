//
//  ActionButton.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/19.
//

import UIKit

@IBDesignable class ActionButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    private func setUpView() {
        let borderColor = UIColor(named: "SecondaryColor")
        setTitleColor(UIColor(named: "SecondaryContrastTextColor"), for: .normal)
        layer.backgroundColor = borderColor?.cgColor
        layer.borderColor = borderColor?.cgColor
        layer.borderWidth = 4
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}
