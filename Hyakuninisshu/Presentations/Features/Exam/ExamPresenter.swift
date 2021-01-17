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
        view.hideLastResult()

        model.fetchLastExamScore().receive(on: DispatchQueue.main).sink(receiveCompletion: { [weak self] completion in
            guard case let .failure(error) = completion else {
                return
            }
            self?.view.presentErrorVC(error)
        }, receiveValue: { [weak self] examScore in
            guard let examScore = examScore else {
                return
            }
            self?.view.displayLastResult(examScore)
        }).store(in: &cancellables)
    }
    
    func didTapStartExamButton() {
        model.fetchExamKarutaNos().receive(on: DispatchQueue.main).sink(receiveCompletion: { [weak self] completion in
            guard case let .failure(error) = completion else {
                return
            }
            self?.view.presentErrorVC(error)
        }, receiveValue: { [weak self] karutaNos in
            self?.view.presentNextVC(karutaNos: karutaNos)
        }).store(in: &cancellables)
    }
    
    func didTapStartTrainingButton() {
        model.fetchPastExamsWrongKarutaNos().receive(on: DispatchQueue.main).sink(receiveCompletion: { [weak self] completion in
            guard case let .failure(error) = completion else {
                return
            }
            self?.view.presentErrorVC(error)
        }, receiveValue: { [weak self] karutaNos in
            self?.view.presentNextVC(karutaNos: karutaNos)
        }).store(in: &cancellables)
    }
}
