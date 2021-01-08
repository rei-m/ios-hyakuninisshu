//
//  ExamPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import Combine

protocol ExamPresenterProtocol: AnyObject {
    func didTapStartExamButton()
}

class ExamPresenter: ExamPresenterProtocol {

    private weak var view: ExamViewProtocol!
    private let model: ExamModelProtocol
    
    private var cancellables = [AnyCancellable]()
    
    init(view: ExamViewProtocol, model: ExamModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func didTapStartExamButton() {
        model.fetchQuestionKarutaNos().receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                // TODO
                print(error)
            case .finished:
                return
            }
        }, receiveValue: { [weak self] karutaNos in
            self?.view.goToNextVC(karutaNos: karutaNos)
        }).store(in: &cancellables)
    }
}
