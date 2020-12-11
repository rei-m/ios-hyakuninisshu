//
//  EntranceTabBarController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/11.
//

import UIKit

class EntranceTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("unko")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("unko")
    }
}
