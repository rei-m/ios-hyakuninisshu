//
//  TrainingModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/27.
//

import Foundation

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
}

class TrainingModel: TrainingModelProtocol {
    private var _rangeFromCondition: RangeCondition = RangeCondition.FROM_DATA.first!
    public var rangeFromCondition: RangeCondition {
        get { _rangeFromCondition }
        set(v) {
            _rangeFromCondition = v
            validateRangeCondition()
        }
    }
    private var _rangeToCondition: RangeCondition = RangeCondition.TO_DATA.last!
    public var rangeToCondition: RangeCondition {
        get { _rangeToCondition }
        set(v) {
            _rangeToCondition = v
            validateRangeCondition()
        }
    }
    public var kimarijiCondition = KimarijiCondition.DATA.first!
    public var colorCondition = ColorCondition.DATA.first!
    public var kamiNoKuCondition = DisplayStyleCondition.DATA.first!
    public var shimoNoKuCondition = DisplayStyleCondition.DATA.last!
    public var animationSpeedCondition = AnimationSpeedCondition.DATA[2]

    private var _rangeConditionError: String?
    public var rangeConditionError: String? {
        get { _rangeConditionError }
    }
    
    public var hasError: Bool {
        get { _rangeConditionError != nil }
    }
    
    private let karutaRepository: KarutaRepositoryProtocol
    
    init(karutaRepository: KarutaRepositoryProtocol) {
        self.karutaRepository = karutaRepository
    }
    
    private func validateRangeCondition() {
        if (_rangeToCondition.no < _rangeFromCondition.no) {
            _rangeConditionError = "出題範囲の始まりは終わりより小さい数を指定してください"
        } else {
            _rangeConditionError = nil
        }
    }
}

//let questionsResult = karutaRepository.findAll().map { karutas -> Optional<[Question]> in
//    let allKarutaNoCollection = KarutaNoCollection(values: karutas.map { $0.no })
//    let questions = CreateQuestionsService(allKarutaNoCollection)?.execute(targetKarutaNoCollection: KarutaNoCollection(values: [KarutaNo(1), KarutaNo(5), KarutaNo(8)]), choiceSize: 4)
//    return questions
//}
//
//switch questionsResult {
//case .success(let questions):
//    guard let questions = questions else {
//        fatalError()
//    }
////            dump(questions)
//case .failure(let e):
//    dump(e)
//}
//// TODO: 非同期で呼ばれることを想定してこのIFにしてる
//func fetchKarutas(completion: @escaping (Result<[Karuta], ModelError>) -> Void) {
//    switch karutaRepository.findAll() {
//    case .success(let karutas):
//        completion(Result.success(karutas))
//    case .failure(_):
//        completion(Result.failure(ModelError.unhandled))
//    }
//}

