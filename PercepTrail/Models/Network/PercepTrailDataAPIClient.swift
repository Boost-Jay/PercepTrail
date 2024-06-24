//
//  PercepTrailDataAPIClient.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import Foundation

// MARK: - PercepTrailDataAPIClient

enum PercepTrailDataAPIClient {
    static let httpBaseUrl = "http://"
    
    /// OpenAI ip address
    static let serverAdress = "api.openai.com"
    
    enum ContentType: String {
        case json = "application/json"
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        
        case post = "POST"
        
        case delete = "DELETE"
    }
    
    enum ApiVersion: Int, CaseIterable, CustomStringConvertible {
        case v1 = 0, v2
        
        var endpoint: String {
            switch self {
            case .v1:
                return "/v1"
            case .v2:
                return "/v2"
            }
        }
        
        var description: String {
            return self.endpoint
        }
    }
    
    enum Endpoint {
        case chatGPT4V(ApiVersion)
        
        var endpoint: String {
            switch self {
            case .chatGPT4V(let apiVersion):
                return apiVersion.description + "/chat/completions"
            }
        }
    }
}

typealias ClientAPI = PercepTrailDataAPIClient
