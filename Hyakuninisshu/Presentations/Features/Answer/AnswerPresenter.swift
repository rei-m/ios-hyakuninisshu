//
//  AnswerPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import Combine

protocol AnswerPresenterProtocol: AnyObject {
    func didTapGoToNext()
    func didTapGoToTrainingResult()
    func didTapGoToExamResult()
}

class AnswerPresenter: AnswerPresenterProtocol {
    private weak var view: AnswerViewProtocol!
    private let model: AnswerModelProtocol
    
    private var cancellables = [AnyCancellable]()
    
    init(view: AnswerViewProtocol, model: AnswerModelProtocol) {
        self.view = view
        self.model = model
    }

    func didTapGoToNext() {
        view.goToNextQuestion()
    }

    func didTapGoToTrainingResult() {
        model.aggregateTrainingResult().receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                // TODO
                print(error)
            case .finished:
                return
            }
        }, receiveValue: { [weak self] trainingResult in
            self?.view.goToTrainingResult(trainingResult)
        }).store(in: &cancellables)
    }

    func didTapGoToExamResult() {
        model.saveExamHistory().receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                // TODO
                print(error)
            case .finished:
                return
            }
        }, receiveValue: { [weak self] examHistory in
            self?.view.goToExamResult(examHistory)
        }).store(in: &cancellables)
    }
}
