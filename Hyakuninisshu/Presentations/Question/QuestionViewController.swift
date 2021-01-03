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
}

class QuestionViewController: UIViewController {

    @IBOutlet weak var yomiFudaView: YomiFudaView!
    @IBOutlet weak var toriFudaView1: ToriFudaView!
    @IBOutlet weak var toriFudaView2: ToriFudaView!
    @IBOutlet weak var toriFudaView3: ToriFudaView!
    @IBOutlet weak var toriFudaView4: ToriFudaView!
        
    private var presenter: QuestionPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftButton = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goTop))
        navigationItem.leftBarButtonItem = leftButton

        tabBarController?.tabBar.isHidden = true
        
        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
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
}
