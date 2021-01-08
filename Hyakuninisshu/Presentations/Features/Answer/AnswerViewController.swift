//
//  AnswerViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/04.
//

import UIKit

class AnswerViewController: UIViewController {

    @IBOutlet weak var fudaView: FudaView!
    @IBOutlet weak var noAndKimarijiLabel: UILabel!
    
    private var material: Material!
    private var questionNo: Int!
    private var questionCount: Int!
    private var kamiNoKu: DisplayStyleCondition!
    private var shimoNoKu: DisplayStyleCondition!
    private var animationSpeed: AnimationSpeedCondition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLeftBackButton()
        tabBarController?.tabBar.isHidden = true
        
        fudaView.material = material
        noAndKimarijiLabel.text = "\(material.noTxt) / \(material.kimarijiTxt)"
    }
    
    @IBAction func goToNextVC(_ sender: UIButton) {
        if (questionNo == questionCount) {
            if (0 < requireNavigationController.viewControllers.filter { $0 is TrainingViewController }.count) {
                goToTrainingResult()
                return
            }
            // TODO exam result
            // TODO examの結果を保存する必要があるなあ・・・
            
            // TODO どちらもいなかったらエラーにする
        } else {
            goToNextAnswer()
        }
    }

    private func goToTrainingResult() {
        let vc: TrainingResultViewController = requireStoryboard.instantiateViewController(identifier: .trainingResult)

        let model = TrainingResultModel(questionRepository: questionRepository)

        let presenter = TrainingResultPresenter(view: vc, model: model)

        vc.inject(
            presenter: presenter,
            kamiNoKu: kamiNoKu,
            shimoNoKu: shimoNoKu,
            animationSpeed: animationSpeed
        )

        requireNavigationController.replace(vc)
    }
    
    private func goToNextAnswer() {
        let vc: QuestionViewController = requireStoryboard.instantiateViewController(identifier: .question)

        let model = QuestionModel(questionNo: questionNo + 1, kamiNoKu: kamiNoKu, shimoNoKu: shimoNoKu, karutaRepository: karutaRepository, questionRepository: questionRepository)

        let presenter = QuestionPresenter(view: vc, model: model)

        vc.inject(questionCount: questionCount, animationSpeed: animationSpeed, presenter: presenter)

        requireNavigationController.replace(vc)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? MaterialDetailViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }

        destinationVC.material = material
    }
    
    func inject(material: Material,
                questionNo: Int,
                questionCount: Int,
                kamiNoKu: DisplayStyleCondition,
                shimoNoKu: DisplayStyleCondition,
                animationSpeed: AnimationSpeedCondition) {
        self.material = material
        self.questionNo = questionNo
        self.questionCount = questionCount
        self.kamiNoKu = kamiNoKu
        self.shimoNoKu = shimoNoKu
        self.animationSpeed = animationSpeed
    }
}
