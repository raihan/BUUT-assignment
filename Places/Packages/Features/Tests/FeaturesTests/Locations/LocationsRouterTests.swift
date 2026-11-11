//
//  LocationsRouterTests.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import Testing
import UIKit
@testable import Features

@Suite("LocationsRouter")
@MainActor
struct LocationsRouterTests {
    let subject = LocationsRouter()
    let rootViewController = UIViewController()

    init() {
        subject.rootViewController = rootViewController
    }

    @Test("keeps a reference to the root view controller")
    func keepsRootViewController() {
        #expect(subject.rootViewController === rootViewController)
    }

    @Test("returns the root view controller's navigation controller")
    func returnsNavigationController() {
        let navigationController = UINavigationController(rootViewController: rootViewController)

        #expect(subject.navigationController === navigationController)
    }

    @Test("returns no navigation controller outside a navigation stack")
    func returnsNilNavigationController() {
        #expect(subject.navigationController == nil)
    }

    @Test("does not retain the root view controller")
    func doesNotRetainRootViewController() {
        let subject = LocationsRouter()
        var rootViewController: UIViewController? = UIViewController()
        subject.rootViewController = rootViewController

        rootViewController = nil

        #expect(subject.rootViewController == nil)
    }
}
