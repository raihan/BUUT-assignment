//
//  ApiProtocol.swift
//  ApiService
//
//  Created by Abdullah Zubair on 13/07/2026.
//

import Foundation

public protocol ApiServiceProtocol: Actor {
    func send<T: Decodable>(_ routeRequest: Request,_ responseType: T.Type) async throws (ApiError) -> T
}
