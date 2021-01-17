//
//  SplashViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/04.
//

import UIKit
import Combine

class SplashViewController: UIViewController {

    private var cancellables = [AnyCancellable]()
    
    override func viewDidAppear(_ animated: Bool) {
        diContainer.karutaRepository.initialize().receive(on: DispatchQueue.main).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc: EntranceTabBarController = storyboard.instantiateViewController(identifier: .entrance)
                self?.present(vc, animated: false)
            case .failure(let e):
                self?.presentUnexpectedErrorVC(e)
            }
        }, receiveValue: { _ in
        }).store(in: &cancellables)
    }
}
