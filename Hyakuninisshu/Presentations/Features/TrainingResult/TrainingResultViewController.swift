//
//  TrainingResultViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/06.
//

import UIKit

class TrainingResultViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var averageAnswerTimeLabel: UILabel!
    @IBOutlet weak var goToTrainingButton: UIButton!
    
    private var trainingResult: TrainingResult!
    private var kamiNoKu: DisplayStyleCondition!
    private var shimoNoKu: DisplayStyleCondition!
    private var animationSpeed: AnimationSpeedCondition!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLeftBackButton()
        tabBarController?.tabBar.isHidden = true
        
        scoreLabel.text = trainingResult.score.score
        averageAnswerTimeLabel.text = trainingResult.score.averageAnswerSecText
        goToTrainingButton.isHidden = !trainingResult.canRestart
    }
    
    @IBAction func didTapGoToTraining(_ sender: Any) {
        let vc: QuestionStarterViewController = requireStoryboard.instantiateViewController(identifier: .questionStarter)
        
        let model = QuestionStarterModel(karutaNos: trainingResult.wrongKarutaNos, karutaRepository: karutaRepository, questionRepository: questionRepository)
        
        let presenter = QuestionStarterPresenter(view: vc, model: model)

        vc.inject(presenter: presenter, kamiNoKu: kamiNoKu, shimoNoKu: shimoNoKu, animationSpeed: animationSpeed)

        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func didTapGoToMenu(_ sender: Any) {
        popToNaviRoot()
    }

    func inject(
        trainingResult: TrainingResult,
        kamiNoKu: DisplayStyleCondition,
        shimoNoKu: DisplayStyleCondition,
        animationSpeed: AnimationSpeedCondition
    ) {
        self.trainingResult = trainingResult
        self.kamiNoKu = kamiNoKu
        self.shimoNoKu = shimoNoKu
        self.animationSpeed = animationSpeed
    }
}
