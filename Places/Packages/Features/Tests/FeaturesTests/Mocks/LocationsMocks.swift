//
//  LocationsMocks.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import UIKit
import Models
import UIComponents
@testable import Features

// MARK: - LocationsPresentingMock

final class LocationsPresentingMock: LocationsPresenting {
    var interactor: LocationsInteracting!
    var router: LocationsRouting!
    weak var view: LocationsViewable?

    private(set) var viewDidLoadCallsCount = 0
    var viewDidLoadCalled: Bool { viewDidLoadCallsCount > 0 }

    func viewDidLoad() {
        viewDidLoadCallsCount += 1
    }

    private(set) var didPullToRefreshCallsCount = 0
    var didPullToRefreshCalled: Bool { didPullToRefreshCallsCount > 0 }

    func didPullToRefresh() {
        didPullToRefreshCallsCount += 1
    }

    private(set) var didTapRetryCallsCount = 0
    var didTapRetryCalled: Bool { didTapRetryCallsCount > 0 }

    func didTapRetry() {
        didTapRetryCallsCount += 1
    }
}

// MARK: - LocationsInteractingMock

final class LocationsInteractingMock: LocationsInteracting {
    weak var output: LocationsInteractingOutput?

    private(set) var fetchLocationsCallsCount = 0
    var fetchLocationsCalled: Bool { fetchLocationsCallsCount > 0 }

    func fetchLocations() {
        fetchLocationsCallsCount += 1
    }
}

// MARK: - LocationsInteractingOutputMock

final class LocationsInteractingOutputMock: LocationsInteractingOutput {
    private(set) var didFetchLocationsReceivedInvocations: [[Location]] = []
    var didFetchLocationsCallsCount: Int { didFetchLocationsReceivedInvocations.count }
    var didFetchLocationsCalled: Bool { didFetchLocationsCallsCount > 0 }
    var didFetchLocationsReceivedLocations: [Location]? { didFetchLocationsReceivedInvocations.last }

    func didFetchLocations(_ locations: [Location]) {
        didFetchLocationsReceivedInvocations.append(locations)
    }

    private(set) var didFailFetchingLocationsCallsCount = 0
    var didFailFetchingLocationsCalled: Bool { didFailFetchingLocationsCallsCount > 0 }
    private(set) var didFailFetchingLocationsReceivedError: (any Error)?

    func didFailFetchingLocations(error: Error) {
        didFailFetchingLocationsCallsCount += 1
        didFailFetchingLocationsReceivedError = error
    }
}

// MARK: - LocationsViewableMock

final class LocationsViewableMock: LocationsViewable {
    var presenter: LocationsPresenting!

    private(set) var showLoadingCallsCount = 0
    var showLoadingCalled: Bool { showLoadingCallsCount > 0 }

    func showLoading() {
        showLoadingCallsCount += 1
    }

    private(set) var showLocationsCallsCount = 0
    var showLocationsCalled: Bool { showLocationsCallsCount > 0 }
    private(set) var showLocationsReceivedLocations: [LocationCellViewModel]?

    func show(locations: [LocationCellViewModel]) {
        showLocationsCallsCount += 1
        showLocationsReceivedLocations = locations
    }

    private(set) var showMessageCallsCount = 0
    var showMessageCalled: Bool { showMessageCallsCount > 0 }
    private(set) var showMessageReceivedViewModel: LocationsMessageViewModel?

    func showMessage(_ viewModel: LocationsMessageViewModel) {
        showMessageCallsCount += 1
        showMessageReceivedViewModel = viewModel
    }
}

// MARK: - LocationsRoutingMock

final class LocationsRoutingMock: LocationsRouting {
    weak var rootViewController: UIViewController?
}
