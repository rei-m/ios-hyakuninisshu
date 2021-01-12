//
//  ExamHistoryPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/11.
//

import Foundation
import Combine

protocol ExamHistoryPresenterProtocol: AnyObject {
    func viewDidLoad()
}

class ExamHistoryPresenter: ExamHistoryPresenterProtocol {
    
    private weak var view: ExamHistoryTableViewProtocol!
    private let model: ExamHistoryModelProtocol
    
    private var cancellables = [AnyCancellable]()
    
    init(view: ExamHistoryTableViewProtocol, model: ExamHistoryModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        view.updateLoading(true)
        model.fetchScores().receive(on: DispatchQueue.main).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                self?.view.updateLoading(false)
            case .failure(let error):
                // TODO
                print(error)
            }
        }, receiveValue: { [weak self] scores in
            self?.view.updateTable(scores)
        }).store(in: &cancellables)
    }
}
