//
//  ViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/11/27.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let repo: KarutaRepositoryProtocol = KarutaRepository(container: appDelegate.persistentContainer)
        let res = repo.initialize()
        print(res)
    }


}

