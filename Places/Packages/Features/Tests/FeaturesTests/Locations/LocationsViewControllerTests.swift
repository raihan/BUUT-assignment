//
//  LocationsViewControllerTests.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import Testing
import UIKit
import UIComponents
@testable import Features

@Suite("LocationsViewController")
@MainActor
struct LocationsViewControllerTests {
    let subject = LocationsViewController()
    let presenter = LocationsPresentingMock()
    let tableView = UITableViewPartialMock()
    let refreshControl = UIRefreshControlPartialMock()

    let amsterdam = LocationCellViewModel(name: "Amsterdam", coordinates: "52.3547, 4.8339")
    let mumbai = LocationCellViewModel(name: "Mumbai", coordinates: "19.0824, 72.8111")

    init() {
        subject.presenter = presenter
    }

    /// Swaps in the partial mocks so UIKit calls can be checked.
    private func usePartialMocks() {
        subject.tableView = tableView
        subject.refreshControl = refreshControl
    }

    // MARK: - Table view

    @Test("sets up the table view")
    func setsUpTableView() {
        let tableView = subject.tableView

        #expect(tableView.translatesAutoresizingMaskIntoConstraints == false)
        #expect(tableView.style == .insetGrouped)
        #expect(tableView.dataSource === subject)
        #expect(tableView.delegate === subject)
        #expect(tableView.refreshControl === subject.refreshControl)
    }

    @Test("registers the location cell")
    func registersLocationCell() {
        #expect(subject.tableView.dequeueReusableCell(withIdentifier: "LocationCell") is LocationCell)
    }

    // MARK: - View did load

    @Test("sets the title and large titles on view did load")
    func setsTitle() {
        let navigationController = UINavigationController(rootViewController: subject)

        subject.loadViewIfNeeded()

        #expect(subject.title == "Locations")
        #expect(navigationController.navigationBar.prefersLargeTitles == true)
        #expect(subject.view.backgroundColor == .systemBackground)
    }

    @Test("adds the table view pinned to the edges on view did load")
    func addsTableView() {
        subject.loadViewIfNeeded()
        subject.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
        subject.view.layoutIfNeeded()

        #expect(subject.tableView.superview === subject.view)
        #expect(subject.tableView.frame == subject.view.bounds)
    }

    @Test("calls presenter on view did load")
    func callsPresenterOnViewDidLoad() {
        subject.loadViewIfNeeded()

        #expect(presenter.viewDidLoadCallsCount == 1)
    }

    @Test("calls presenter on pull to refresh")
    func callsPresenterOnPullToRefresh() {
        subject.loadViewIfNeeded()

        subject.refreshControl.sendActions(for: .valueChanged)

        #expect(presenter.didPullToRefreshCallsCount == 1)
    }

    // MARK: - Loading

    @Test("shows the loading state")
    func showsLoadingState() throws {
        subject.showLoading()

        let configuration = try #require(subject.contentUnavailableConfiguration as? UIContentUnavailableConfiguration)
        #expect(configuration.text == UIContentUnavailableConfiguration.loading().text)
        #expect(configuration.secondaryText == nil)
        #expect(configuration.button.title == nil)
    }

    // MARK: - Locations

    @Test("updates the view models and reloads data when showing locations")
    func showsLocations() {
        usePartialMocks()

        subject.show(locations: [amsterdam, mumbai])

        #expect(subject.locations == [amsterdam, mumbai])
        #expect(tableView.reloadDataCalled == true)
        #expect(refreshControl.endRefreshingCalled == true)
    }

    @Test("hides the loading state when showing locations")
    func hidesLoadingState() {
        usePartialMocks()
        subject.showLoading()

        subject.show(locations: [amsterdam])

        #expect(subject.contentUnavailableConfiguration == nil)
    }

    // MARK: - Message

    @Test("clears the view models and reloads data when showing a message")
    func clearsLocationsWhenShowingMessage() {
        usePartialMocks()
        subject.show(locations: [amsterdam])

        subject.showMessage(.example)

        #expect(subject.locations.isEmpty)
        #expect(tableView.reloadDataCalled == true)
        #expect(refreshControl.endRefreshingCalled == true)
    }

    @Test("shows the message content and action button")
    func showsMessage() throws {
        usePartialMocks()

        subject.showMessage(.example)

        let configuration = try #require(subject.contentUnavailableConfiguration as? UIContentUnavailableConfiguration)
        #expect(configuration.image == UIImage(systemName: "wifi.exclamationmark"))
        #expect(configuration.text == "Something Went Wrong")
        #expect(configuration.secondaryText == "Check your connection.")
        #expect(configuration.button.title == "Try Again")
        #expect(configuration.buttonProperties.primaryAction != nil)
    }

    // MARK: - UITableViewDataSource

    @Test("returns a row per location")
    func numberOfRows() {
        usePartialMocks()
        subject.show(locations: [amsterdam, mumbai])

        #expect(subject.tableView(tableView, numberOfRowsInSection: 0) == 2)
    }

    @Test("dequeues and configures the location cell")
    func cellForRow() throws {
        let cell = LocationCell()
        let indexPath = IndexPath(row: 1, section: 0)
        tableView.dequeueReusableCellReturnValue = cell
        usePartialMocks()
        subject.show(locations: [amsterdam, mumbai])

        let receivedCell = subject.tableView(tableView, cellForRowAt: indexPath)

        #expect(receivedCell === cell)
        #expect(tableView.dequeueReusableCellReceivedArguments?.identifier == "LocationCell")
        #expect(tableView.dequeueReusableCellReceivedArguments?.indexPath == indexPath)

        let content = try #require(cell.contentConfiguration as? UIListContentConfiguration)
        #expect(content.text == "Mumbai")
        #expect(content.secondaryText == "19.0824, 72.8111")
    }

    @Test("returns an empty cell when the dequeued cell is not a location cell")
    func cellForRowFallback() {
        let cell = UITableViewCell()
        tableView.dequeueReusableCellReturnValue = cell
        usePartialMocks()
        subject.show(locations: [amsterdam])

        let receivedCell = subject.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        #expect(receivedCell !== cell)
        #expect(receivedCell is LocationCell == false)
        #expect(receivedCell.contentConfiguration == nil)
    }

    // MARK: - UITableViewDelegate

    @Test("deselects the row with animation after selecting a location")
    func didSelectRow() {
        let indexPath = IndexPath(row: 0, section: 0)

        subject.tableView(tableView, didSelectRowAt: indexPath)

        #expect(tableView.deselectRowReceivedArguments?.indexPath == indexPath)
        #expect(tableView.deselectRowReceivedArguments?.animated == true)
        #expect(presenter.didTapRetryCalled == false)
        #expect(presenter.didPullToRefreshCalled == false)
    }
}

private extension LocationsMessageViewModel {
    static var example: LocationsMessageViewModel {
        LocationsMessageViewModel(
            imageName: "wifi.exclamationmark",
            title: "Something Went Wrong",
            message: "Check your connection.",
            actionTitle: "Try Again"
        )
    }
}
