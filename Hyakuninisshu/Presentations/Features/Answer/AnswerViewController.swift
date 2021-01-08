//
//  AnswerViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/04.
//

import UIKit

protocol AnswerViewProtocol: AnyObject {
    func goToNextQuestion()
    func goToTrainingResult(_ trainingResult: TrainingResult)
    func goToExamResult(_ examResult: ExamResult)
}

class AnswerViewController: UIViewController {

    @IBOutlet weak var fudaView: FudaView!
    @IBOutlet weak var noAndKimarijiLabel: UILabel!
    @IBOutlet weak var goToNextButton: UIButton!
    @IBOutlet weak var goToResultButton: UIButton!

    private var presenter: AnswerPresenterProtocol!
    
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
        
        let isAnsweredAllQuestions = questionNo == questionCount
        goToNextButton.isHidden = isAnsweredAllQuestions
        goToResultButton.isHidden = !isAnsweredAllQuestions
    }
    
    @IBAction func didTapGoToNext(_ sender: UIButton) {
        presenter.didTapGoToNext()
    }

    @IBAction func didTapGoToResult(_ sender: UIButton) {
        if (0 < requireNavigationController.viewControllers.filter { $0 is TrainingViewController }.count) {
            presenter.didTapGoToTrainingResult()
            return
        }
        if (0 < requireNavigationController.viewControllers.filter { $0 is ExamViewController }.count) {
            presenter.didTapGoToExamResult()
            return
        }

        fatalError("Unknown Navigation.")
    }
            
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? MaterialDetailViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }

        destinationVC.material = material
    }
    
    func inject(presenter: AnswerPresenterProtocol,
                material: Material,
                questionNo: Int,
                questionCount: Int,
                kamiNoKu: DisplayStyleCondition,
                shimoNoKu: DisplayStyleCondition,
                animationSpeed: AnimationSpeedCondition) {
        self.presenter = presenter
        self.material = material
        self.questionNo = questionNo
        self.questionCount = questionCount
        self.kamiNoKu = kamiNoKu
        self.shimoNoKu = shimoNoKu
        self.animationSpeed = animationSpeed
    }
}

extension AnswerViewController: AnswerViewProtocol {
    func goToNextQuestion() {
        let vc: QuestionViewController = requireStoryboard.instantiateViewController(identifier: .question)

        let model = QuestionModel(questionNo: questionNo + 1, kamiNoKu: kamiNoKu, shimoNoKu: shimoNoKu, karutaRepository: karutaRepository, questionRepository: questionRepository)

        let presenter = QuestionPresenter(view: vc, model: model)

        vc.inject(questionCount: questionCount, animationSpeed: animationSpeed, presenter: presenter)

        requireNavigationController.replace(vc)
    }

    func goToTrainingResult(_ trainingResult: TrainingResult) {
        let vc: TrainingResultViewController = requireStoryboard.instantiateViewController(identifier: .trainingResult)

        vc.inject(
            trainingResult: trainingResult,
            kamiNoKu: kamiNoKu,
            shimoNoKu: shimoNoKu,
            animationSpeed: animationSpeed
        )

        requireNavigationController.replace(vc)
    }
    
    func goToExamResult(_ examResult: ExamResult) {
        let vc: ExamResultViewController = requireStoryboard.instantiateViewController(identifier: .examResult)
        vc.inject(examResult: examResult)
        requireNavigationController.replace(vc)
    }
}
