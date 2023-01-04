//
//  CreateQuestionListService.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation

/// 問題作成サービス
class CreateQuestionsService {

  private let allKarutaNoCollection: KarutaNoCollection

  /// - Parameter allKarutaNoCollection: 全ての歌番号のコレクション
  init?(_ allKarutaNoCollection: KarutaNoCollection) {
    if allKarutaNoCollection.values.count != KarutaNo.MAX.value {
      return nil
    }
    self.allKarutaNoCollection = allKarutaNoCollection
  }

  /// 指定した歌番号の問題を作成する
  /// - Parameters:
  ///   - targetKarutaNoCollection: 作成対象の歌番号コレクション
  ///   - choiceCount: 選択肢の数
  /// - Returns: 問題のリスト
  func execute(
    targetKarutaNoCollection: KarutaNoCollection,
    choiceCount: Int
  ) -> [Question] {

    if targetKarutaNoCollection.values.count == 0 {
      return []
    }

    let result: [Question] = targetKarutaNoCollection.values.shuffled().enumerated().map { value in
      let no: UInt8 = UInt8(value.offset + 1)
      let targetKarutaNo = value.element

      var dupNos = allKarutaNoCollection.values.map { value in value }
      dupNos.removeAll(where: { $0.value == targetKarutaNo.value })

      var choices = generateRandomIndexArray(total: dupNos.count, size: choiceCount - 1).map {
        dupNos[$0]
      }
      let correctPosition = generateRandomIndexArray(total: choiceCount, size: 1).first!
      choices.insert(targetKarutaNo, at: correctPosition)

      return Question(
        id: QuestionId.create(), no: no, choices: choices, correctNo: targetKarutaNo, state: .ready)
    }

    return result
  }

  private func generateRandomIndexArray(total: Int, size: Int) -> [Int] {
    let max = total - 1
    let shuffled: [Int] = (0...max).shuffled()
    return shuffled.prefix(size).map { $0 }
  }
}
