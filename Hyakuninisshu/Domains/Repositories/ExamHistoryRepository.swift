//
//  ExamHistoryRepository.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import Combine

protocol ExamHistoryRepository {
    func findAll() -> AnyPublisher<[ExamHistory], RepositoryError>
    func findLast() -> AnyPublisher<ExamHistory?, RepositoryError>
}
