//
//  AnswerViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/04.
//

import UIKit

class AnswerViewController: UIViewController {

    @IBOutlet weak var fudaView: FudaView!
    @IBOutlet weak var noAndKimarijiLabel: UILabel!
    
    public var material: Material!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let leftButton = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goTop))
        navigationItem.leftBarButtonItem = leftButton
        tabBarController?.tabBar.isHidden = true
        
        fudaView.material = material
        noAndKimarijiLabel.text = "\(material.noTxt) / \(material.kimarijiTxt)"
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let destinationVC = segue.destination as? MaterialDetailViewController else {
            // TODO
            fatalError()
        }
        destinationVC.material = material
    }
    
    @objc func goTop(){
      navigationController?.popToRootViewController(animated: true)
    }
}
