//
//  MaterialTablePresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/10.
//

import Foundation

protocol MaterialTablePresenterProtocol: AnyObject {
    func viewDidLoad()
}

class MaterialTablePresenter: MaterialTablePresenterProtocol {
    
    private weak var view: MaterialTableViewProtocol!
    private let model: MaterialTableModelProtocol
    
    init(view: MaterialTableViewProtocol, model: MaterialTableModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        view.updateLoading(true)

        model.fetchKarutas() { [weak self] result in
            self?.view.updateLoading(false)
            switch result {
            case .success(let karutas):
                self?.view.updateMaterialTable(karutas.map { $0.toMaterial() })
            case .failure(let error):
                // TODO
                print(error)
            }
        }
    }
}
