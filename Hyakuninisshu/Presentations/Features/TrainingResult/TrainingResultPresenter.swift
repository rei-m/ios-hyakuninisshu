//
//  TrainingResultPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/06.
//

import Foundation
import Combine

protocol TrainingResultPresenterProtocol: AnyObject {
    func viewDidLoad()
}

class TrainingResultPresenter: TrainingResultPresenterProtocol {
    private weak var view: TrainingResultViewProtocol!
    private let model: TrainingResultModelProtocol
    
    private var cancellables = [AnyCancellable]()
    
    init(view: TrainingResultViewProtocol, model: TrainingResultModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        model.fetchResult().receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                // TODO
                print(error)
            case .finished:
                return
            }
        }, receiveValue: { [weak self] trainingResult in
            self?.view.displayResult(trainingResult)
        }).store(in: &cancellables)
    }
}
