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
        }).store(in: &cancellables)
    }
}
