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
        karutaRepository.initialize().receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let e):
                // TODO
                print(e)
            case .finished:
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = storyboard.instantiateViewController(withIdentifier: "EntrancePageViewController") as? UITabBarController else {
                    fatalError("unknown identifier value is='EntrancePageViewController'")
                }
                self.present(vc, animated: false)
            }
        }, receiveValue: { _ in
        }).store(in: &cancellables)
        
        print("viewDidAppear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        cancellables.forEach { cancellable in cancellable.cancel() }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
