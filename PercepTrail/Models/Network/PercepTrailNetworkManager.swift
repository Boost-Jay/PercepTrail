//
//  PercepTrailNetworkManager.swift
//  PercepTrail
//
//  Created by 王柏崴 on 6/17/24.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()

    private let session: URLSession

    private let token = ""

    private init() {
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }

    public func requestDataAsync<E, D>(method: RequestMethod,
                                       path: ClientAPI.Endpoint,
                                       parameters: E,
                                       needToken: Bool) async throws -> D where E: Encodable, D: Decodable {
        let urlRequest = try handleHttpMethod(method: method, path: path, parameters: parameters, needToken: needToken)
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
//            print(String(data: data, encoding: .utf8))
            guard let response = (response as? HTTPURLResponse) else {
                throw RequestError.invalidResponse
            }
            let statusCode = response.statusCode
            guard (200 ... 299).contains(statusCode) else {
                switch statusCode {
                case 400:
                    throw RequestError.badRequest
                case 401:
                    throw RequestError.authorizationError
                case 404:
                    throw RequestError.notFound
                case 500:
                    throw RequestError.internalError
                case 502:
                    throw RequestError.badGateway
                case 503:
                    throw RequestError.serverUnavailable
                default:
                    throw RequestError.invalidResponse
                }
            }
            do {
                let result = try JSONDecoder().decode(D.self, from: data)

                #if DEBUG
                    printNetworkProgress(urlRequest, parameters, result)
                #endif

                return result
            } catch {
                print("=====================ERROR DATA=====================")
                print(data.base64EncodedString().utf8)
                print("====================================================")
                throw RequestError.jsonDecodeFailed(error as! DecodingError)
            }
        } catch {
            print(error.localizedDescription)
            throw RequestError.unknownError(error)
        }
    }

    /// 發送網絡請求並解析回應
    func requestData<E, D>(method: RequestMethod,
                           path: ClientAPI.Endpoint,
                           parameters: E,
                           needToken: Bool,
                           finish: @escaping (Result<D, Error>) -> Void)
        where E: Encodable, D: Decodable {
        do {
            // 發送請求並獲取回應
            let request = try handleHttpMethod(method: method,
                                               path: path,
                                               parameters: parameters,
                                               needToken: needToken)

            session.dataTask(with: request) { data, response, error in

                #if DEBUG
                    print("Error: \(String(describing: error?.localizedDescription))")
                #endif

                guard error == nil else {
                    // 處理未知錯誤
                    finish(.failure(error!))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    finish(.failure(ErrorType.failedToResponse))
                    return
                }

                guard let data = data else {
                    finish(.failure(URLError(.badServerResponse)))
                    return
                }

                #if DEBUG
                    print("data value :")
                    assertionFailure(String(data: data, encoding: .utf8) ?? "")
                #endif

                do {
                    // 解析 JSON 回應
                    let result = try JSONDecoder().decode(D.self, from: data)

                    if (200 ..< 300).contains(httpResponse.statusCode) {
                        finish(.success(result))
                    } else {
                        finish(.failure(ErrorType.failedRequest(httpResponse: httpResponse)))
                    }

                    #if DEBUG
                        self.printNetworkProgress(request, parameters, result)
                    #endif

                    // 處理 JSON 解析錯誤
                } catch let error as DecodingError {
                    finish(.failure(RequestError.jsonDecodeFailed(error)))
                } catch {
                    finish(.failure(error))
                }
            }.resume()
        } catch {
            // 檢查回應是否有效
            finish(.failure(RequestError.invalidURLRequest))
        }
    }

    private func handleHttpMethod<E>(method: RequestMethod,
                                     path: ClientAPI.Endpoint,
                                     parameters: E,
                                     needToken: Bool) throws -> URLRequest
        where E: Encodable {
        var baseURL: String
        var serverURL = ""

        switch path {
        case .chatGPT4V:
            baseURL = ClientAPI.httpBaseUrl
            serverURL = ClientAPI.serverAdress

        case let .custom(customPath):
            baseURL = ""
            serverURL = customPath
        }

        let endpoint = path.endpoint
        guard let url = URL(string: baseURL + serverURL + endpoint) else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .useProtocolCachePolicy,
                                    timeoutInterval: 50)
        urlRequest.httpMethod = method.rawValue

        var headers = [
            HeaderFields.contentType.rawValue: ContentType.json.rawValue,
        ]

        if needToken {
            headers[HeaderFields.authorization.rawValue] = "Bearer \(token)"
        }

        urlRequest.allHTTPHeaderFields = headers

        // 將參數轉換為字典
        let parameters = try? parameters.toDictionary()

        switch method {
        case .get:
            // 處理 GET 請求的 URL
            urlRequest.url = requestWithURL(url: url.absoluteString,
                                            parameters: parameters as?
                                                [String: String] ?? [:])

        default:
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters ?? [:],
                                                              options: .prettyPrinted)
        }

        if let body = urlRequest.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("HTTP Body: \(bodyString)")
        }

        #if DEBUG
            print("Full URL: \(urlRequest.url?.absoluteString ?? "No URL")")
            print("Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
        #endif

        return urlRequest
    }

    /// 將 URL 字串和參數組合成完整的 URL，通常用於 GET 請求
    private func requestWithURL(url: String,
                                parameters: [String: Any]?) -> URL? {
        guard var components = URLComponents(string: url),
              let parameters = parameters as? [String: String],
              !parameters.isEmpty
        else {
            return URL(string: url)
        }
        // 添加查詢項目
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components.url
    }

    private func printNetworkProgress<E, D>(_ urlRequest: URLRequest,
                                            _ parameters: E,
                                            _ results: D) where E: Encodable, D: Decodable {
        #if DEBUG
            print("=======================================")
            print("- URL: \(urlRequest.url?.absoluteString ?? "")")
            print("- Header: \(urlRequest.allHTTPHeaderFields ?? [:])")
            print("---------------Request-----------------")
            print(parameters)
            print("---------------Response----------------")
            print(results)
            print("=======================================")
        #endif
    }
}
