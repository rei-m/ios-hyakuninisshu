//
//  ExamHistoryTableViewCell.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/12.
//

import UIKit

class ExamHistoryTableViewCell: UITableViewCell {
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var averageAnswerTimeLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
