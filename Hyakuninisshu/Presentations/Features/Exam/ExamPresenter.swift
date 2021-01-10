//
//  ExamPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import Combine

protocol ExamPresenterProtocol: AnyObject {
    func viewWillAppear()
    func didTapStartExamButton()
    func didTapStartTrainingButton()
}

class ExamPresenter: ExamPresenterProtocol {

    private weak var view: ExamViewProtocol!
    private let model: ExamModelProtocol
    
    private var cancellables = [AnyCancellable]()
    
    init(view: ExamViewProtocol, model: ExamModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func viewWillAppear() {
        model.fetchLastExamScore().receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                // TODO
                print(error)
            case .finished:
                return
            }
        }, receiveValue: { [weak self] examScore in
            guard let examScore = examScore else {
                return
            }
            self?.view.displayLastResult(examScore)
        }).store(in: &cancellables)
    }
    
    func didTapStartExamButton() {
        model.fetchExamKarutaNos().receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
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
    
    func didTapStartTrainingButton() {
        model.fetchPastExamsWrongKarutaNos().receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
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
