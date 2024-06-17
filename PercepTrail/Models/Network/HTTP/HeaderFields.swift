//
//  HeaderFields.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import Foundation

enum HeaderFields: String, CustomStringConvertible {
    
    /// 定義 HTTP 標頭欄位
    case authentication = "Authorization"
    
    case contentType = "Content-Type"
    
    case acceptType = "Accept"
    
    case acceptEncoding = "Accept-Encoding"
    
    case userKey = "User-Key"
    
    case cookie = "Cookie"
    
    var description: String {
        let base = "HTTP Header Fields: "
        return base + self.rawValue
    }
}
