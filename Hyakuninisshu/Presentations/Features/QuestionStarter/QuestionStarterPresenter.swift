//
//  TrainingStarterPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/29.
//

import Foundation
import Combine

protocol QuestionStarterPresenterProtocol: AnyObject {
    func viewDidLoad()
}

class QuestionStarterPresenter: QuestionStarterPresenterProtocol {
    private weak var view: QuestionStarterViewProtocol!
    private let model: QuestionStarterModelProtocol
    
    private var cancellables = [AnyCancellable]()
    
    init(view: QuestionStarterViewProtocol, model: QuestionStarterModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        model.createQuestions().receive(on: DispatchQueue.main).sink(receiveCompletion: { [weak self] completion in
            guard case let .failure(error) = completion else {
                return
            }
            self?.view.presentErrorVC(error)
        }, receiveValue: { [weak self] questionCount in
            if (questionCount == 0) {
                self?.view.displayEmptyMessage()
            } else {
                self?.view.presentNextVC(questionCount: questionCount, questionNo: 1)
            }
        }).store(in: &cancellables)
    }
}
