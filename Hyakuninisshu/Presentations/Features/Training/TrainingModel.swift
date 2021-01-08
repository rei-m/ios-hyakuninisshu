//
//  TrainingModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/27.
//

import Foundation
import Combine

protocol TrainingModelProtocol: AnyObject {
    var rangeFromCondition: RangeCondition { get set }
    var rangeToCondition: RangeCondition { get set }
    var kimarijiCondition: KimarijiCondition { get set }
    var colorCondition: ColorCondition { get set }
    var kamiNoKuCondition: DisplayStyleCondition { get set }
    var shimoNoKuCondition: DisplayStyleCondition { get set }
    var animationSpeedCondition: AnimationSpeedCondition { get set }
    var rangeConditionError: String? { get }
    var hasError: Bool { get }
    
    func fetchQuestionKarutaNos() -> AnyPublisher<[Int8], ModelError>
}

class TrainingModel: TrainingModelProtocol {
    private var _rangeFromCondition: RangeCondition = RangeCondition.FROM_DATA.first!
    var rangeFromCondition: RangeCondition {
        get { _rangeFromCondition }
        set(v) {
            _rangeFromCondition = v
            validateRangeCondition()
        }
    }
    private var _rangeToCondition: RangeCondition = RangeCondition.TO_DATA.last!
    var rangeToCondition: RangeCondition {
        get { _rangeToCondition }
        set(v) {
            _rangeToCondition = v
            validateRangeCondition()
        }
    }
    var kimarijiCondition = KimarijiCondition.DATA.first!
    var colorCondition = ColorCondition.DATA.first!
    var kamiNoKuCondition = DisplayStyleCondition.DATA.first!
    var shimoNoKuCondition = DisplayStyleCondition.DATA.last!
    var animationSpeedCondition = AnimationSpeedCondition.DATA[2]

    private var _rangeConditionError: String?
    var rangeConditionError: String? {
        get { _rangeConditionError }
    }
    
    var hasError: Bool {
        get { _rangeConditionError != nil }
    }

    private func validateRangeCondition() {
        if (_rangeToCondition.no < _rangeFromCondition.no) {
            _rangeConditionError = "出題範囲の始まりは終わりより小さい数を指定してください"
        } else {
            _rangeConditionError = nil
        }
    }

    private let karutaRepository: KarutaRepositoryProtocol

    init(karutaRepository: KarutaRepositoryProtocol) {
        self.karutaRepository = karutaRepository
    }
    
    func fetchQuestionKarutaNos() -> AnyPublisher<[Int8], ModelError> {
        let publisher = karutaRepository.findAll(
            fromNo: KarutaNo(rangeFromCondition.no),
            toNo: KarutaNo(rangeToCondition.no),
            kimarijis: kimarijiCondition.value == nil ? Kimariji.ALL : [Kimariji.valueOf(value: kimarijiCondition.value!)],
            colors: colorCondition.value == nil  ? KarutaColor.ALL : [KarutaColor.valueOf(value: colorCondition.value!)]
        ).map { $0.map { karuta in karuta.no.value } }
        return publisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
}
