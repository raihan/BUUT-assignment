//
//  LocationsPresenter.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import Foundation
import Models
import UIComponents

final class LocationsPresenter: LocationsPresenting {
    var interactor: LocationsInteracting!
    var router: LocationsRouting!
    weak var view: LocationsViewable?

    private let coordinateFormat = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(4))

    // MARK: LocationsPresenting

    func viewDidLoad() {
        view?.showLoading()
        interactor.fetchLocations()
    }

    func didPullToRefresh() {
        interactor.fetchLocations()
    }

    func didTapRetry() {
        view?.showLoading()
        interactor.fetchLocations()
    }

    // MARK: Formatting

    private func makeCellViewModel(from location: Location) -> LocationCellViewModel {
        LocationCellViewModel(
            name: location.name ?? .unnamedLocation,
            coordinates: "\(location.lat.formatted(coordinateFormat)), \(location.long.formatted(coordinateFormat))"
        )
    }
}

// MARK: - LocationsInteractingOutput

extension LocationsPresenter: LocationsInteractingOutput {
    func didFetchLocations(_ locations: [Location]) {
        guard !locations.isEmpty else {
            view?.showMessage(LocationsMessageViewModel(
                imageName: .emptyStateImageName,
                title: .emptyStateTitle,
                message: .emptyStateMessage,
                actionTitle: .emptyStateActionTitle
            ))
            return
        }

        view?.show(locations: locations.map(makeCellViewModel))
    }

    func didFailFetchingLocations(error: Error) {
        view?.showMessage(LocationsMessageViewModel(
            imageName: .errorStateImageName,
            title: .errorStateTitle,
            message: .errorStateMessage,
            actionTitle: .errorStateActionTitle
        ))
    }
}

// MARK: - Strings

extension String {
    fileprivate static var unnamedLocation: String { "Unnamed location" }

    fileprivate static var emptyStateImageName: String { "mappin.slash" }
    fileprivate static var emptyStateTitle: String { "No Locations" }
    fileprivate static var emptyStateMessage: String { "There are no locations to show right now." }
    fileprivate static var emptyStateActionTitle: String { "Refresh" }

    fileprivate static var errorStateImageName: String { "wifi.exclamationmark" }
    fileprivate static var errorStateTitle: String { "Something Went Wrong" }
    fileprivate static var errorStateMessage: String {
        "We couldn't load the locations. Check your connection and try again."
    }
    fileprivate static var errorStateActionTitle: String { "Try Again" }
}
