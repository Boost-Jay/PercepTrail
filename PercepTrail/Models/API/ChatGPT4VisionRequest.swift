//
//  ChatGPT4VisionRequest.swift
//  PercepTrail
//
//  Created by imac-2627 on 2024/6/25.
//

import Foundation

struct ChatGPT4VisionRequest: Encodable {
    
    var model: String
    
    var messages: [RequestMessages]
    
    var maxTokens: Int
    
    enum CodingKeys: String, CodingKey {
        
        case model
        
        case messages
        
        case maxTokens = "max_tokens"
    }
}

struct RequestMessages: Encodable {
    
    var role: String
    
    var content: [Content]

}

struct Content: Encodable {
    
    var type: String
    
    var text: String?
    
    var image_url: ImageUrl?
}

struct ImageUrl: Encodable {
    
    var url: String
    
    var detail: String
}

