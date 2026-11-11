//
//  LocationsPresenterTests.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import Testing
import Foundation
import Models
import UIComponents
@testable import Features

@Suite("LocationsPresenter")
@MainActor
struct LocationsPresenterTests {
    let subject = LocationsPresenter()
    let interactor = LocationsInteractingMock()
    let router = LocationsRoutingMock()
    let view = LocationsViewableMock()

    init() {
        subject.interactor = interactor
        subject.router = router
        subject.view = view
    }

    // MARK: - View events

    @Test("shows the loading state and fetches locations on view did load")
    func viewDidLoad() {
        subject.viewDidLoad()

        #expect(view.showLoadingCallsCount == 1)
        #expect(interactor.fetchLocationsCallsCount == 1)
    }

    @Test("fetches locations without showing the loading state on pull to refresh")
    func didPullToRefresh() {
        subject.didPullToRefresh()

        #expect(view.showLoadingCalled == false)
        #expect(interactor.fetchLocationsCallsCount == 1)
    }

    @Test("shows the loading state and fetches locations on retry")
    func didTapRetry() {
        subject.didTapRetry()

        #expect(view.showLoadingCallsCount == 1)
        #expect(interactor.fetchLocationsCallsCount == 1)
    }

    // MARK: - Fetched locations

    @Test("shows a cell view model per location")
    func showsCellViewModels() {
        subject.didFetchLocations([
            Location(name: "Amsterdam", lat: 52.3547498, long: 4.8339215),
            Location(name: "Mumbai", lat: 19.0823998, long: 72.8111468)
        ])

        #expect(view.showLocationsReceivedLocations == [
            LocationCellViewModel(name: "Amsterdam", coordinates: "\(formatted(52.3547498)), \(formatted(4.8339215))"),
            LocationCellViewModel(name: "Mumbai", coordinates: "\(formatted(19.0823998)), \(formatted(72.8111468))")
        ])
        #expect(view.showMessageCalled == false)
    }

    @Test("rounds the coordinates to four decimals")
    func roundsCoordinates() throws {
        subject.didFetchLocations([Location(name: "Amsterdam", lat: 52.3547498, long: 4.8339215)])

        let separator = Locale.current.decimalSeparator ?? "."
        let viewModel = try #require(view.showLocationsReceivedLocations?.first)
        #expect(viewModel.coordinates == "52\(separator)3547, 4\(separator)8339")
    }

    @Test("keeps the sign of negative coordinates")
    func keepsNegativeCoordinates() throws {
        subject.didFetchLocations([Location(name: "Madrid", lat: 40.4380638, long: -3.7495758)])

        let viewModel = try #require(view.showLocationsReceivedLocations?.first)
        #expect(viewModel.coordinates == "\(formatted(40.4380638)), \(formatted(-3.7495758))")
    }

    @Test("shows a placeholder for a location without a name")
    func showsPlaceholderForUnnamedLocation() {
        subject.didFetchLocations([Location(name: nil, lat: 40.4380638, long: -3.7495758)])

        #expect(view.showLocationsReceivedLocations?.first?.name == "Unnamed location")
    }

    @Test("shows the empty state when there are no locations")
    func showsEmptyState() {
        subject.didFetchLocations([])

        #expect(view.showMessageReceivedViewModel == LocationsMessageViewModel(
            imageName: "mappin.slash",
            title: "No Locations",
            message: "There are no locations to show right now.",
            actionTitle: "Refresh"
        ))
        #expect(view.showLocationsCalled == false)
    }

    // MARK: - Failure

    @Test("shows the error state when fetching fails")
    func showsErrorState() {
        subject.didFailFetchingLocations(error: TestError())

        #expect(view.showMessageReceivedViewModel == LocationsMessageViewModel(
            imageName: "wifi.exclamationmark",
            title: "Something Went Wrong",
            message: "We couldn't load the locations. Check your connection and try again.",
            actionTitle: "Try Again"
        ))
        #expect(view.showLocationsCalled == false)
    }

    @Test("does not fetch again by itself when fetching fails")
    func doesNotRetryAutomatically() {
        subject.didFailFetchingLocations(error: TestError())

        #expect(interactor.fetchLocationsCalled == false)
    }

    // MARK: - Helpers

    /// Formats a coordinate the way the presenter does, so the tests pass in any locale.
    private func formatted(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(4)))
    }
}
