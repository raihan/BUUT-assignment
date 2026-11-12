//
//  CityNameLookupMock.swift
//  Utility
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import Utility

struct CityNameLookupError: Error {}

/// Replaces MapKit in `ReverseGeocoder` tests.
/// Answers with the queued results in order; the last one is repeated once the queue runs out.
actor CityNameLookupMock: CityNameLookup {
    private(set) var cityNameLatitudeLongitudeReceivedInvocations: [(latitude: Double, longitude: Double)] = []
    var cityNameLatitudeLongitudeCallsCount: Int { cityNameLatitudeLongitudeReceivedInvocations.count }
    var cityNameLatitudeLongitudeCalled: Bool { cityNameLatitudeLongitudeCallsCount > 0 }
    var cityNameLatitudeLongitudeReceivedArguments: (latitude: Double, longitude: Double)? {
        cityNameLatitudeLongitudeReceivedInvocations.last
    }

    private var cityNameLatitudeLongitudeResults: [Result<String?, any Error>]

    init(results: [Result<String?, any Error>]) {
        cityNameLatitudeLongitudeResults = results
    }

    func cityName(latitude: Double, longitude: Double) async throws -> String? {
        cityNameLatitudeLongitudeReceivedInvocations.append((latitude, longitude))

        let result = cityNameLatitudeLongitudeResults.count > 1
            ? cityNameLatitudeLongitudeResults.removeFirst()
            : cityNameLatitudeLongitudeResults[0]
        return try result.get()
    }
}
