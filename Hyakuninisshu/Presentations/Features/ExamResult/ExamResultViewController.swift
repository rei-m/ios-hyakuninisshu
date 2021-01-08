//
//  ExamResultViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import UIKit

class ExamResultViewController: UIViewController {

    private var examResult: ExamResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLeftBackButton()
        tabBarController?.tabBar.isHidden = true

        dump(examResult)
        // Do any additional setup after loading the view.
    }
    
    func inject(examResult: ExamResult) {
        self.examResult = examResult
    }
}
