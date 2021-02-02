//
//  KarutaRepository.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/03.
//

import Combine
import CoreData
import Foundation

private struct KarutaJson: Codable {
  var no: Int8
  var creator: String
  var first_kana: String
  var first_kanji: String
  var second_kana: String
  var second_kanji: String
  var third_kana: String
  var third_kanji: String
  var fourth_kana: String
  var fourth_kanji: String
  var fifth_kana: String
  var fifth_kanji: String
  var translation: String
  var kimariji: Int8
  var color: String
  var color_no: Int
}

private struct KarutaListJson: Codable {
  var karuta_list: [KarutaJson]
}

extension CDKaruta {
  fileprivate func toModel() -> Karuta {
    let karutaNo = KarutaNo(UInt8(no))
    let kamiNoKu = KamiNoKu(
      karutaNo: karutaNo,
      shoku: Verse(kana: first_kana!, kanji: first_kanji!),
      niku: Verse(kana: second_kana!, kanji: second_kanji!),
      sanku: Verse(kana: third_kana!, kanji: third_kanji!)
    )

    let shimoNoKu = ShimoNoKu(
      karutaNo: karutaNo,
      shiku: Verse(kana: fourth_kana!, kanji: fourth_kanji!),
      goku: Verse(kana: fifth_kana!, kanji: fifth_kanji!)
    )

    guard let kimarijiModel = Kimariji(rawValue: UInt8(kimariji)) else {
      fatalError("unknown value: kimariji=\(kimariji)")
    }

    guard let karutaColor = KarutaColor(rawValue: color!) else {
      fatalError("unknown value: color=\(color ?? "")")
    }

    return Karuta(
      no: karutaNo,
      kamiNoKu: kamiNoKu,
      shimoNoKu: shimoNoKu,
      creator: creator!,
      translation: translation!,
      kimariji: kimarijiModel,
      color: karutaColor
    )
  }

  fileprivate func persistFromJson(json: KarutaJson) {
    no = Int16(json.no)
    creator = json.creator
    first_kana = json.first_kana
    first_kanji = json.first_kanji
    second_kana = json.second_kana
    second_kanji = json.second_kanji
    third_kana = json.third_kana
    third_kanji = json.third_kanji
    fourth_kana = json.fourth_kana
    fourth_kanji = json.fourth_kanji
    fifth_kana = json.fifth_kana
    fifth_kanji = json.fifth_kanji
    kimariji = Int16(json.kimariji)
    color = json.color
    translation = json.translation
  }
}

class KarutaRepositoryImpl: KarutaRepository {

  private static let VERSION = "1"

  private static let VERSION_KEY = "8XhHm"

  private let container: NSPersistentContainer

  init(container: NSPersistentContainer) {
    self.container = container
  }

  func initialize() -> Future<Void, DomainError> {
    let publisher = Future<Void, DomainError> { promise in
      let currentVer = UserDefaults.standard.string(forKey: Self.VERSION_KEY)
      if currentVer == Self.VERSION {
        promise(.success(()))
        return
      }

      DispatchQueue.global(qos: .userInteractive).async {
        guard let url = Bundle.main.url(forResource: "karuta_list_v_3", withExtension: "json")
        else {
          let error = DomainError(reason: "karuta_list_v_3 path is missing", kind: .repository)
          promise(.failure(error))
          return
        }
        guard let data = try? Data(contentsOf: url) else {
          let error = DomainError(
            reason: "karuta_list_v_3 contents is not readable", kind: .repository)
          promise(.failure(error))
          return
        }

        guard let json = try? JSONDecoder().decode(KarutaListJson.self, from: data) else {
          let error = DomainError(reason: "decode karuta_list_v_3 is failed", kind: .repository)
          promise(.failure(error))
          return
        }

        do {
          let context = self.container.newBackgroundContext()

          let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDKaruta.fetchRequest()
          let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
          deleteRequest.resultType = .resultTypeObjectIDs

          try context.execute(deleteRequest)

          json.karuta_list.forEach {
            let cdKaruta = CDKaruta(context: context)
            cdKaruta.persistFromJson(json: $0)
          }
          try context.save()

          UserDefaults.standard.setValue(Self.VERSION, forKey: Self.VERSION_KEY)

          promise(.success(()))
        } catch let error {
          let domainError = DomainError(reason: error.localizedDescription, kind: .repository)
          promise(.failure(domainError))
        }
      }
    }

    return publisher
  }

  func findAll() -> Future<[Karuta], DomainError> {
    let publisher = Future<[Karuta], DomainError> { promise in
      let fetchRequest: NSFetchRequest<CDKaruta> = CDKaruta.fetchRequest()
      fetchRequest.sortDescriptors = [NSSortDescriptor(key: "no", ascending: true)]

      let asyncFetch = NSAsynchronousFetchRequest<CDKaruta>(fetchRequest: fetchRequest) { result in
        promise(.success(result.finalResult?.map { $0.toModel() } ?? []))
      }

      do {
        try self.container.newBackgroundContext().execute(asyncFetch)
      } catch let error {
        let domainError = DomainError(reason: error.localizedDescription, kind: .repository)
        promise(.failure(domainError))
      }
    }

    return publisher
  }

  func findAll(fromNo: KarutaNo, toNo: KarutaNo, kimarijis: [Kimariji], colors: [KarutaColor])
    -> Future<[Karuta], DomainError>
  {
    let publisher = Future<[Karuta], DomainError> { promise in
      let fetchRequest: NSFetchRequest<CDKaruta> = CDKaruta.fetchRequest()
      fetchRequest.predicate = NSPredicate(
        format: "%K BETWEEN {%i, %i} AND kimariji IN %@ AND color IN %@",
        "no",
        fromNo.value,
        toNo.value,
        kimarijis.map { $0.rawValue },
        colors.map { $0.rawValue }
      )
      fetchRequest.sortDescriptors = [NSSortDescriptor(key: "no", ascending: true)]

      let asyncFetch = NSAsynchronousFetchRequest<CDKaruta>(fetchRequest: fetchRequest) { result in
        promise(.success(result.finalResult?.map { $0.toModel() } ?? []))
      }

      do {
        try self.container.newBackgroundContext().execute(asyncFetch)
      } catch let error {
        let domainError = DomainError(reason: error.localizedDescription, kind: .repository)
        promise(.failure(domainError))
      }
    }

    return publisher
  }

  func findAll(karutaNos: [KarutaNo]) -> Future<[Karuta], DomainError> {
    let publisher = Future<[Karuta], DomainError> { promise in
      let fetchRequest: NSFetchRequest<CDKaruta> = CDKaruta.fetchRequest()
      fetchRequest.predicate = NSPredicate(
        format: "%K IN %@",
        "no",
        karutaNos.map { $0.value }
      )
      fetchRequest.sortDescriptors = [NSSortDescriptor(key: "no", ascending: true)]

      let asyncFetch = NSAsynchronousFetchRequest<CDKaruta>(fetchRequest: fetchRequest) { result in
        promise(.success(result.finalResult?.map { $0.toModel() } ?? []))
      }

      do {
        try self.container.newBackgroundContext().execute(asyncFetch)
      } catch let error {
        let domainError = DomainError(reason: error.localizedDescription, kind: .repository)
        promise(.failure(domainError))
      }
    }

    return publisher
  }
}
