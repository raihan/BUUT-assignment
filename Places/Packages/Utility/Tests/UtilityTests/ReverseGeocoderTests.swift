//
//  ReverseGeocoderTests.swift
//  Utility
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import Testing
@testable import Utility

@Suite
struct ReverseGeocoderTests {

    private func makeSUT(spy: CityNameLookupSpy) -> ReverseGeocoder {
        ReverseGeocoder(lookup: { try await spy.lookup(latitude: $0, longitude: $1) })
    }

    // MARK: - Lookup

    @Test
    func returnsCityNameFromLookup() async {
        // Given
        let spy = CityNameLookupSpy(results: [.success("Madrid")])
        let sut = makeSUT(spy: spy)

        // When
        let cityName = await sut.cityName(latitude: 40.4380638, longitude: -3.7495758)

        // Then
        #expect(cityName == "Madrid")
    }

    @Test
    func passesCoordinateToLookup() async {
        // Given
        let spy = CityNameLookupSpy(results: [.success("Madrid")])
        let sut = makeSUT(spy: spy)

        // When
        _ = await sut.cityName(latitude: 40.4380638, longitude: -3.7495758)

        // Then
        #expect(await spy.lastLatitude == 40.4380638)
        #expect(await spy.lastLongitude == -3.7495758)
    }

    @Test
    func returnsNilWhenLookupFindsNoCity() async {
        // Given
        let spy = CityNameLookupSpy(results: [.success(nil)])
        let sut = makeSUT(spy: spy)

        // When
        let cityName = await sut.cityName(latitude: 0, longitude: 0)

        // Then
        #expect(cityName == nil)
    }

    @Test
    func returnsNilWhenLookupThrows() async {
        // Given
        let spy = CityNameLookupSpy(results: [.failure(CityNameLookupError())])
        let sut = makeSUT(spy: spy)

        // When
        let cityName = await sut.cityName(latitude: 40.4380638, longitude: -3.7495758)

        // Then
        #expect(cityName == nil)
    }

    // MARK: - Caching

    @Test
    func cachesCityNameForSameCoordinate() async {
        // Given
        let spy = CityNameLookupSpy(results: [.success("Madrid")])
        let sut = makeSUT(spy: spy)

        // When
        let first = await sut.cityName(latitude: 40.4380638, longitude: -3.7495758)
        let second = await sut.cityName(latitude: 40.4380638, longitude: -3.7495758)

        // Then
        #expect(first == "Madrid")
        #expect(second == "Madrid")
        #expect(await spy.callCount == 1)
    }

    @Test
    func looksUpEachCoordinateSeparately() async {
        // Given
        let spy = CityNameLookupSpy(results: [.success("Madrid"), .success("Amsterdam")])
        let sut = makeSUT(spy: spy)

        // When
        let madrid = await sut.cityName(latitude: 40.4380638, longitude: -3.7495758)
        let amsterdam = await sut.cityName(latitude: 52.3547498, longitude: 4.8339215)

        // Then
        #expect(madrid == "Madrid")
        #expect(amsterdam == "Amsterdam")
        #expect(await spy.callCount == 2)
    }

    @Test
    func doesNotCacheMissingCityName() async {
        // Given
        let spy = CityNameLookupSpy(results: [.success(nil), .success("Madrid")])
        let sut = makeSUT(spy: spy)

        // When
        let first = await sut.cityName(latitude: 40.4380638, longitude: -3.7495758)
        let second = await sut.cityName(latitude: 40.4380638, longitude: -3.7495758)

        // Then
        #expect(first == nil)
        #expect(second == "Madrid")
        #expect(await spy.callCount == 2)
    }

    @Test
    func retriesAfterFailedLookup() async {
        // Given
        let spy = CityNameLookupSpy(results: [.failure(CityNameLookupError()), .success("Madrid")])
        let sut = makeSUT(spy: spy)

        // When
        let first = await sut.cityName(latitude: 40.4380638, longitude: -3.7495758)
        let second = await sut.cityName(latitude: 40.4380638, longitude: -3.7495758)

        // Then
        #expect(first == nil)
        #expect(second == "Madrid")
        #expect(await spy.callCount == 2)
    }
}
