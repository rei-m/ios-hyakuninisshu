//
//  QuestionViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/29.
//

import UIKit

protocol QuestionViewProtocol: AnyObject {
    func startPlay(_ play: Play)
    func displayResult(selectedNo: UInt8, isCorrect: Bool)
    func presentNextVC(questionNo: UInt8, kamiNoKu: DisplayStyleCondition, shimoNoKu: DisplayStyleCondition)
    func presentErrorVC(_ error: Error)
}

class QuestionViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var yomiFudaView: YomiFudaView!
    @IBOutlet weak var toriFudaView1: ToriFudaView!
    @IBOutlet weak var toriFudaView2: ToriFudaView!
    @IBOutlet weak var toriFudaView3: ToriFudaView!
    @IBOutlet weak var toriFudaView4: ToriFudaView!
    @IBOutlet weak var resultAreaView: UIView!
    @IBOutlet weak var resultImageView: UIImageView!

    // MARK: - Property
    private var presenter: QuestionPresenterProtocol!

    private var questionCount: Int!
    private var animationSpeed: AnimationSpeedCondition!
        
    private var _play: Play?
    private var play: Play? {
        get { _play }
        set(v) {
            _play = v
            guard let _play = v else {
                return
            }
            title = "\(_play.no) / \(questionCount ?? 0)"
            yomiFudaView.yomiFuda = _play.yomiFuda
            toriFudaView1.toriFuda = _play.toriFudas[0]
            toriFudaView2.toriFuda = _play.toriFudas[1]
            toriFudaView3.toriFuda = _play.toriFudas[2]
            toriFudaView4.toriFuda = _play.toriFudas[3]
        }
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLeftBackButton()
        presenter.viewDidLoad(now: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Action
    @IBAction func didTapToriFuda1(_ sender: UITapGestureRecognizer) {
        didTapToriFuda(toriFudaView1)
    }
    
    @IBAction func didTapToriFuda2(_ sender: UITapGestureRecognizer) {
        didTapToriFuda(toriFudaView2)
    }

    @IBAction func didTapToriFuda3(_ sender: UITapGestureRecognizer) {
        didTapToriFuda(toriFudaView3)
    }
    
    @IBAction func didTapToriFuda4(_ sender: UITapGestureRecognizer) {
        didTapToriFuda(toriFudaView4)
    }

    @IBAction func didTapResultArea(_ sender: UITapGestureRecognizer) {
        presenter.didTapResult()
    }
        
    // MARK: - Method
    func inject(questionCount: Int, animationSpeed: AnimationSpeedCondition, presenter: QuestionPresenterProtocol) {
        self.questionCount = questionCount
        self.animationSpeed = animationSpeed
        self.presenter = presenter
    }
    
    private func didTapToriFuda(_ toriFudaView: ToriFudaView) {
        guard let no = toriFudaView.toriFuda?.karutaNo else {
            return
        }
        presenter.didTapToriFuda(now: Date(), no: no)
    }
}

extension QuestionViewController: QuestionViewProtocol {
    func startPlay(_ play: Play) {
        self.play = play
        yomiFudaView.startAnimation(animationSpeed)
    }
    
    func displayResult(selectedNo: UInt8, isCorrect: Bool) {
        yomiFudaView.stopAnimation()
        [toriFudaView1, toriFudaView2, toriFudaView3, toriFudaView4].forEach {
            if ($0?.toriFuda?.karutaNo != selectedNo) {
                $0?.alpha = 0.4
            }
        }
        resultImageView.image = isCorrect ? #imageLiteral(resourceName: "Correct") : #imageLiteral(resourceName: "Wrong")
        resultAreaView.isHidden = false
    }

    func presentNextVC(questionNo: UInt8, kamiNoKu: DisplayStyleCondition, shimoNoKu: DisplayStyleCondition) {
        guard let correct = play?.correct else {
            return
        }

        let vc: AnswerViewController = requireStoryboard.instantiateViewController(identifier: .answer)

        let model = AnswerModel(karutaRepository: diContainer.karutaRepository, questionRepository: diContainer.questionRepository, examHistoryRepository: diContainer.examHistoryRepository)
        let presenter = AnswerPresenter(view: vc, model: model)
        
        vc.inject(presenter: presenter, material: correct, questionNo: questionNo, questionCount: questionCount, kamiNoKu: kamiNoKu, shimoNoKu: shimoNoKu, animationSpeed: animationSpeed)
        
        requireNavigationController.replace(vc)
    }

    func presentErrorVC(_ error: Error) {
        presentUnexpectedErrorVC(error)
    }
}
