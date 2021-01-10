//
//  ExamViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import UIKit

protocol ExamViewProtocol: AnyObject {
    func displayLastResult(_ examScore: ExamScore)
    func goToNextVC(karutaNos: [Int8])
}

class ExamViewController: UIViewController {
    @IBOutlet weak var lastExamResultView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var averageAnswerSecLabel: UILabel!
    @IBOutlet weak var startTrainingButton: UIButton!
    
    private var presenter: ExamPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        lastExamResultView.isHidden = true
        startTrainingButton.isHidden = true
        presenter.viewWillAppear()
    }

    @IBAction func didTapStartExamButton(_ sender: Any) {
        presenter.didTapStartExamButton()
    }

    @IBAction func didTapStartTrainingButton(_ sender: Any) {
    }
    
    func inject(presenter: ExamPresenterProtocol) {
        self.presenter = presenter
    }
}

extension ExamViewController: ExamViewProtocol {
    func displayLastResult(_ examScore: ExamScore) {
        lastExamResultView.isHidden = false
        scoreLabel.text = examScore.score
        averageAnswerSecLabel.text = examScore.averageAnswerSecText
        startTrainingButton.isHidden = false
    }
    
    func goToNextVC(karutaNos: [Int8]) {
        let vc: QuestionStarterViewController = requireStoryboard.instantiateViewController(identifier: .questionStarter)

        let model = QuestionStarterModel(karutaNos: karutaNos, karutaRepository: karutaRepository, questionRepository: questionRepository)

        let presenter = QuestionStarterPresenter(view: vc, model: model)

        vc.inject(presenter: presenter, kamiNoKu: DisplayStyleCondition.DATA[0], shimoNoKu: DisplayStyleCondition.DATA[1], animationSpeed: AnimationSpeedCondition.DATA[1])

        requireNavigationController.pushViewController(vc, animated: false)
    }
}
