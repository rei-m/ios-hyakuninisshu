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
                fatalError("Missing AppDelegate.")
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

    var diContainer: DIContainer {
        get { requireAppDelegate.diContainer }
    }
    
    func presentUnexpectedErrorVC(_ error: Error) {
        let storyboard = UIStoryboard(name: "Error", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: .fatalError)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }

    func setUpLeftBackButton() {
        let leftButton = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(popToNaviRoot))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func popToNaviRoot(){
        requireNavigationController.popToRootViewController(animated: true)
    }
}
