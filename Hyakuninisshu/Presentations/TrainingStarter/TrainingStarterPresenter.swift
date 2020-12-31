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
    func viewDidDisappear()
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
        }, receiveValue: { [self] questionCount in
            if (questionCount == 0) {
                view.displayEmptyError()
            } else {
                view.goToNextVC(
                    questionCount: questionCount,
                    questionNo: 1,
                    kamiNoKu: model.kamiNoKuCondition,
                    shimoNoKu: model.shimoNoKuCondition,
                    animationSpeed: model.animationSpeedCondition
                )
            }
        }).store(in: &cancellables)
    }
    
    func viewDidDisappear() {
        cancellables.forEach { $0.cancel() }
    }
}
