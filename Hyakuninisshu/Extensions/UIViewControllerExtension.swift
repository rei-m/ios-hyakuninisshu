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
}
