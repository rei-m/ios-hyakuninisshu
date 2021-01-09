//
//  ExamResultViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import UIKit

class ExamResultViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var averageAnswerTimeLabel: UILabel!
    
    private var examResult: ExamResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLeftBackButton()
        tabBarController?.tabBar.isHidden = true

        scoreLabel.text = examResult.score
        averageAnswerTimeLabel.text = examResult.averageAnswerSecText
    }
    
    func inject(examResult: ExamResult) {
        self.examResult = examResult
    }
}
