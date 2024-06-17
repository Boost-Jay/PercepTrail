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
    
    /// local ip address
    static let serverAdress = "127.0.0.1:8080"
    
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
                return "v1"
            case .v2:
                return "v2"
            }
        }
        
        var description: String {
            let base = "/api/"
            return base + self.endpoint
        }
    }
    
    enum Endpoint {
        case exampleData(ApiVersion)
        
        var endpoint: String {
            switch self {
            case .exampleData(let apiVersion):
                return apiVersion.description + "/example/create"
            }
        }
    }
}

typealias ClientAPI = PercepTrailDataAPIClient
