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
        questionCount: Int,
        questionNo: Int,
        kamiNoKu: DisplayStyleCondition,
        shimoNoKu: DisplayStyleCondition,
        animationSpeed: AnimationSpeedCondition
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

    private var _play: Play?
    private var play: Play? {
        get { _play }
        set(v) {
            _play = v
            guard let _play = v else {
                return
            }
            title = _play.position
            yomiFudaView.yomiFuda = _play.yomiFuda
            toriFudaView1.toriFuda = _play.toriFudas[0]
            toriFudaView2.toriFuda = _play.toriFudas[1]
            toriFudaView3.toriFuda = _play.toriFudas[2]
            toriFudaView4.toriFuda = _play.toriFudas[3]
        }
    }
    
    private var presenter: QuestionPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftButton = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goTop))
        navigationItem.leftBarButtonItem = leftButton
        tabBarController?.tabBar.isHidden = true
        
        // Do any additional setup after loading the view.
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
    
    @objc func goTop(){
      navigationController?.popToRootViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func inject(presenter: QuestionPresenterProtocol) {
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

    func goToNextVC(
        questionCount: Int,
        questionNo: Int,
        kamiNoKu: DisplayStyleCondition,
        shimoNoKu: DisplayStyleCondition,
        animationSpeed: AnimationSpeedCondition
    ) {
        guard let vc = storyboard?.instantiateViewController(identifier: "AnswerViewController") as? AnswerViewController else {
            fatalError("unknown VC identifier value='AnswerViewController'")
        }
        
//        let model = QuestionModel(questionCount: questionCount, questionNo: questionNo, kamiNoKu: kamiNoKu, shimoNoKu: shimoNoKu, animationSpeed: animationSpeed, karutaRepository: karutaRepository, questionRepository: questionRepository)
//        let presenter = QuestionPresenter(view: vc, model: model)
//
//        vc.inject(presenter: presenter)
        
//        navigationController?.pushViewController(vc, animated: false)
//                navigationController?.popViewController(animated: false)
        guard var currentVCs = navigationController?.viewControllers else {
            return
        }
        guard let correct = play?.correct else {
            return
        }

        vc.material = correct
        vc.questionCount = questionCount
        vc.questionNo = questionNo
        vc.kamiNoKu = kamiNoKu
        vc.shimoNoKu = shimoNoKu
        vc.animationSpeed = animationSpeed
        
        currentVCs.removeLast()
        currentVCs.append(vc)
        navigationController?.setViewControllers(currentVCs, animated: false)
    }
}
