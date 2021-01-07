//
//  TrainingStarterViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/29.
//

import UIKit

protocol TrainingStarterViewProtocol: AnyObject {
    func displayEmptyError()
    func goToNextVC(questionCount: Int, questionNo: Int)
}

class TrainingStarterViewController: UIViewController {

    @IBOutlet weak var emptyMessageLabel: UILabel!

    private var presenter: TrainingStarterPresenterProtocol!
    
    private var kamiNoKu: DisplayStyleCondition!
    private var shimoNoKu: DisplayStyleCondition!
    private var animationSpeed: AnimationSpeedCondition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        emptyMessageLabel.isHidden = true
        
        presenter.viewDidLoad()
    }
    
    func inject(
        presenter: TrainingStarterPresenterProtocol,
        kamiNoKu: DisplayStyleCondition,
        shimoNoKu: DisplayStyleCondition,
        animationSpeed: AnimationSpeedCondition
    ) {
        self.presenter = presenter
        self.kamiNoKu = kamiNoKu
        self.shimoNoKu = shimoNoKu
        self.animationSpeed = animationSpeed
    }
}

extension TrainingStarterViewController: TrainingStarterViewProtocol {

    func displayEmptyError() {
        emptyMessageLabel.isHidden = false
    }
    
    func goToNextVC(questionCount: Int, questionNo: Int) {
        guard let vc = storyboard?.instantiateViewController(identifier: "QuestionViewController") as? QuestionViewController else {
            fatalError("unknown VC identifier value='QuestionViewController'")
        }
        
        let model = QuestionModel(questionCount: questionCount, questionNo: questionNo, kamiNoKu: kamiNoKu, shimoNoKu: shimoNoKu, animationSpeed: animationSpeed, karutaRepository: karutaRepository, questionRepository: questionRepository)
        let presenter = QuestionPresenter(view: vc, model: model)

        vc.inject(presenter: presenter)
        
        navigationController?.pushViewController(vc, animated: false)
    }
}
