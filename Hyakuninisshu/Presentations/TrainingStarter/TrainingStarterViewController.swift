//
//  TrainingStarterViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/29.
//

import UIKit

protocol TrainingStarterViewProtocol: AnyObject {
    func displayEmptyError()
    func goToNextVC(
        questionCount: Int,
        questionNo: Int,
        kamiNoKu: DisplayStyleCondition,
        shimoNoKu: DisplayStyleCondition,
        animationSpeed: AnimationSpeedCondition
    )
}

class TrainingStarterViewController: UIViewController {

    @IBOutlet weak var emptyMessageLabel: UILabel!

    private var presenter: TrainingStarterPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        emptyMessageLabel.isHidden = true
        
        presenter.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        presenter.viewDidDisappear()
    }
    
    func inject(presenter: TrainingStarterPresenterProtocol) {
        self.presenter = presenter
    }
}

extension TrainingStarterViewController: TrainingStarterViewProtocol {

    func displayEmptyError() {
        emptyMessageLabel.isHidden = false
    }
    
    func goToNextVC(
        questionCount: Int,
        questionNo: Int,
        kamiNoKu: DisplayStyleCondition,
        shimoNoKu: DisplayStyleCondition,
        animationSpeed: AnimationSpeedCondition
    ) {
        guard let vc = storyboard?.instantiateViewController(identifier: "QuestionViewController") else {
            fatalError("unknown VC identifier value='QuestionViewController'")
        }
        navigationController?.pushViewController(vc, animated: false)
    }
}
