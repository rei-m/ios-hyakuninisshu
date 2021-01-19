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
        setTitleColor(UIColor(named: "SecondaryContrastTextColor"), for: .normal)
        layer.backgroundColor = UIColor(named: "SecondaryColor")?.cgColor
        layer.cornerRadius = 8
    }
}
