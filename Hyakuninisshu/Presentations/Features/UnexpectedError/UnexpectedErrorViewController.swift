//
//  UnexpectedErrorViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/17.
//

import UIKit

class UnexpectedErrorViewController: UIViewController {
    @IBOutlet weak var errorLabel: UILabel!

    var error: Error?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: エラーをAnalyticsに送信する
    }
    
    @IBAction func didTapRestartButton(_ sender: Any) {
        // ルートをdismissすることで再起動としているけど、これでいいのかな?
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: false)
    }
}
