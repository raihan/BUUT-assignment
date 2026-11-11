//
//  LocationsFixture.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import Foundation
import Models

/// Builds `Models` values the same way the app receives them: by decoding JSON.
enum LocationsFixture {
    static func locations(_ items: [(name: String?, lat: Double, long: Double)]) throws -> Locations {
        let json: [String: Any] = [
            "locations": items.map { item -> [String: Any] in
                var location: [String: Any] = ["lat": item.lat, "long": item.long]
                location["name"] = item.name
                return location
            }
        ]
        let data = try JSONSerialization.data(withJSONObject: json)
        return try JSONDecoder().decode(Locations.self, from: data)
    }

    static var amsterdam: Location {
        Location(name: "Amsterdam", lat: 52.3547498, long: 4.8339215)
    }

    static var unnamed: Location {
        Location(name: nil, lat: 40.4380638, long: -3.7495758)
    }
}

struct TestError: Error {}
