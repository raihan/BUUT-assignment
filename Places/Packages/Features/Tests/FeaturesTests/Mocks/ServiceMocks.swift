//
//  ServiceMocks.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import LocationsApi
import Models
import Utility

// MARK: - LocationsApiProtocolMock

/// `LocationsApiProtocol` requires an actor, so the return value is set up front in `init`.
actor LocationsApiProtocolMock: LocationsApiProtocol {
    nonisolated let fetchLocationsReturnValue: Locations?
    nonisolated let fetchLocationsThrowableError: (any Error)?

    private(set) var fetchLocationsCallsCount = 0
    var fetchLocationsCalled: Bool { fetchLocationsCallsCount > 0 }

    init(returnValue: Locations? = nil, throwableError: (any Error)? = nil) {
        fetchLocationsReturnValue = returnValue
        fetchLocationsThrowableError = throwableError
    }

    func fetchLocations() async throws -> Locations {
        fetchLocationsCallsCount += 1
        if let fetchLocationsThrowableError {
            throw fetchLocationsThrowableError
        }
        return try fetchLocationsReturnValue ?? LocationsFixture.locations([])
    }
}

// MARK: - ReverseGeocodingMock

@MainActor
final class ReverseGeocodingMock: ReverseGeocoding {
    var cityNameLatitudeLongitudeReturnValue: String?

    private(set) var cityNameLatitudeLongitudeReceivedInvocations: [(latitude: Double, longitude: Double)] = []
    var cityNameLatitudeLongitudeCallsCount: Int { cityNameLatitudeLongitudeReceivedInvocations.count }
    var cityNameLatitudeLongitudeCalled: Bool { cityNameLatitudeLongitudeCallsCount > 0 }
    var cityNameLatitudeLongitudeReceivedArguments: (latitude: Double, longitude: Double)? {
        cityNameLatitudeLongitudeReceivedInvocations.last
    }

    func cityName(latitude: Double, longitude: Double) async -> String? {
        cityNameLatitudeLongitudeReceivedInvocations.append((latitude, longitude))
        return cityNameLatitudeLongitudeReturnValue
    }
}
