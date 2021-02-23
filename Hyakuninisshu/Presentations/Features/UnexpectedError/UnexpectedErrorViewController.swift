//
//  UnexpectedErrorViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/17.
//

import FirebaseCrashlytics
import UIKit

class UnexpectedErrorViewController: UIViewController {
  @IBOutlet weak var errorLabel: UILabel!

  var error: Error?

  override func viewDidLoad() {
    super.viewDidLoad()
    guard let error = error else {
      return
    }
    Crashlytics.crashlytics().record(error: error)
  }

  @IBAction func didTapRestartButton(_ sender: Any) {
    // rootViewControllerをdismissすることで再起動としているけど、これでいいのかな?
    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: false)
  }
}
