//
//  TrainingModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/27.
//

import Foundation

protocol TrainingModelProtocol: AnyObject {
    func fetchKarutas(completion: @escaping (Result<[Karuta], ModelError>) -> Void)
}

class TrainingModel: TrainingModelProtocol {
    
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
