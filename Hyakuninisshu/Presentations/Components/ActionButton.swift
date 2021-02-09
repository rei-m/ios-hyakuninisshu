//
//  ActionButton.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/19.
//

import UIKit

@IBDesignable class ActionButton: UIButton {

  enum ActionButtonType: Int {
    case normal = 0
    case primary = 1
    case secondary = 2
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
        titleColor = textColor
        bgColor = .systemGray3
        touchedColor = .systemGray4
      case .primary:
        titleColor = primaryTextColor
        bgColor = primaryColor
        touchedColor = primaryTouchedColor
      case .secondary:
        titleColor = secondaryTextColor
        bgColor = secondaryColor
        touchedColor = secondaryTouchedColor
      }
    }
  }

  @IBInspectable var borderColor: UIColor?

  private let textColor: UIColor? = UIColor(named: .text)

  private let primaryColor: UIColor? = UIColor(named: .primary)
  private let secondaryColor: UIColor? = UIColor(named: .secondary)

  private let primaryTextColor: UIColor? = UIColor(named: .primaryContrastText)
  private let secondaryTextColor: UIColor? = UIColor(named: .secondaryContrastText)

  private let primaryTouchedColor: UIColor? = UIColor(named: .primaryTouched)
  private let secondaryTouchedColor: UIColor? = UIColor(named: .secondaryTouched)

  private var titleColor: UIColor?
  private var bgColor: UIColor?
  private var touchedColor: UIColor?

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
    layer.backgroundColor = touchedColor?.cgColor
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    layer.backgroundColor = bgColor?.cgColor
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    layer.backgroundColor = bgColor?.cgColor
  }
}
