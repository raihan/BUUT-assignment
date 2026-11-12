//
//  ModelsTests.swift
//  Models
//
//  Created by Abdullah Zubair on 11/11/2026.
//

import Testing
import Foundation
@testable import Models

@Suite
struct ModelsTests {

    // MARK: - Location

    @Test
    func decodeLocationWithAllFields() throws {
        // Given
        let json = #"{"name": "Amsterdam", "lat": 52.3547498, "long": 4.8339215}"#
        
        // When
        let data = try #require(json.data(using: .utf8))
        let location = try JSONDecoder().decode(Location.self, from: data)
        
        // Then
        #expect(location.name == "Amsterdam")
        #expect(location.lat == 52.3547498)
        #expect(location.long == 4.8339215)
    }

    @Test
    func decodeLocationWithNilName() throws {
        // Given
        let json = #"{"lat": 52.3547498, "long": 4.8339215}"#
        
        // When
        let data = try #require(json.data(using: .utf8))
        let location = try JSONDecoder().decode(Location.self, from: data)
        
        // Then
        #expect(location.name == nil)
        #expect(location.lat == 52.3547498)
        #expect(location.long == 4.8339215)
    }

    @Test
    func decodeLocationMissingRequiredLatThrows() throws {
        // Given
        let json = #"{"name": "Amsterdam", "long": 4.8339215}"#
        
        // When
        let data = try #require(json.data(using: .utf8))
        
        // Then
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(Location.self, from: data)
        }
    }

    @Test
    func decodeLocationMissingRequiredLongThrows() throws {
        // Given
        let json = #"{"name": "Amsterdam", "lat": 52.3547498}"#
        
        // When
        let data = try #require(json.data(using: .utf8))
        
        // Then
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(Location.self, from: data)
        }
    }

    // MARK: - Locations

    @Test
    func decodeLocationsArray() throws {
        // Given
        let json = """
        {
            "locations": [
                {"name": "Amsterdam", "lat": 52.3547498, "long": 4.8339215},
                {"lat": 19.0823998, "long": 72.8111468}
            ]
        }
        """
        
        // When
        let data = try #require(json.data(using: .utf8))
        let locations = try JSONDecoder().decode(Locations.self, from: data)
        
        // Then
        #expect(locations.locations.count == 2)
        #expect(locations.locations[0].name == "Amsterdam")
        #expect(locations.locations[1].name == nil)
    }

    @Test
    func decodeLocationsEmptyArray() throws {
        // Given
        let json = #"{"locations": []}"#
        
        // When
        let data = try #require(json.data(using: .utf8))
        let locations = try JSONDecoder().decode(Locations.self, from: data)
        
        // Then
        #expect(locations.locations.isEmpty)
    }

    // MARK: - Equality

    @Test
    func sameLocationDecodedTwiceIsEqual() throws {
        // Given
        let json = #"{"name": "Amsterdam", "lat": 52.3547498, "long": 4.8339215}"#
        let data = try #require(json.data(using: .utf8))

        // When
        let first = try JSONDecoder().decode(Location.self, from: data)
        let second = try JSONDecoder().decode(Location.self, from: data)

        // Then
        #expect(first == second)
    }

    @Test
    func locationsWithDifferentDataAreNotEqual() {
        // Given
        let amsterdam = Location(name: "Amsterdam", lat: 52.3547498, long: 4.8339215)

        // Then
        #expect(amsterdam != Location(name: "Madrid", lat: 52.3547498, long: 4.8339215))
        #expect(amsterdam != Location(name: "Amsterdam", lat: 40.4380638, long: 4.8339215))
        #expect(amsterdam != Location(name: "Amsterdam", lat: 52.3547498, long: -3.7495758))
        #expect(amsterdam != Location(name: nil, lat: 52.3547498, long: 4.8339215))
    }
}
