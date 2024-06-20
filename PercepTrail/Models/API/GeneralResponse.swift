//
//  GeneralResponse.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/18/24.
//

import Foundation

struct GeneralResponse<T>: Decodable where T: Decodable {
    
    let message: String
    
    let data: T?
}
