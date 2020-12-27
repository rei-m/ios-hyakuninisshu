//
//  TrainingPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/27.
//

import Foundation

protocol TrainingPresenterProtocol: AnyObject {
    func viewDidLoad()
}

class TrainingPresenter: TrainingPresenterProtocol {
    
    private weak var view: TrainingViewProtocol!
    private let model: TrainingModelProtocol
    
    init(view: TrainingViewProtocol, model: TrainingModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        view.updateLoading(true)

//        model.fetchKarutas() { [weak self] result in
//            self?.view.updateLoading(false)
//            switch result {
//            case .success(let karutas):
//                self?.view.updateMaterialTable(karutas.map { $0.toMaterial() })
//            case .failure(let error):
//                // TODO
//                print(error)
//            }
//        }
    }
}
