//
//  ChatGPT4VisionResponse.swift
//  PercepTrail
//
//  Created by imac-2627 on 2024/6/25.
//

import Foundation

struct ChatGPT4VisionResponse: Decodable {
    
    var id: String
    
    var object: String
    
    var created: Int
    
    var model: String
    
    var choices: [Choices]
    
    var usage: Usage
}

struct Choices: Decodable {
    
    var index: Int
    
    var message: ResponseMessage
    
    var finishReason: String
    
    enum CodingKeys: String, CodingKey {
        
        case index
        
        case message
        
        case finishReason = "finish_reason"
    }
}

struct ResponseMessage: Decodable {
    
    var role: String
    
    var content: String
    
}

struct Usage: Decodable {
    
    var promptTokens: Int
    
    var completionTokens: Int
    
    var totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        
        case promptTokens = "prompt_tokens"
        
        case completionTokens = "completion_tokens"
        
        case totalTokens = "total_tokens"
    }
}
