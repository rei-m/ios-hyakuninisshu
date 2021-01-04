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
}

class QuestionViewController: UIViewController {

    @IBOutlet weak var yomiFudaView: YomiFudaView!
    @IBOutlet weak var toriFudaView1: ToriFudaView!
    @IBOutlet weak var toriFudaView2: ToriFudaView!
    @IBOutlet weak var toriFudaView3: ToriFudaView!
    @IBOutlet weak var toriFudaView4: ToriFudaView!
    @IBOutlet weak var resultAreaView: UIView!
    @IBOutlet weak var resultImageView: UIImageView!

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
        title = play.position
        
        yomiFudaView.yomiFuda = play.yomiFuda
        toriFudaView1.toriFuda = play.toriFudas[0]
        toriFudaView2.toriFuda = play.toriFudas[1]
        toriFudaView3.toriFuda = play.toriFudas[2]
        toriFudaView4.toriFuda = play.toriFudas[3]
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
}
