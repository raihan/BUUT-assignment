//
//  CityNameLookupSpy.swift
//  Utility
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import Foundation

struct CityNameLookupError: Error {}

/// Records every lookup and answers with the queued results in order.
/// The last result is repeated once the queue runs out.
actor CityNameLookupSpy {
    private(set) var callCount = 0
    private(set) var lastLatitude: Double?
    private(set) var lastLongitude: Double?

    private var results: [Result<String?, any Error>]

    init(results: [Result<String?, any Error>]) {
        self.results = results
    }

    func lookup(latitude: Double, longitude: Double) throws -> String? {
        callCount += 1
        lastLatitude = latitude
        lastLongitude = longitude

        let result = results.count > 1 ? results.removeFirst() : results[0]
        return try result.get()
    }
}
