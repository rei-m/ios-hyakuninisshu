//
//  ExamViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import UIKit

protocol ExamViewProtocol: AnyObject {
    func displayLastResult(_ examScore: PlayScore)
    func hideLastResult()
    func presentNextVC(karutaNos: [UInt8])
    func presentErrorVC(_ error: Error)
}

class ExamViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var lastExamResultView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var averageAnswerSecLabel: UILabel!
    @IBOutlet weak var startTrainingButton: UIButton!
    
    // MARK: - Property
    private var presenter: ExamPresenterProtocol!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        presenter.viewWillAppear()
    }

    // MARK: - Action
    @IBAction func didTapStartExamButton(_ sender: Any) {
        presenter.didTapStartExamButton()
    }

    @IBAction func didTapStartTrainingButton(_ sender: Any) {
        presenter.didTapStartTrainingButton()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
            case "ShowExamHistory":
                guard let examHistoryTableViewController = segue.destination as? ExamHistoryTableViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                let model = ExamHistoryModel(examHistoryRepository: diContainer.examHistoryRepository)
                let presenter = ExamHistoryPresenter(view: examHistoryTableViewController, model: model)
                
                examHistoryTableViewController.inject(presenter: presenter)
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    // MARK: - Method
    func inject(presenter: ExamPresenterProtocol) {
        self.presenter = presenter
    }
}

extension ExamViewController: ExamViewProtocol {
    func displayLastResult(_ examScore: PlayScore) {
        scoreLabel.text = examScore.score
        averageAnswerSecLabel.text = examScore.averageAnswerSecText
        lastExamResultView.isHidden = false
        startTrainingButton.isHidden = false
    }
    
    func hideLastResult() {
        lastExamResultView.isHidden = true
        startTrainingButton.isHidden = true
    }
    
    func presentNextVC(karutaNos: [UInt8]) {
        let vc: QuestionStarterViewController = requireStoryboard.instantiateViewController(identifier: .questionStarter)

        let model = QuestionStarterModel(karutaNos: karutaNos, karutaRepository: diContainer.karutaRepository, questionRepository: diContainer.questionRepository)

        let presenter = QuestionStarterPresenter(view: vc, model: model)

        vc.inject(presenter: presenter, kamiNoKu: DisplayStyleCondition.DATA[0], shimoNoKu: DisplayStyleCondition.DATA[1], animationSpeed: AnimationSpeedCondition.DATA[1])

        requireNavigationController.pushViewController(vc, animated: false)
    }
    
    func presentErrorVC(_ error: Error) {
        presentUnexpectedErrorVC(error)
    }
}
