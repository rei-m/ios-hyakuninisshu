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


    func fetchKarutas(completion: @escaping (Result<[Karuta], ModelError>) -> Void)
}

class TrainingModel: TrainingModelProtocol {
    
    public var rangeFromCondition = RangeCondition.FROM_DATA.first!
    public var rangeToCondition = RangeCondition.TO_DATA.last!
    public var kimarijiCondition = KimarijiCondition.DATA.first!
    public var colorCondition = ColorCondition.DATA.first!
    public var kamiNoKuCondition = DisplayStyleCondition.DATA.first!
    public var shimoNoKuCondition = DisplayStyleCondition.DATA.last!
    public var animationSpeedCondition = AnimationSpeedCondition.DATA[2]

    private let karutaRepository: KarutaRepositoryProtocol
    
    init(karutaRepository: KarutaRepositoryProtocol) {
        self.karutaRepository = karutaRepository
    }
    
    // TODO: 非同期で呼ばれることを想定してこのIFにしてる
    func fetchKarutas(completion: @escaping (Result<[Karuta], ModelError>) -> Void) {
        switch karutaRepository.findAll() {
        case .success(let karutas):
            completion(Result.success(karutas))
        case .failure(_):
            completion(Result.failure(ModelError.unhandled))
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
