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
    private var presenter: TrainingResultPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func inject(presenter: TrainingResultPresenterProtocol) {
        self.presenter = presenter
    }
}

extension TrainingResultViewController: TrainingResultViewProtocol {
    func displayResult(_ trainingResult: TrainingResult) {
        dump(trainingResult)
    }
}
