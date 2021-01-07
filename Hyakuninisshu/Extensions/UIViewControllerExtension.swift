//
//  UIViewControllerExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/10.
//

import Foundation
import UIKit

extension UIViewController {
    var karutaRepository: KarutaRepositoryProtocol {
        get {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                // TODO
                fatalError("")
            }
            return appDelegate.karutaRepository
        }
    }
    
    var questionRepository: QuestionRepositoryProtocol {
        get {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                // TODO
                fatalError("")
            }
            return appDelegate.questionRepository
        }
    }
    
    func setUpLeftBackButton() {
        let leftButton = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(popToNaviRoot))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func popToNaviRoot(){
        guard let navigationController = navigationController else {
            fatalError("missing navigationController. confirm storyboard.")
        }
        navigationController.popToRootViewController(animated: true)
    }
}
