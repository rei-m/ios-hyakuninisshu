//
//  QuestionViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/29.
//

import UIKit

class QuestionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("QuestionViewController")

        let leftButton = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goTop))
        self.navigationItem.leftBarButtonItem = leftButton

        // Do any additional setup after loading the view.
    }

    
    @objc func goTop(){
      //トップ画面に戻る。
      self.navigationController?.popToRootViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
