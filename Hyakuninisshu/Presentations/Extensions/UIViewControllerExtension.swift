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

    var karutaRepository: KarutaRepository {
        get { requireAppDelegate.karutaRepository }
    }
    
    var questionRepository: QuestionRepository {
        get { requireAppDelegate.questionRepository }
    }
    
    var examHistoryRepository: ExamHistoryRepository {
        get { requireAppDelegate.examHistoryRepository }
    }
    
    func showUnexpectedErrorDialog() {
        let alert = UIAlertController(
            title: "エラー",
            message: "予期しないエラーが発生しました。アプリを終了してください。",
            preferredStyle: .alert
        )

        let defaultAction = UIAlertAction(title: "閉じる", style: .default)
        alert.addAction(defaultAction)
        
        self.present(alert, animated: true)
    }

    func setUpLeftBackButton() {
        let leftButton = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(popToNaviRoot))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func popToNaviRoot(){
        requireNavigationController.popToRootViewController(animated: true)
    }
}
