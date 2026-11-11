//
//  ApiRouter.swift
//  LocationsApi
//
//  Created by Abdullah Zubair on 13/07/2026.
//

import Foundation
import ApiService

extension String {
    fileprivate static var locationPath: String {
        "/abnamrocoesd/assignment-ios/main/locations.json"
    }
}

/// MARK: - Endpoints
extension Request {
    static var location: Request {
        Request(path: .locationPath)
    }
}
