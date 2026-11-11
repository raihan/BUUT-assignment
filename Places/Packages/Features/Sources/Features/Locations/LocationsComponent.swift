//
//  LocationsComponent.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import UIKit
import LocationsApi
import Utility

public final class LocationsComponent: LocationsComponentType {
    public init() {}

    public func assemble(locationsApi: LocationsApiProtocol, reverseGeocoder: ReverseGeocoding) -> UIViewController {
        let router = LocationsRouter()
        let view = LocationsViewController()
        let presenter = LocationsPresenter()
        let interactor = LocationsInteractor(locationsApi: locationsApi, reverseGeocoder: reverseGeocoder)

        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router

        view.presenter = presenter

        interactor.output = presenter

        router.rootViewController = view

        return view
    }
}
