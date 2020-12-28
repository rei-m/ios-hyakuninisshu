//
//  TrainingPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/27.
//

import Foundation

protocol TrainingPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didChangeRangeFrom(_ condition: RangeCondition)
    func didChangeRangeTo(_ condition: RangeCondition)
    func didChangeKimariji(_ condition: KimarijiCondition)
    func didChangeColor(_ condition: ColorCondition)
    func didChangeKamiNoKu(_ condition: DisplayStyleCondition)
    func didChangeShimoNoKu(_ condition: DisplayStyleCondition)
    func didChangeAnimationSpeed(_ condition: AnimationSpeedCondition)
}

class TrainingPresenter: TrainingPresenterProtocol {
    
    private weak var view: TrainingViewProtocol!
    private let model: TrainingModelProtocol
    
    init(view: TrainingViewProtocol, model: TrainingModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        view.updateRangeFrom(model.rangeFromCondition)
        view.updateRangeTo(model.rangeToCondition)
        view.updateKimariji(model.kimarijiCondition)
        view.updateColor(model.colorCondition)
        view.updateKamiNoKu(model.kamiNoKuCondition)
        view.updateShimoNoKu(model.shimoNoKuCondition)
        view.updateAnimationSpeed(model.animationSpeedCondition)

//        view.updateLoading(true)

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
    
    func didChangeRangeFrom(_ condition: RangeCondition) {
        model.rangeFromCondition = condition
        view.updateRangeFrom(condition)
        view.updateRangeError(model.rangeConditionError)
    }
    
    func didChangeRangeTo(_ condition: RangeCondition) {
        model.rangeToCondition = condition
        view.updateRangeTo(condition)
        view.updateRangeError(model.rangeConditionError)
    }
    
    func didChangeKimariji(_ condition: KimarijiCondition) {
        model.kimarijiCondition = condition
        view.updateKimariji(condition)
    }
    
    func didChangeColor(_ condition: ColorCondition) {
        model.colorCondition = condition
        view.updateColor(condition)
    }
    
    func didChangeKamiNoKu(_ condition: DisplayStyleCondition) {
        model.kamiNoKuCondition = condition
        view.updateKamiNoKu(condition)
    }
    
    func didChangeShimoNoKu(_ condition: DisplayStyleCondition) {
        model.shimoNoKuCondition = condition
        view.updateShimoNoKu(condition)
    }
    
    func didChangeAnimationSpeed(_ condition: AnimationSpeedCondition) {
        model.animationSpeedCondition = condition
        view.updateAnimationSpeed(condition)
    }
}
