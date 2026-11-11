//
//  LocationsApi.swift
//  LocationsApi
//
//  Created by Abdullah Zubair on 13/07/2026.
//

import Foundation
import ApiService
import Models

public protocol LocationsApiProtocol: Actor {
    func fetchLocations() async throws -> Locations
}

public final actor LocationsApi: LocationsApiProtocol {
    private let apiService: ApiServiceProtocol
    
    public init(apiService: ApiServiceProtocol = ApiService()) {
        self.apiService = apiService
    }
    
    public func fetchLocations() async throws(ApiError) -> Locations {
        return try await apiService.send(.location, Locations.self)
    }
}
