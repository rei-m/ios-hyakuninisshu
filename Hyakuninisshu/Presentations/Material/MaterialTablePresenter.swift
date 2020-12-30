//
//  MaterialTablePresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/10.
//

import Foundation
import Combine

protocol MaterialTablePresenterProtocol: AnyObject {
    func viewDidLoad()
}

class MaterialTablePresenter: MaterialTablePresenterProtocol {
    
    private weak var view: MaterialTableViewProtocol!
    private let model: MaterialTableModelProtocol
    
    private var cancellables = [AnyCancellable]()
    
    init(view: MaterialTableViewProtocol, model: MaterialTableModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        view.updateLoading(true)
        model.fetchKarutas2().receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                self.view.updateLoading(false)
            case .failure(let error):
                // TODO
                print(error)
            }
        }, receiveValue: { materials in
            self.view.updateMaterialTable(materials)
        }).store(in: &cancellables)
    }
}
