//
//  QuestionViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/29.
//

import UIKit

protocol QuestionViewProtocol: AnyObject {
    func setUpPlay(_ play: Play)
    func startDisplayYomiFuda()
    func displayResult(selectedNo: Int8, isCorrect: Bool)
    func goToNextVC(
        questionNo: Int,
        kamiNoKu: DisplayStyleCondition,
        shimoNoKu: DisplayStyleCondition
    )
}

class QuestionViewController: UIViewController {

    @IBOutlet weak var yomiFudaView: YomiFudaView!
    @IBOutlet weak var toriFudaView1: ToriFudaView!
    @IBOutlet weak var toriFudaView2: ToriFudaView!
    @IBOutlet weak var toriFudaView3: ToriFudaView!
    @IBOutlet weak var toriFudaView4: ToriFudaView!
    @IBOutlet weak var resultAreaView: UIView!
    @IBOutlet weak var resultImageView: UIImageView!

    private var questionCount: Int!
    private var animationSpeed: AnimationSpeedCondition!
    
    private var presenter: QuestionPresenterProtocol!
    
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLeftBackButton()
        tabBarController?.tabBar.isHidden = true
        
        presenter.viewDidLoad()
    }
    
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
    
    private func didTapToriFuda(_ toriFudaView: ToriFudaView) {
        guard let no = toriFudaView.toriFuda?.karutaNo else {
            return
        }
        presenter.didTapToriFuda(no: no)
    }
    
    func inject(questionCount: Int, animationSpeed: AnimationSpeedCondition, presenter: QuestionPresenterProtocol) {
        self.questionCount = questionCount
        self.animationSpeed = animationSpeed
        self.presenter = presenter
    }
}

extension QuestionViewController: QuestionViewProtocol {
    func setUpPlay(_ play: Play) {
        self.play = play
    }
    
    func startDisplayYomiFuda() {
        yomiFudaView.startAnimation()
    }
    
    func displayResult(selectedNo: Int8, isCorrect: Bool) {
        yomiFudaView.stopAnimation()
        [toriFudaView1, toriFudaView2, toriFudaView3, toriFudaView4].forEach {
            if ($0?.toriFuda?.karutaNo != selectedNo) {
                $0?.alpha = 0
            }
        }
        resultImageView.image = isCorrect ? #imageLiteral(resourceName: "Correct") : #imageLiteral(resourceName: "Wrong")
        resultAreaView.isHidden = false
    }

    func goToNextVC(questionNo: Int, kamiNoKu: DisplayStyleCondition, shimoNoKu: DisplayStyleCondition) {
        guard let correct = play?.correct else {
            return
        }

        let vc: AnswerViewController = requireStoryboard.instantiateViewController(identifier: .answer)

        vc.inject(material: correct, questionNo: questionNo, questionCount: questionCount, kamiNoKu: kamiNoKu, shimoNoKu: shimoNoKu, animationSpeed: animationSpeed)
        
        requireNavigationController.replace(vc)
    }
}
