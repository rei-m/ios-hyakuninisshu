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
        if (allKarutaNoCollection.count != KarutaNo.MAX.value) {
            return nil
        }
        self.allKarutaNoCollection = allKarutaNoCollection
    }
    
    func execute(
        targetKarutaNoCollection: KarutaNoCollection,
        choiceSize: Int
    ) -> Optional<[Question]> {

        if (targetKarutaNoCollection.count == 0) {
            return nil
        }

        let result: [Question] = targetKarutaNoCollection.asRandomized.enumerated().map { value in
            let no = value.offset + 1
            let targetKarutaNo = value.element
            
            var dupNos = allKarutaNoCollection.values
            dupNos.removeAll(where: { $0.value == targetKarutaNo.value })
            
            var choices = dupNos.count.generateRandomIndexArray(size: choiceSize - 1).map { dupNos[$0] }
            let correctPosition = choiceSize.generateRandomIndexArray(size: 1).first!
            choices.insert(targetKarutaNo, at: correctPosition)
            
            return Question(id: QuestionId(), no: no, choices: choices, correctNo: targetKarutaNo, state: .ready)
        }
        
        return result
    }
}
