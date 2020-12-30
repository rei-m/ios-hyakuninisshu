//
//  TrainingStarterPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/29.
//

import Foundation

protocol TrainingStarterPresenterProtocol: AnyObject {
    func viewDidLoad()
}

class TrainingStarterPresenter: TrainingStarterPresenterProtocol {
    private weak var view: TrainingStarterViewProtocol!
    private let model: TrainingStarterModelProtocol
    
    init(view: TrainingStarterViewProtocol, model: TrainingStarterModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        let questionCount = model.createQuestions()
        
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
    }
}
