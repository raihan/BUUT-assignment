//
//  ReverseGeocoderTests.swift
//  Utility
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import Testing
@testable import Utility

@Suite("ReverseGeocoder")
struct ReverseGeocoderTests {
    private let madrid = (latitude: 40.4380638, longitude: -3.7495758)
    private let amsterdam = (latitude: 52.3547498, longitude: 4.8339215)

    // MARK: - Lookup

    @Test("returns the city name from the lookup")
    func returnsCityName() async {
        let cityNameLookup = CityNameLookupMock(results: [.success("Madrid")])
        let subject = ReverseGeocoder(cityNameLookup: cityNameLookup)

        let cityName = await subject.cityName(latitude: madrid.latitude, longitude: madrid.longitude)

        #expect(cityName == "Madrid")
    }

    @Test("passes the coordinate to the lookup")
    func passesCoordinate() async {
        let cityNameLookup = CityNameLookupMock(results: [.success("Madrid")])
        let subject = ReverseGeocoder(cityNameLookup: cityNameLookup)

        _ = await subject.cityName(latitude: madrid.latitude, longitude: madrid.longitude)

        #expect(await cityNameLookup.cityNameLatitudeLongitudeReceivedArguments?.latitude == madrid.latitude)
        #expect(await cityNameLookup.cityNameLatitudeLongitudeReceivedArguments?.longitude == madrid.longitude)
    }

    @Test("returns nil when the lookup finds no city")
    func returnsNilWithoutCity() async {
        let subject = ReverseGeocoder(cityNameLookup: CityNameLookupMock(results: [.success(nil)]))

        let cityName = await subject.cityName(latitude: 0, longitude: 0)

        #expect(cityName == nil)
    }

    @Test("returns nil when the lookup fails")
    func returnsNilWhenLookupFails() async {
        let subject = ReverseGeocoder(cityNameLookup: CityNameLookupMock(results: [.failure(CityNameLookupError())]))

        let cityName = await subject.cityName(latitude: madrid.latitude, longitude: madrid.longitude)

        #expect(cityName == nil)
    }

    // MARK: - Caching

    @Test("caches the city name for the same coordinate")
    func cachesCityName() async {
        let cityNameLookup = CityNameLookupMock(results: [.success("Madrid")])
        let subject = ReverseGeocoder(cityNameLookup: cityNameLookup)

        let first = await subject.cityName(latitude: madrid.latitude, longitude: madrid.longitude)
        let second = await subject.cityName(latitude: madrid.latitude, longitude: madrid.longitude)

        #expect(first == "Madrid")
        #expect(second == "Madrid")
        #expect(await cityNameLookup.cityNameLatitudeLongitudeCallsCount == 1)
    }

    @Test("looks up each coordinate separately")
    func looksUpEachCoordinate() async {
        let cityNameLookup = CityNameLookupMock(results: [.success("Madrid"), .success("Amsterdam")])
        let subject = ReverseGeocoder(cityNameLookup: cityNameLookup)

        let first = await subject.cityName(latitude: madrid.latitude, longitude: madrid.longitude)
        let second = await subject.cityName(latitude: amsterdam.latitude, longitude: amsterdam.longitude)

        #expect(first == "Madrid")
        #expect(second == "Amsterdam")
        #expect(await cityNameLookup.cityNameLatitudeLongitudeCallsCount == 2)
    }

    @Test("does not cache a missing city name")
    func doesNotCacheMissingCityName() async {
        let cityNameLookup = CityNameLookupMock(results: [.success(nil), .success("Madrid")])
        let subject = ReverseGeocoder(cityNameLookup: cityNameLookup)

        let first = await subject.cityName(latitude: madrid.latitude, longitude: madrid.longitude)
        let second = await subject.cityName(latitude: madrid.latitude, longitude: madrid.longitude)

        #expect(first == nil)
        #expect(second == "Madrid")
        #expect(await cityNameLookup.cityNameLatitudeLongitudeCallsCount == 2)
    }

    @Test("retries after a failed lookup")
    func retriesAfterFailure() async {
        let cityNameLookup = CityNameLookupMock(results: [.failure(CityNameLookupError()), .success("Madrid")])
        let subject = ReverseGeocoder(cityNameLookup: cityNameLookup)

        let first = await subject.cityName(latitude: madrid.latitude, longitude: madrid.longitude)
        let second = await subject.cityName(latitude: madrid.latitude, longitude: madrid.longitude)

        #expect(first == nil)
        #expect(second == "Madrid")
        #expect(await cityNameLookup.cityNameLatitudeLongitudeCallsCount == 2)
    }
}
