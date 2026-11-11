//
//  LocationsInteractorTests.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import Testing
import Models
@testable import Features

@Suite("LocationsInteractor")
@MainActor
struct LocationsInteractorTests {
    let output = LocationsInteractingOutputMock()
    let reverseGeocoder = ReverseGeocodingMock()

    private func makeSubject(api: LocationsApiProtocolMock) -> LocationsInteractor {
        let subject = LocationsInteractor(locationsApi: api, reverseGeocoder: reverseGeocoder)
        subject.output = output
        return subject
    }

    /// Fetches and waits until the fetch, including reverse geocoding, has finished.
    private func fetchLocations(from api: LocationsApiProtocolMock) async {
        let subject = makeSubject(api: api)
        subject.fetchLocations()
        await subject.fetchTask?.value
    }

    // MARK: - Fetching locations

    @Test("calls the api once")
    func callsApiOnce() async throws {
        let api = LocationsApiProtocolMock(returnValue: try LocationsFixture.locations([("Amsterdam", 52.3547498, 4.8339215)]))

        await fetchLocations(from: api)

        #expect(await api.fetchLocationsCallsCount == 1)
    }

    @Test("calls output with the fetched locations")
    func callsOutputWithLocations() async throws {
        let locations = try LocationsFixture.locations([("Amsterdam", 52.3547498, 4.8339215), ("Mumbai", 19.0823998, 72.8111468)])

        await fetchLocations(from: LocationsApiProtocolMock(returnValue: locations))

        #expect(output.didFetchLocationsReceivedInvocations == [locations.locations])
        #expect(output.didFailFetchingLocationsCalled == false)
    }

    @Test("does not call the reverse geocoder when every location has a name")
    func skipsReverseGeocoderForNamedLocations() async throws {
        let locations = try LocationsFixture.locations([("Amsterdam", 52.3547498, 4.8339215)])

        await fetchLocations(from: LocationsApiProtocolMock(returnValue: locations))

        #expect(reverseGeocoder.cityNameLatitudeLongitudeCalled == false)
    }

    @Test("calls output with an empty list when there are no locations")
    func callsOutputWithEmptyList() async throws {
        await fetchLocations(from: LocationsApiProtocolMock(returnValue: try LocationsFixture.locations([])))

        #expect(output.didFetchLocationsReceivedInvocations == [[]])
    }

    @Test("calls output with the error when the api fails")
    func callsOutputWithError() async {
        await fetchLocations(from: LocationsApiProtocolMock(throwableError: TestError()))

        #expect(output.didFailFetchingLocationsCallsCount == 1)
        #expect(output.didFailFetchingLocationsReceivedError is TestError)
        #expect(output.didFetchLocationsCalled == false)
        #expect(reverseGeocoder.cityNameLatitudeLongitudeCalled == false)
    }

    @Test("cancels the previous fetch when fetching again")
    func cancelsPreviousFetch() async throws {
        let locations = try LocationsFixture.locations([("Amsterdam", 52.3547498, 4.8339215)])
        let subject = makeSubject(api: LocationsApiProtocolMock(returnValue: locations))

        subject.fetchLocations()
        let firstTask = try #require(subject.fetchTask)
        subject.fetchLocations()
        await firstTask.value
        await subject.fetchTask?.value

        #expect(firstTask.isCancelled)
        #expect(output.didFetchLocationsCallsCount == 1)
    }

    // MARK: - Reverse geocoding

    @Test("calls the reverse geocoder with the unnamed location's coordinates only")
    func callsReverseGeocoderForUnnamedLocation() async throws {
        let locations = try LocationsFixture.locations([("Amsterdam", 52.3547498, 4.8339215), (nil, 40.4380638, -3.7495758)])
        reverseGeocoder.cityNameLatitudeLongitudeReturnValue = "Madrid"

        await fetchLocations(from: LocationsApiProtocolMock(returnValue: locations))

        #expect(reverseGeocoder.cityNameLatitudeLongitudeCallsCount == 1)
        #expect(reverseGeocoder.cityNameLatitudeLongitudeReceivedArguments?.latitude == 40.4380638)
        #expect(reverseGeocoder.cityNameLatitudeLongitudeReceivedArguments?.longitude == -3.7495758)
    }

    @Test("calls output first with the fetched locations, then with the city name filled in")
    func callsOutputWithResolvedLocations() async throws {
        let locations = try LocationsFixture.locations([("Amsterdam", 52.3547498, 4.8339215), (nil, 40.4380638, -3.7495758)])
        reverseGeocoder.cityNameLatitudeLongitudeReturnValue = "Madrid"

        await fetchLocations(from: LocationsApiProtocolMock(returnValue: locations))

        #expect(output.didFetchLocationsCallsCount == 2)
        #expect(output.didFetchLocationsReceivedInvocations.first == locations.locations)

        let resolved = try #require(output.didFetchLocationsReceivedLocations)
        #expect(resolved[0] == locations.locations[0])
        #expect(resolved[1].name == "Madrid")
    }

    @Test("keeps the id and coordinates of the resolved location")
    func keepsIdentityOfResolvedLocation() async throws {
        let locations = try LocationsFixture.locations([(nil, 40.4380638, -3.7495758)])
        reverseGeocoder.cityNameLatitudeLongitudeReturnValue = "Madrid"

        await fetchLocations(from: LocationsApiProtocolMock(returnValue: locations))

        let resolved = try #require(output.didFetchLocationsReceivedLocations?.first)
        #expect(resolved.id == locations.locations[0].id)
        #expect(resolved.lat == 40.4380638)
        #expect(resolved.long == -3.7495758)
    }

    @Test("calls output only once when no city is found")
    func callsOutputOnceWithoutCity() async throws {
        let locations = try LocationsFixture.locations([(nil, 0, 0)])
        reverseGeocoder.cityNameLatitudeLongitudeReturnValue = nil

        await fetchLocations(from: LocationsApiProtocolMock(returnValue: locations))

        #expect(reverseGeocoder.cityNameLatitudeLongitudeCallsCount == 1)
        #expect(output.didFetchLocationsReceivedInvocations == [locations.locations])
    }
}
