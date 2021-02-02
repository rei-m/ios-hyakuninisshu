//
//  SettingViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/30.
//

import UIKit

class SettingViewController: UITableViewController {
  @IBOutlet weak var darkModeValueLabel: UILabel!
  @IBOutlet weak var appVersionLabel: UILabel!
  @IBOutlet weak var aboutAppCell: UITableViewCell!

  override func viewDidLoad() {
    super.viewDidLoad()
    appVersionLabel.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    darkModeValueLabel.text = UserDefaults.standard.darkMode.text
    tableView.rowHeight = UITableView.automaticDimension
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return UITableView.automaticDimension
  }
}
