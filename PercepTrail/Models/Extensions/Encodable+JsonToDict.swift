//
//  Encodable+JsonToDict.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import Foundation

extension Encodable {
    /// 將 Encodable 物件轉換為字典
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self) // 編碼為 JSON
        guard let dicationary = try JSONSerialization.jsonObject(with: data,
                                                                 options: .allowFragments) as? [String: Any] else {
            throw NSError() // 轉換為字典
        }
        return dicationary
    }
}
