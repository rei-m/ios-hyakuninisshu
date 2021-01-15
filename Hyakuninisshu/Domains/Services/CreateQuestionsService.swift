//
//  CreateQuestionListService.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation

class CreateQuestionsService {
    
    private let allKarutaNoCollection: KarutaNoCollection
    
    init?(_ allKarutaNoCollection: KarutaNoCollection) {
        if (allKarutaNoCollection.values.count != KarutaNo.MAX.value) {
            return nil
        }
        self.allKarutaNoCollection = allKarutaNoCollection
    }
    
    func execute(
        targetKarutaNoCollection: KarutaNoCollection,
        choiceSize: Int
    ) -> Optional<[Question]> {

        if (targetKarutaNoCollection.values.count == 0) {
            return nil
        }

        let result: [Question] = targetKarutaNoCollection.values.shuffled().enumerated().map { value in
            let no: UInt8 = UInt8(value.offset + 1)
            let targetKarutaNo = value.element
            
            var dupNos = allKarutaNoCollection.values
            dupNos.removeAll(where: { $0.value == targetKarutaNo.value })
            
            var choices = generateRandomIndexArray(total: dupNos.count, size: choiceSize - 1).map { dupNos[$0] }
            let correctPosition = generateRandomIndexArray(total: choiceSize, size: 1).first!
            choices.insert(targetKarutaNo, at: correctPosition)
            
            return Question(id: QuestionId.create(), no: no, choices: choices, correctNo: targetKarutaNo, state: .ready)
        }
        
        return result
    }
    
    private func generateRandomIndexArray(total: Int, size: Int) -> [Int] {
        let max = total - 1
        let shuffled: [Int] = (0 ... max).shuffled()
        return shuffled.prefix(size).map { $0 }
    }
}
