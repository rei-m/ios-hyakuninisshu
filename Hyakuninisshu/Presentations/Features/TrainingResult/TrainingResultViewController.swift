//
//  TrainingResultViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/06.
//

import UIKit

class TrainingResultViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var scoreView: QuestionResultView!
    @IBOutlet weak var averageAnswerTimeView: QuestionResultView!
    
    @IBOutlet weak var goToTrainingButton: UIButton!
    
    // MARK: - Property
    private var trainingResult: TrainingResult!
    private var kamiNoKu: DisplayStyleCondition!
    private var shimoNoKu: DisplayStyleCondition!
    private var animationSpeed: AnimationSpeedCondition!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLeftBackButton()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Tatami")!)

        scoreView.value = trainingResult.score.score
        averageAnswerTimeView.value = trainingResult.score.averageAnswerSecText
        goToTrainingButton.isHidden = !trainingResult.canRestart
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Action
    @IBAction func didTapGoToTraining(_ sender: Any) {
        let vc: QuestionStarterViewController = requireStoryboard.instantiateViewController(identifier: .questionStarter)
        
        let model = QuestionStarterModel(karutaNos: trainingResult.wrongKarutaNos, karutaRepository: diContainer.karutaRepository, questionRepository: diContainer.questionRepository)
        
        let presenter = QuestionStarterPresenter(view: vc, model: model)

        vc.inject(presenter: presenter, kamiNoKu: kamiNoKu, shimoNoKu: shimoNoKu, animationSpeed: animationSpeed)

        requireNavigationController.pushViewController(vc, animated: false)
    }
    
    @IBAction func didTapGoToMenu(_ sender: Any) {
        popToNaviRoot()
    }

    // MARK: - Method
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
