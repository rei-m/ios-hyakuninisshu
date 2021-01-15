//
//  TrainingStarterViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/29.
//

import UIKit

protocol QuestionStarterViewProtocol: AnyObject {
    func displayEmptyError()
    func goToNextVC(questionCount: Int, questionNo: UInt8)
}

class QuestionStarterViewController: UIViewController {

    @IBOutlet weak var emptyMessageLabel: UILabel!

    private var presenter: QuestionStarterPresenterProtocol!
    
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
        presenter: QuestionStarterPresenterProtocol,
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

extension QuestionStarterViewController: QuestionStarterViewProtocol {

    func displayEmptyError() {
        emptyMessageLabel.isHidden = false
    }
    
    func goToNextVC(questionCount: Int, questionNo: UInt8) {
        let vc: QuestionViewController = requireStoryboard.instantiateViewController(identifier: .question)

        let model = QuestionModel(questionNo: questionNo, kamiNoKu: kamiNoKu, shimoNoKu: shimoNoKu, karutaRepository: karutaRepository, questionRepository: questionRepository)

        let presenter = QuestionPresenter(view: vc, model: model)

        vc.inject(questionCount: questionCount, animationSpeed: animationSpeed, presenter: presenter)
        
        navigationController?.pushViewController(vc, animated: false)
    }
}
