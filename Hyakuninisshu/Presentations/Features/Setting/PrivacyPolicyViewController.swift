//
//  PrivacyPolicyViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/02/01.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
  @IBAction func didTapGooglePrivacyPolicy(_ sender: Any) {
    guard let url = URL(string: "https://policies.google.com/privacy?hl=ja") else {
      fatalError()
    }

    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
  }
}
