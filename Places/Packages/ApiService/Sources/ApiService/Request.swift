//
//  Request.swift
//  ApiService
//
//  Created by Abdullah Zubair on 13/07/2026.
//

import Foundation

enum HttpMethod: String {
    case GET
}

typealias StatusCode = Int

public struct Request {
    let path: String
    let method: HttpMethod = .GET

    public init(path: String) {
        self.path = path
    }

    var urlComponents: URLComponents? {
        var urlComponents = URLComponents(string: .baseUrl)
        urlComponents?.path = path

        return urlComponents
    }

    func asUrlRequest() throws -> URLRequest {
        guard let url = urlComponents?.url else {
            throw ApiError.invalidUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
