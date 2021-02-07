//
//  CreditViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/02/08.
//

import UIKit
import WebKit

class CreditViewController: UIViewController {
  @IBOutlet weak var creditWebView: WKWebView!

  override func viewDidLoad() {
    super.viewDidLoad()
    guard let path: String = Bundle.main.path(forResource: "license", ofType: "html") else {
      fatalError("not faound license.html")
    }
    let localHTMLUrl = URL(fileURLWithPath: path, isDirectory: false)
    creditWebView.loadFileURL(localHTMLUrl, allowingReadAccessTo: localHTMLUrl)
  }
}
