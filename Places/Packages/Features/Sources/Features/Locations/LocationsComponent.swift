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
        let interactor = LocationsInteractor(locationsApi: locationsApi, reverseGeocoder: reverseGeocoder)
        let presenter = LocationsPresenter(interactor: interactor, router: router)
        let view = LocationsViewController(presenter: presenter)

        presenter.view = view
        interactor.output = presenter
        router.rootViewController = view

        return view
    }
}
