//
//  ActionButton.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/19.
//

import UIKit

@IBDesignable class ActionButton: UIButton {
    
    enum ActionButtonType: Int {
        case normal = 0;
        case primary = 1;
        case secondary = 2;
    }

    private var actionButtonType: ActionButtonType = .primary

    @IBInspectable var actionButtonTypeValue: Int {
        get {
            return self.actionButtonType.rawValue
        }
        set(newValue) {
            self.actionButtonType = ActionButtonType(rawValue: newValue) ?? .primary
            switch self.actionButtonType {
            case .normal:
                titleColor = .systemGray
                bgColor = .systemBackground
            case .primary:
                titleColor = primaryTextColor
                bgColor = primaryColor
            case .secondary:
                titleColor = secondaryTextColor
                bgColor = secondaryColor
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor?

    private let primaryColor: UIColor? = UIColor(named: "PrimaryColor")
    private let secondaryColor: UIColor? = UIColor(named: "SecondaryColor")

    private let primaryTextColor: UIColor? = UIColor(named: "PrimaryContrastTextColor")
    private let secondaryTextColor: UIColor? = UIColor(named: "SecondaryContrastTextColor")
    
    private var titleColor: UIColor?
    private var bgColor: UIColor?
    
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
        layer.borderColor = borderColor?.cgColor ?? bgColor?.cgColor
        layer.borderWidth = 1
        setTitleColor(titleColor, for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        alpha = 0.8
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        alpha = 1
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        alpha = 1
    }
}
