//
//  TrainingStarterViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/29.
//

import UIKit

class TrainingStarterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("TrainingStarterViewController")

        // Do any additional setup after loading the view.

        let vc = storyboard?.instantiateViewController(identifier: "QuestionViewController")
        navigationController?.pushViewController(vc!, animated: false)
    }
    
    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        print("unko")
//    }

}
