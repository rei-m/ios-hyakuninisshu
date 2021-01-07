//
//  AnswerViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/04.
//

import UIKit

extension UIViewController {
//    func setUpBackButton() {
//        let leftButton = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goTop))
//        navigationItem.leftBarButtonItem = leftButton
//        tabBarController?.tabBar.isHidden = true
//    }
//
//    @objc func goTop(){
//      navigationController?.popToRootViewController(animated: true)
//    }
}

class AnswerViewController: UIViewController {

    @IBOutlet weak var fudaView: FudaView!
    @IBOutlet weak var noAndKimarijiLabel: UILabel!
    
    public var material: Material!
    public var questionNo: Int!
    public var questionCount: Int!
    public var kamiNoKu: DisplayStyleCondition!
    public var shimoNoKu: DisplayStyleCondition!
    public var animationSpeed: AnimationSpeedCondition!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let leftButton = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goTop))
        navigationItem.leftBarButtonItem = leftButton
        tabBarController?.tabBar.isHidden = true
        
        fudaView.material = material
        noAndKimarijiLabel.text = "\(material.noTxt) / \(material.kimarijiTxt)"
    }
    
    @IBAction func goToNextVC(_ sender: UIButton) {
        navigationController?.viewControllers.forEach { vc in
            print(vc is TrainingViewController)
        }
        if (questionNo == questionCount) {
            guard let vc = storyboard?.instantiateViewController(identifier: "TrainingResultViewController") as? TrainingResultViewController else {
                fatalError("unknown VC identifier value='TrainingResultViewController'")
            }
            guard var currentVCs = navigationController?.viewControllers else {
                return
            }
            let model = TrainingResultModel(questionRepository: questionRepository)
            let presenter = TrainingResultPresenter(view: vc, model: model)

            vc.inject(
                presenter: presenter,
                kamiNoKu: kamiNoKu,
                shimoNoKu: shimoNoKu,
                animationSpeed: animationSpeed
            )

            currentVCs.removeLast()
            currentVCs.append(vc)
            navigationController?.setViewControllers(currentVCs, animated: false)
            return
        }
        
        guard let vc = storyboard?.instantiateViewController(identifier: "QuestionViewController") as? QuestionViewController else {
            fatalError("unknown VC identifier value='QuestionViewController'")
        }
        guard var currentVCs = navigationController?.viewControllers else {
            return
        }

        let model = QuestionModel(questionCount: questionCount, questionNo: questionNo + 1, kamiNoKu: kamiNoKu, shimoNoKu: shimoNoKu, animationSpeed: animationSpeed, karutaRepository: karutaRepository, questionRepository: questionRepository)
        let presenter = QuestionPresenter(view: vc, model: model)

        vc.inject(presenter: presenter)

        currentVCs.removeLast()
        currentVCs.append(vc)
        navigationController?.setViewControllers(currentVCs, animated: false)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let destinationVC = segue.destination as? MaterialDetailViewController else {
            // TODO
            fatalError()
        }
        destinationVC.material = material
    }
    
    @objc func goTop(){
      navigationController?.popToRootViewController(animated: true)
    }
}
