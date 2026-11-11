//
//  LocationsModels.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import Foundation

/// Full-screen message shown instead of the list (empty or error state).
struct LocationsMessageViewModel: Equatable {
    let imageName: String
    let title: String
    let message: String
    let actionTitle: String
}
