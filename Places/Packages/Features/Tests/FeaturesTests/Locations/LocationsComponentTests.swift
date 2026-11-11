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
    @MainActor
    final class LocationsComponentUnwrapper {
        private let componentView: UIViewController

        var view: LocationsViewController {
            componentView as! LocationsViewController
        }

        var presenter: LocationsPresenter {
            view.presenter as! LocationsPresenter
        }

        var interactor: LocationsInteractor {
            presenter.interactor as! LocationsInteractor
        }

        var router: LocationsRouter {
            presenter.router as! LocationsRouter
        }

        init(componentView: UIViewController) {
            self.componentView = componentView
        }
    }

    let locationsApi: LocationsApiProtocolMock
    let reverseGeocoder: ReverseGeocodingMock
    let component: LocationsComponent
    let view: LocationsViewController
    let presenter: LocationsPresenter
    let interactor: LocationsInteractor
    let router: LocationsRouter

    init() {
        locationsApi = LocationsApiProtocolMock()
        reverseGeocoder = ReverseGeocodingMock()
        component = LocationsComponent()

        let rootViewController = component.assemble(locationsApi: locationsApi, reverseGeocoder: reverseGeocoder)
        let module = LocationsComponentUnwrapper(componentView: rootViewController)

        view = module.view
        presenter = module.presenter
        interactor = module.interactor
        router = module.router
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
