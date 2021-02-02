//
//  QuestionResultView.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/23.
//

import UIKit

@IBDesignable class QuestionResultView: UIView {

  @IBInspectable var title: String {
    get { titleLabel.text ?? "" }
    set(v) { titleLabel.text = v }
  }

  var value: String {
    get { valueLabel.text ?? "" }
    set(v) { valueLabel.text = v }
  }

  private let titleLabel = UILabel()
  private let valueLabel = UILabel()
  private let textColor = UIColor(named: .fudaText)
  private let bgColor = UIColor(named: .fudaBackground)

  private func setUp() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.masksToBounds = true
    layer.cornerRadius = 8
    backgroundColor = bgColor

    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16).isActive = true

    titleLabel.textColor = textColor
    titleLabel.font = titleLabel.font.withSize(17)

    addSubview(valueLabel)
    valueLabel.translatesAutoresizingMaskIntoConstraints = false
    valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
    bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 16).isActive = true

    valueLabel.textColor = textColor
    valueLabel.font = titleLabel.font.withSize(27)

  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setUp()
  }
}
