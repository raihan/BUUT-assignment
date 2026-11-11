//
//  LocationsInteractor.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import Foundation
import LocationsApi
import Models
import Utility

final class LocationsInteractor: LocationsInteracting {
    weak var output: LocationsInteractingOutput?

    let locationsApi: LocationsApiProtocol
    let reverseGeocoder: ReverseGeocoding
    private(set) var fetchTask: Task<Void, Never>?

    init(locationsApi: LocationsApiProtocol, reverseGeocoder: ReverseGeocoding) {
        self.locationsApi = locationsApi
        self.reverseGeocoder = reverseGeocoder
    }

    func fetchLocations() {
        fetchTask?.cancel()
        fetchTask = Task { [weak self] in
            guard let self else { return }

            let locations: [Location]
            do {
                locations = try await locationsApi.fetchLocations().locations
            } catch {
                guard !Task.isCancelled else { return }
                output?.didFailFetchingLocations(error: error)
                return
            }

            guard !Task.isCancelled else { return }
            output?.didFetchLocations(locations)

            await resolveMissingNames(in: locations)
        }
    }

    // MARK: Reverse geocoding

    /// Looks up a city name for every location without a name and, if any were found,
    /// sends the updated list to the output. The list is shown first so it never waits on geocoding.
    private func resolveMissingNames(in locations: [Location]) async {
        var resolvedLocations = locations

        for (index, location) in locations.enumerated() where location.name == nil {
            guard let cityName = await reverseGeocoder.cityName(latitude: location.lat, longitude: location.long) else {
                continue
            }
            resolvedLocations[index] = Location(id: location.id, name: cityName, lat: location.lat, long: location.long)
        }

        guard !Task.isCancelled, resolvedLocations != locations else { return }
        output?.didFetchLocations(resolvedLocations)
    }
}
