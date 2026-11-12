//
//  ApiProtocol.swift
//  ApiService
//
//  Created by Abdullah Zubair on 11/11/2026.
//

import Foundation

public protocol ApiServiceProtocol: Actor {
    func send<T: Decodable & Sendable>(_ routeRequest: Request, _ responseType: T.Type) async throws (ApiError) -> T
}
