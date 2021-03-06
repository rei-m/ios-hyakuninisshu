//
//  YomiFudaView.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/02.
//

import Combine
import UIKit

class YomiFudaView: UIView {
  var borderWidth: CGFloat = 6.0
  var cornerRadius: CGFloat = 6.0
  var shadowOffset: CGFloat = 2.0
  var fontSize: CGFloat = {
    let screenBounds = UIScreen.main.bounds
    let baseSize = min(screenBounds.width, screenBounds.height / 2)
    return baseSize / 16
  }()

  private var _yomiFuda: YomiFuda?
  var yomiFuda: YomiFuda? {
    get { _yomiFuda }
    set(v) {
      _yomiFuda = v
      v?.firstLine.enumerated().forEach {
        (firstLineView.arrangedSubviews[$0.offset] as! UILabel).text = String($0.element)
      }
      v?.secondLine.enumerated().forEach {
        (secondLineView.arrangedSubviews[$0.offset] as! UILabel).text = String($0.element)
      }
      v?.thirdLine.enumerated().forEach {
        (thirdLineView.arrangedSubviews[$0.offset] as! UILabel).text = String($0.element)
      }
    }
  }

  private let textColor = UIColor(named: .fudaText)
  private let borderColor = UIColor(named: .fudaFrame)

  private let firstLineView = UIStackView()
  private let secondLineView = UIStackView()
  private let thirdLineView = UIStackView()

  private var cancellables = [AnyCancellable]()

  private func setUpView() {
    setUpCardFrame(borderWidth: borderWidth, cornerRadius: cornerRadius, shadowOffset: shadowOffset)
    widthAnchor.constraint(equalToConstant: fontSize * 8).isActive = true
  }

  private func setUpLineView(lineView: UIStackView, count: Int) {
    lineView.axis = .vertical
    addSubview(lineView)

    lineView.translatesAutoresizingMaskIntoConstraints = false
    lineView.spacing = 1

    for _ in 0..<count {
      let label = UILabel()
      lineView.addArrangedSubview(label)
      label.font = UIFont(name: .hannari, size: fontSize)
      label.textColor = textColor
      label.heightAnchor.constraint(equalToConstant: fontSize).isActive = true
      label.text = " "
      label.alpha = 0
    }
  }

  private func setUp() {
    setUpView()
    setUpLineView(lineView: thirdLineView, count: 6)
    setUpLineView(lineView: secondLineView, count: 8)
    setUpLineView(lineView: firstLineView, count: 6)

    secondLineView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    secondLineView.topAnchor.constraint(equalTo: topAnchor, constant: fontSize * 3).isActive = true
    secondLineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: fontSize * -2).isActive =
      true
    firstLineView.leadingAnchor.constraint(equalTo: secondLineView.trailingAnchor, constant: 8)
      .isActive = true
    firstLineView.topAnchor.constraint(equalTo: topAnchor, constant: fontSize * 2).isActive = true
    thirdLineView.trailingAnchor.constraint(equalTo: secondLineView.leadingAnchor, constant: -8)
      .isActive = true
    thirdLineView.topAnchor.constraint(equalTo: topAnchor, constant: fontSize * 4).isActive = true
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }

  func startAnimation(_ condition: AnimationSpeedCondition) {
    guard let yomiFuda = _yomiFuda else {
      return
    }

    var arrangedSubviews: [UIView] = []
    arrangedSubviews += firstLineView.arrangedSubviews[0...yomiFuda.firstLine.count - 1]
    arrangedSubviews += secondLineView.arrangedSubviews[0...yomiFuda.secondLine.count - 1]
    arrangedSubviews += thirdLineView.arrangedSubviews[0...yomiFuda.thirdLine.count - 1]

    Timer.publish(every: condition.value, on: .main, in: .default)
      .autoconnect()
      .measureInterval(using: RunLoop.main)
      .zip(arrangedSubviews.publisher)
      .sink { _, view in
        UIView.animate(
          withDuration: condition.value, delay: 0, options: .allowUserInteraction,
          animations: {
            view.alpha = 1
          })
      }
      .store(in: &cancellables)
  }

  func stopAnimation() {
    cancellables.forEach { $0.cancel() }
  }
}
