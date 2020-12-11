//
//  SplashViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/04.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        guard let initializeResult = karutaRepository?.initialize() else {
            return
        }

        switch initializeResult {
        case .success(_):
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let entrancePage = storyboard.instantiateViewController(withIdentifier: "EntrancePageViewController") as! UITabBarController
            self.present(entrancePage, animated: false)
        case .failure(let error):
            // TODO
            print(error)
        }
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
