//
//  ContentType.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import Foundation

/// 定義內容類型
enum ContentType: String, CustomStringConvertible {
    
    /// HTTP Request's body Content-Type，JSON
    case json = "application/json"
    
    /// HTTP Request's body Content-Type，XML
    case xml = "application/xml"
    
    /// HTTP Request's body Content-Type，text/plain
    case textPlain = "text/plain"
    
    /// HTTP Request's body Content-Type，x-www-form-urlencoded
    case x_www_form_urlencoded = "application/x-www-form-urlencoded"
    
    var description: String {
        let base = "HTTP Content-Type: "
        return base + self.rawValue
    }
}
