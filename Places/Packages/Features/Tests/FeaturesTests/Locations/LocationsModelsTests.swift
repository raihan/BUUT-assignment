//
//  LocationsModelsTests.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import Testing
@testable import Features

@Suite("LocationsMessageViewModel")
struct LocationsModelsTests {
    let subject = LocationsMessageViewModel(
        imageName: "mappin.slash",
        title: "No Locations",
        message: "There are no locations to show right now.",
        actionTitle: "Refresh"
    )

    @Test("is equal to a view model with the same values")
    func equalWithSameValues() {
        let other = LocationsMessageViewModel(
            imageName: "mappin.slash",
            title: "No Locations",
            message: "There are no locations to show right now.",
            actionTitle: "Refresh"
        )

        #expect(subject == other)
    }

    @Test("is not equal to a view model with different values")
    func notEqualWithDifferentValues() {
        let other = LocationsMessageViewModel(
            imageName: "wifi.exclamationmark",
            title: "Something Went Wrong",
            message: "We couldn't load the locations. Check your connection and try again.",
            actionTitle: "Try Again"
        )

        #expect(subject != other)
    }
}
