//
//  ExamResultCollectionViewCell.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/10.
//

import UIKit

class ExamResultCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var noLabel: UILabel!
  @IBOutlet weak var correctImage: UIImageView!

  private let bgColor = UIColor(named: .background)

  private func setUp() {
    backgroundColor = bgColor
    layer.cornerRadius = 4
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
