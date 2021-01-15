//
//  QuestionPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/31.
//

import Foundation
import Combine

protocol QuestionPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapToriFuda(no: UInt8)
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

    func viewDidLoad() {
        model.fetchPlay().receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                // TODO
                print(error)
            case .finished:
                return
            }
        }, receiveValue: { [weak self] play in
            self?.view.setUpPlay(play)
            self?.view.startDisplayYomiFuda()
        }).store(in: &cancellables)
    }
    
    func didTapToriFuda(no: UInt8) {
        model.answer(selectedNo: no).receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                // TODO
                print(error)
            case .finished:
                return
            }
        }, receiveValue: { [weak self] result in
            self?.view.displayResult(selectedNo: no, isCorrect: result)
        }).store(in: &cancellables)
    }
    
    func didTapResult() {
        view.goToNextVC(questionNo: model.questionNo, kamiNoKu: model.kamiNoKu, shimoNoKu: model.shimoNoKu)
    }
}
