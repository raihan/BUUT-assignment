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

/// Resolves city names through a `CityNameLookup` and caches them per coordinate,
/// so refreshing the list doesn't repeat lookups.
public actor ReverseGeocoder: ReverseGeocoding {
    private let cityNameLookup: CityNameLookup
    private var cache: [String: String] = [:]

    public init(cityNameLookup: CityNameLookup = MapKitCityNameLookup()) {
        self.cityNameLookup = cityNameLookup
    }

    public func cityName(latitude: Double, longitude: Double) async -> String? {
        let key = "\(latitude),\(longitude)"
        if let cachedCityName = cache[key] {
            return cachedCityName
        }

        // Failed or empty lookups aren't cached, so they're tried again next time.
        let cityName = try? await cityNameLookup.cityName(latitude: latitude, longitude: longitude)
        cache[key] = cityName
        return cityName
    }
}

// MARK: - Lookup

/// Looks up the name of the city at a coordinate.
public protocol CityNameLookup: Sendable {
    func cityName(latitude: Double, longitude: Double) async throws -> String?
}

/// Looks up city names with MapKit reverse geocoding.
public struct MapKitCityNameLookup: CityNameLookup {
    public init() {}

    public func cityName(latitude: Double, longitude: Double) async throws -> String? {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        guard let request = MKReverseGeocodingRequest(location: location) else {
            return nil
        }
        return try await request.mapItems.first?.addressRepresentations?.cityName
    }
}
