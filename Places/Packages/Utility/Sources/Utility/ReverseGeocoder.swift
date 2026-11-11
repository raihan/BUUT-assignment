//
//  ReverseGeocoder.swift
//  Utility
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import CoreLocation
import MapKit

public protocol ReverseGeocoding: Sendable {
    /// Returns the city name for the given coordinate, or `nil` if it can't be resolved.
    func cityName(latitude: Double, longitude: Double) async -> String?
}

public actor ReverseGeocoder: ReverseGeocoding {
    /// Looks up the city name for a coordinate. Injected so tests don't hit the network.
    typealias CityNameLookup = @Sendable (_ latitude: Double, _ longitude: Double) async throws -> String?

    private let lookup: CityNameLookup
    /// Results are cached per coordinate so refreshing the list doesn't repeat lookups.
    private var cache: [String: String] = [:]

    public init() {
        self.lookup = { try await ReverseGeocoder.mapKitCityName(latitude: $0, longitude: $1) }
    }

    init(lookup: @escaping CityNameLookup) {
        self.lookup = lookup
    }

    public func cityName(latitude: Double, longitude: Double) async -> String? {
        let cacheKey = "\(latitude),\(longitude)"
        if let cachedCityName = cache[cacheKey] {
            return cachedCityName
        }

        do {
            guard let cityName = try await lookup(latitude, longitude) else {
                return nil
            }
            cache[cacheKey] = cityName
            return cityName
        } catch {
            return nil
        }
    }

    // MARK: - MapKit

    private static func mapKitCityName(latitude: Double, longitude: Double) async throws -> String? {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        guard let request = MKReverseGeocodingRequest(location: location) else {
            return nil
        }
        let mapItems = try await request.mapItems
        return mapItems.first?.addressRepresentations?.cityName
    }
}
