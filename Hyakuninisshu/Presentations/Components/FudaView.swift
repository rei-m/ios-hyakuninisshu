//
//  FudaView.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/05.
//

import UIKit

class FudaView: UIView {
  var borderWidth: CGFloat = 6.0
  var cornerRadius: CGFloat = 6.0
  var shadowOffset: CGFloat = 2.0
  var fontSize: CGFloat = {
    let screenBounds = UIScreen.main.bounds
    let baseSize = min(screenBounds.width, screenBounds.height / 2)
    return baseSize / 16
  }()

  private var _material: Material?
  var material: Material? {
    get { _material }
    set(v) {
      _material = v
      guard let v = v else {
        return
      }
      firstLineView.text = v.shokuKanji
      secondLineView.text = v.nikuKanji
      thirdLineView.text = v.sankuKanji
      fourthLineView.text = v.shikuKanji
      fifthLineView.text = v.gokuKanji
    }
  }

  private let firstLineView = VerticalLabel()
  private let secondLineView = VerticalLabel()
  private let thirdLineView = VerticalLabel()
  private let fourthLineView = VerticalLabel()
  private let fifthLineView = VerticalLabel()

  private func setUpView() {
    setUpCardFrame(borderWidth: borderWidth, cornerRadius: cornerRadius, shadowOffset: shadowOffset)
    translatesAutoresizingMaskIntoConstraints = false
    widthAnchor.constraint(equalToConstant: fontSize * 10).isActive = true
    heightAnchor.constraint(equalToConstant: fontSize * 14).isActive = true
    backgroundColor = .clear
  }

  private func setUpLineView(lineView: VerticalLabel) {
    addSubview(lineView)
    lineView.fontSize = fontSize
    lineView.backgroundColor = .clear
    lineView.translatesAutoresizingMaskIntoConstraints = false
    lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 32).isActive = true
    lineView.widthAnchor.constraint(equalToConstant: fontSize).isActive = true

    switch lineView {
    case firstLineView:
      lineView.topAnchor.constraint(equalTo: topAnchor, constant: fontSize * 2).isActive = true
      lineView.leadingAnchor.constraint(equalTo: secondLineView.trailingAnchor, constant: 8)
        .isActive = true
      lineView.text = "     "
    case secondLineView:
      lineView.topAnchor.constraint(equalTo: topAnchor, constant: fontSize * 3.1).isActive = true
      lineView.leadingAnchor.constraint(equalTo: thirdLineView.trailingAnchor, constant: 8).isActive =
        true
      lineView.text = "       "
    case thirdLineView:
      lineView.topAnchor.constraint(equalTo: topAnchor, constant: fontSize * 4.2).isActive = true
      lineView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
      lineView.text = "     "
    case fourthLineView:
      lineView.topAnchor.constraint(equalTo: topAnchor, constant: fontSize * 3.6).isActive = true
      lineView.trailingAnchor.constraint(equalTo: thirdLineView.leadingAnchor, constant: -8)
        .isActive = true
      lineView.text = "       "
    case fifthLineView:
      lineView.topAnchor.constraint(equalTo: topAnchor, constant: fontSize * 4.6).isActive = true
      lineView.trailingAnchor.constraint(equalTo: fourthLineView.leadingAnchor, constant: -8)
        .isActive = true
      lineView.text = "       "
    default:
      fatalError("unhandled")
    }
  }

  private func setUp() {
    setUpView()
    setUpLineView(lineView: thirdLineView)
    setUpLineView(lineView: secondLineView)
    setUpLineView(lineView: fourthLineView)
    setUpLineView(lineView: firstLineView)
    setUpLineView(lineView: fifthLineView)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
}
