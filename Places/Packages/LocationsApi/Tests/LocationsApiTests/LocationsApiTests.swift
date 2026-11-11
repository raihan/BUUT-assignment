//
//  LocationsApiTests.swift
//  LocationsApi
//
//  Created by Abdullah Zubair on 13/07/2026.
//

import Foundation
import Testing
import ApiService
@testable import Models
@testable import LocationsApi

struct LocationsApiTests {
    private let apiService = ApiServiceMock()
    private let locations: Locations = Locations(
        locations: [
            Location(name: "Amsterdam", lat: 52.3547498, long: 4.8339215)
        ])

    @Test
    func fetchLocationsWhenSucceeds() async throws {
        // Given
        await apiService.updateSendReturnedValue(newValue: locations)

        let subject = LocationsApi(apiService: apiService)

        // When
        let fetchedLocation = try await subject.fetchLocations()

        // Then
        #expect(fetchedLocation == locations)
    }

    @Test
    func fetchLocationsWhenFails() async throws {
        // Given
        await apiService.updateSendReturnedValue(newValue: nil)
        
        let subject = LocationsApi(apiService: apiService)

        // Then
        await #expect(throws: ApiError.self) {
            // When
            _ = try await subject.fetchLocations()
        }
    }
}
