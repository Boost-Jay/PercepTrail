//
//  RequestError.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import Foundation

enum RequestError: Error {
    case unknownError(Error) // 未知錯誤

    case connectionError // 連接錯誤

    case invalidResponse // 無效回應

    case jsonDecodeFailed(DecodingError) // JSON 解碼失敗

    case invalidURLRequest // 無效請求 400

    case authorizationError // 授權錯誤 401

    case notFound // 未找到   404

    case internalError // 內部錯誤 500

    case serverError // 伺服器錯誤 502

    case serverUnavailable // 伺服器不可用 503

    case badRequest

    case badGateway
}
