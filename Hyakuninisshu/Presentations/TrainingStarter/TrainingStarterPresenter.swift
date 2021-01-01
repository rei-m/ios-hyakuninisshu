//
//  TrainingStarterPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/29.
//

import Foundation
import Combine

protocol TrainingStarterPresenterProtocol: AnyObject {
    func viewDidLoad()
}

class TrainingStarterPresenter: TrainingStarterPresenterProtocol {
    private weak var view: TrainingStarterViewProtocol!
    private let model: TrainingStarterModelProtocol
    
    private var cancellables = [AnyCancellable]()
    
    init(view: TrainingStarterViewProtocol, model: TrainingStarterModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        model.createQuestions().receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                // TODO
                print(error)
            case .finished:
                return
            }
        }, receiveValue: { [weak self] questionCount in
            if (questionCount == 0) {
                self?.view.displayEmptyError()
            } else {
                guard let model = self?.model else {
                    return
                }
                self?.view.goToNextVC(
                    questionCount: questionCount,
                    questionNo: 1,
                    kamiNoKu: model.kamiNoKuCondition,
                    shimoNoKu: model.shimoNoKuCondition,
                    animationSpeed: model.animationSpeedCondition
                )
            }
        }).store(in: &cancellables)
    }
}
