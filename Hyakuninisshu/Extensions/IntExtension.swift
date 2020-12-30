//
//  IntExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation

extension Int {
    func generateRandomIndexArray(size: Int) -> [Int] {
        let max = self - 1
        let shuffled: [Int] = (0 ... max).shuffled()
        return shuffled.prefix(size).map { $0 }
    }
}
