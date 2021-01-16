//
//  QuestionPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/31.
//

import Foundation
import Combine

protocol QuestionPresenterProtocol: AnyObject {
    func viewDidLoad(now: Date)
    func didTapToriFuda(now: Date, no: UInt8)
    func didTapResult()
}

class QuestionPresenter: QuestionPresenterProtocol {
    private weak var view: QuestionViewProtocol!
    private let model: QuestionModelProtocol
    
    private var cancellables = [AnyCancellable]()
    
    init(view: QuestionViewProtocol, model: QuestionModelProtocol) {
        self.view = view
        self.model = model
    }

    func viewDidLoad(now: Date) {
        model.start(startDate: now).receive(on: DispatchQueue.main).sink(receiveCompletion: { [weak self]  completion in
            guard case let .failure(error) = completion else {
                return
            }
            self?.view.presentErrorVC(error)
        }, receiveValue: { [weak self] play in
            self?.view.startPlay(play)
        }).store(in: &cancellables)
    }
    
    func didTapToriFuda(now: Date, no: UInt8) {
        model.answer(answerDate: now, selectedNo: no).receive(on: DispatchQueue.main).sink(receiveCompletion: { [weak self]  completion in
            guard case let .failure(error) = completion else {
                return
            }
            self?.view.presentErrorVC(error)
        }, receiveValue: { [weak self] result in
            self?.view.displayResult(selectedNo: no, isCorrect: result)
        }).store(in: &cancellables)
    }
    
    func didTapResult() {
        view.presentNextVC(questionNo: model.questionNo, kamiNoKu: model.kamiNoKu, shimoNoKu: model.shimoNoKu)
    }
}
