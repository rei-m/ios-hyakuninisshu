//
//  UIViewControllerExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/10.
//

import Foundation
import UIKit

extension UIViewController {
    var requireAppDelegate: AppDelegate {
        get {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError("Missing appdelegate.")
            }
            return appDelegate
        }
    }
        
    var requireStoryboard: UIStoryboard {
        get {
            guard let storyboard = storyboard else {
                fatalError("Missing storyboard.")
            }
            return storyboard
        }
    }
    
    var requireNavigationController: UINavigationController {
        get {
            guard let navigationController = navigationController else {
                fatalError("Missing navigationController.")
            }
            return navigationController
        }
    }

    var karutaRepository: KarutaRepositoryProtocol {
        get { requireAppDelegate.karutaRepository }
    }
    
    var questionRepository: QuestionRepositoryProtocol {
        get { requireAppDelegate.questionRepository }
    }
    
    func setUpLeftBackButton() {
        let leftButton = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(popToNaviRoot))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func popToNaviRoot(){
        requireNavigationController.popToRootViewController(animated: true)
    }
}
