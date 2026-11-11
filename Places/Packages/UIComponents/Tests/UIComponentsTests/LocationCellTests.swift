//
//  LocationCellTests.swift
//  UIComponents
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import Testing
import UIKit
@testable import UIComponents

@Suite
@MainActor
struct LocationCellTests {

    private let viewModel = LocationCellViewModel(name: "Amsterdam", coordinates: "52.3547, 4.8339")

    private func makeSUT() -> LocationCell {
        LocationCell(style: .default, reuseIdentifier: .locationCellReuseIdentifier)
    }

    // MARK: - Configure

    @Test
    func configureShowsNameAsText() throws {
        // Given
        let sut = makeSUT()

        // When
        sut.configure(with: viewModel)

        // Then
        let content = try #require(sut.contentConfiguration as? UIListContentConfiguration)
        #expect(content.text == "Amsterdam")
    }

    @Test
    func configureShowsCoordinatesAsSecondaryText() throws {
        // Given
        let sut = makeSUT()

        // When
        sut.configure(with: viewModel)

        // Then
        let content = try #require(sut.contentConfiguration as? UIListContentConfiguration)
        #expect(content.secondaryText == "52.3547, 4.8339")
        #expect(content.secondaryTextProperties.color == .secondaryLabel)
    }

    @Test
    func configureShowsLocationSymbol() throws {
        // Given
        let sut = makeSUT()

        // When
        sut.configure(with: viewModel)

        // Then
        let content = try #require(sut.contentConfiguration as? UIListContentConfiguration)
        let image = try #require(content.image)
        #expect(image.isSymbolImage)
    }

    @Test
    func configureReplacesPreviousContent() throws {
        // Given
        let sut = makeSUT()
        sut.configure(with: viewModel)

        // When
        sut.configure(with: LocationCellViewModel(name: "Madrid", coordinates: "40.4381, -3.7496"))

        // Then
        let content = try #require(sut.contentConfiguration as? UIListContentConfiguration)
        #expect(content.text == "Madrid")
        #expect(content.secondaryText == "40.4381, -3.7496")
    }

    // MARK: - Reuse

    @Test
    func prepareForReuseClearsContent() {
        // Given
        let sut = makeSUT()
        sut.configure(with: viewModel)

        // When
        sut.prepareForReuse()

        // Then
        #expect(sut.contentConfiguration == nil)
    }

    @Test
    func reuseIdentifierMatchesCellName() {
        #expect(String.locationCellReuseIdentifier == "LocationCell")
    }

    // MARK: - View model

    @Test
    func viewModelsWithSameValuesAreEqual() {
        // Given
        let other = LocationCellViewModel(name: "Amsterdam", coordinates: "52.3547, 4.8339")

        // Then
        #expect(viewModel == other)
    }

    @Test
    func viewModelsWithDifferentValuesAreNotEqual() {
        // Given
        let other = LocationCellViewModel(name: "Madrid", coordinates: "40.4381, -3.7496")

        // Then
        #expect(viewModel != other)
    }
}
