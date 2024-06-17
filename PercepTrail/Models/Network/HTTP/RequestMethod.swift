//
//  RequestMethod.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import Foundation

enum RequestMethod: String, CustomStringConvertible {
    
    case `get` = "GET"
    
    case head = "HEAD"
    
    case post = "POST"
    
    case put = "PUT"
    
    case delete = "DELETE"
    
    case connect = "CONNECT"
    
    case options = "OPTIONS"
    
    case trace = "TRACE"
    
    case patch = "PATCH"
    
    var description: String {
        let base = "HTTP Request Method: "
        return base + self.rawValue
    }
}
