//
//  ApiServiceMock.swift
//  ApiService
//
//  Created by Abdullah Zubair on 13/07/2026.
//

import Foundation
@testable import ApiService

final actor ApiServiceMock: ApiServiceProtocol {
    var sendReturnedValue: Any?

    func send<T: Decodable & Sendable>(
        _ routeRequest: Request,
        _ responseType: T.Type
    ) async throws (ApiError) -> T {
        if let value = (sendReturnedValue as? T) {
            return value
        }

        throw ApiError.invalidUrl
    }
}
