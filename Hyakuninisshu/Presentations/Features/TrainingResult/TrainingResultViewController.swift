//
//  TrainingResultViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/06.
//

import UIKit

protocol TrainingResultViewProtocol: AnyObject {
    func displayResult(_ trainingResult: TrainingResult)
}

class TrainingResultViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var averageAnswerTimeLabel: UILabel!
    @IBOutlet weak var goToTrainingButton: UIButton!
    
    private var presenter: TrainingResultPresenterProtocol!

    private var kamiNoKu: DisplayStyleCondition!
    private var shimoNoKu: DisplayStyleCondition!
    private var animationSpeed: AnimationSpeedCondition!
    
    private var wrongKarutaNos: [Int8]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLeftBackButton()
        tabBarController?.tabBar.isHidden = true
        
        presenter.viewDidLoad()
    }
    
    @IBAction func didTapGoToTraining(_ sender: Any) {
        guard let wrongKarutaNos = self.wrongKarutaNos else {
            return
        }

        let vc: QuestionStarterViewController = requireStoryboard.instantiateViewController(identifier: .questionStarter)
        
        let model = QuestionStarterModel(karutaNos: wrongKarutaNos, karutaRepository: karutaRepository, questionRepository: questionRepository)
        
        let presenter = QuestionStarterPresenter(view: vc, model: model)

        vc.inject(presenter: presenter, kamiNoKu: kamiNoKu, shimoNoKu: shimoNoKu, animationSpeed: animationSpeed)

        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func didTapGoToMenu(_ sender: Any) {
        popToNaviRoot()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func inject(
        presenter: TrainingResultPresenterProtocol,
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

extension TrainingResultViewController: TrainingResultViewProtocol {
    func displayResult(_ trainingResult: TrainingResult) {
        scoreLabel.text = trainingResult.score
        averageAnswerTimeLabel.text = trainingResult.averageAnswerSecText
        goToTrainingButton.isHidden = !trainingResult.canRestart
        self.wrongKarutaNos = trainingResult.wrongKarutaNos
    }
}
