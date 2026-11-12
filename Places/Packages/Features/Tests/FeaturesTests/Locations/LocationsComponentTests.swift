//
//  LocationsComponentTests.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import Testing
import UIKit
@testable import Features

@Suite("LocationsComponent")
@MainActor
struct LocationsComponentTests {
    let locationsApi = LocationsApiProtocolMock()
    let reverseGeocoder = ReverseGeocodingMock()
    let view: LocationsViewController
    let presenter: LocationsPresenter
    let interactor: LocationsInteractor
    let router: LocationsRouter

    init() throws {
        let rootViewController = LocationsComponent().assemble(locationsApi: locationsApi, reverseGeocoder: reverseGeocoder)

        view = try #require(rootViewController as? LocationsViewController)
        presenter = try #require(view.presenter as? LocationsPresenter)
        interactor = try #require(presenter.interactor as? LocationsInteractor)
        router = try #require(presenter.router as? LocationsRouter)
    }

    @Test("sets up the router dependencies")
    func setsUpRouterDependencies() {
        #expect(router.rootViewController === view)
    }

    @Test("sets up the presenter dependencies")
    func setsUpPresenterDependencies() {
        #expect(presenter.interactor === interactor)
        #expect(presenter.router === router)
        #expect(presenter.view === view)
    }

    @Test("sets up the interactor dependencies")
    func setsUpInteractorDependencies() {
        #expect(interactor.locationsApi === locationsApi)
        #expect((interactor.reverseGeocoder as? ReverseGeocodingMock) === reverseGeocoder)
        #expect(interactor.output === presenter)
    }

    @Test("sets up the view dependencies")
    func setsUpViewDependencies() {
        #expect(view.presenter === presenter)
    }
}
