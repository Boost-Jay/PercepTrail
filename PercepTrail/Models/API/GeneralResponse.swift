//
//  GeneralResponse.swift
//  PercepTrail
//
//  Created by imac-2627 on 2024/7/3.
//

import Foundation

struct GeneralResponse<T>: Decodable where T: Decodable {
    
    let message: String
    
    let data: T?
}
