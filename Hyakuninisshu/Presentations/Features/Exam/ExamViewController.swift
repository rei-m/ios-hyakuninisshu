//
//  ExamViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import UIKit

protocol ExamViewProtocol: AnyObject {
    func goToNextVC(karutaNos: [Int8])
}

class ExamViewController: UIViewController {

    private var presenter: ExamPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO lastexamを取り直す
        tabBarController?.tabBar.isHidden = false
    }

    @IBAction func didTapStartExamButton(_ sender: Any) {
        presenter.didTapStartExamButton()
    }
    
    func inject(presenter: ExamPresenterProtocol) {
        self.presenter = presenter
    }
}

extension ExamViewController: ExamViewProtocol {
    func goToNextVC(karutaNos: [Int8]) {
        let vc: QuestionStarterViewController = requireStoryboard.instantiateViewController(identifier: .questionStarter)

        let model = QuestionStarterModel(karutaNos: karutaNos, karutaRepository: karutaRepository, questionRepository: questionRepository)

        let presenter = QuestionStarterPresenter(view: vc, model: model)

        vc.inject(presenter: presenter, kamiNoKu: DisplayStyleCondition.DATA[0], shimoNoKu: DisplayStyleCondition.DATA[1], animationSpeed: AnimationSpeedCondition.DATA[1])

        requireNavigationController.pushViewController(vc, animated: false)
    }
}
