//
//  LocationsRouter.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import UIKit

final class LocationsRouter: LocationsRouting {
    weak var rootViewController: UIViewController?

    var navigationController: UINavigationController? {
        rootViewController?.navigationController
    }
}
