//
//  ApiServiceMock.swift
//  LocationsApi
//
//  Created by Abdullah Zubair on 13/07/2026.
//

import Foundation
@testable import ApiService
@testable import Models

final actor ApiServiceMock: ApiServiceProtocol {
    private var sendReturnedValue: Any?

    func updateSendReturnedValue(newValue: Any?) {
        self.sendReturnedValue = newValue
    }

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

