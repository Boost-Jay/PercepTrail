//
//  ErrorType.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import Foundation

enum ErrorType: LocalizedError, Equatable {
    case custom(error: Error)
    case failedToResponse
    case failedToDecode
    case failedInvalidURL
    case failedNilData
    case failedUnknown
    case failedLimitRequest
    case failedRequest(httpResponse: HTTPURLResponse)
    case failedRequestSomething

    var errorDescription: String? {
        switch self {
        case .custom(error: let error):
            return error.localizedDescription
        case .failedToDecode:
            return "Failed to decode response"
        case .failedInvalidURL:
            return "Failed to Invalid URL"
        case .failedToResponse:
            return "Failed to response"
        case .failedRequestSomething:
            return "Failed to request API request failed"
        case .failedRequest(httpResponse: let httpResponse):
            return "Failed to request API request failed with status code \(httpResponse.statusCode) : \(httpResponse.description)"
        case .failedNilData:
            return "Response is nil data"
        case .failedUnknown:
            return "Failed Unknown"
        case .failedLimitRequest:
            return "Failed Limited Request"
        }
    }

    static func == (lhs: ErrorType, rhs: ErrorType) -> Bool {
        return lhs.errorDescription == rhs.errorDescription
    }
}
