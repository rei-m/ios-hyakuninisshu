//
//  QuestionViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/29.
//

import UIKit

protocol QuestionViewProtocol: AnyObject {

}

class QuestionViewController: UIViewController {

    private var presenter: QuestionPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("QuestionViewController")

        let leftButton = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goTop))
        navigationItem.leftBarButtonItem = leftButton

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
    
}
