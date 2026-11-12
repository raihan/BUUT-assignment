//
//  LocationsContract.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import UIKit
import LocationsApi
import Models
import UIComponents
import Utility

@MainActor
public protocol LocationsComponentType {
    func assemble(locationsApi: LocationsApiProtocol, reverseGeocoder: ReverseGeocoding) -> UIViewController
}

@MainActor
protocol LocationsRouting: AnyObject {
    var rootViewController: UIViewController? { get set }
}

@MainActor
protocol LocationsPresenting: AnyObject {
    var interactor: LocationsInteracting { get }
    var router: LocationsRouting { get }
    var view: LocationsViewable? { get set }

    func viewDidLoad()
    func didPullToRefresh()
    func didTapRetry()
}

@MainActor
protocol LocationsInteracting: AnyObject {
    var output: LocationsInteractingOutput? { get set }

    func fetchLocations()
}

@MainActor
protocol LocationsInteractingOutput: AnyObject {
    func didFetchLocations(_ locations: [Location])
    func didFailFetchingLocations(error: Error)
}

@MainActor
protocol LocationsViewable: AnyObject {
    var presenter: LocationsPresenting { get }

    func showLoading()
    func show(locations: [LocationCellViewModel])
    func showMessage(_ viewModel: LocationsMessageViewModel)
}
