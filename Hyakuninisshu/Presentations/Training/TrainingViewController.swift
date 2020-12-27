//
//  TrainingViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import UIKit

protocol TrainingViewProtocol: AnyObject {
    func updateLoading(_ isLoading: Bool)
    func displayError(_ message: String)
}

class TrainingViewController: UIViewController, TrainingViewProtocol {

    @IBOutlet weak var rangeFromPicker: KeyboardPicker!
    @IBOutlet weak var rangeToPicker: KeyboardPicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        rangeFromPicker.setUpData(data: RangeCondition.FROM_DATA, currentItemIndex: 0)
        rangeToPicker.setUpData(data: RangeCondition.TO_DATA, currentItemIndex: RangeCondition.TO_DATA.count - 1)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - View methods
    func updateLoading(_ isLoading: Bool) {
        // deprecatedになった
        // UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
    }

    func displayError(_ message: String) {
        // TODO
        print("Error: \(message)")
    }
}
