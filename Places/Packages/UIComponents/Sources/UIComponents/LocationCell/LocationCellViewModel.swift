//
//  LocationCellViewModel.swift
//  UIComponents
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import Foundation

/// Display data for a single `LocationCell`, already formatted for display.
public struct LocationCellViewModel: Equatable, Sendable {
    public let name: String
    public let coordinates: String

    public init(name: String, coordinates: String) {
        self.name = name
        self.coordinates = coordinates
    }
}
