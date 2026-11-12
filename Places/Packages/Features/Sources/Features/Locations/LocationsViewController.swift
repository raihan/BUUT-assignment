//
//  LocationsViewController.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import UIKit
import UIComponents

final class LocationsViewController: UIViewController, LocationsViewable {
    let presenter: LocationsPresenting

    private(set) var locations: [LocationCellViewModel] = []
    var refreshControl = UIRefreshControl()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LocationCell.self, forCellReuseIdentifier: .locationCellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        return tableView
    }()

    init(presenter: LocationsPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.viewDidLoad()
    }

    private func setupViews() {
        title = .locationsTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        refreshControl.addAction(UIAction { [weak self] _ in self?.presenter.didPullToRefresh() }, for: .valueChanged)
    }

    // MARK: LocationsViewable

    func showLoading() {
        contentUnavailableConfiguration = UIContentUnavailableConfiguration.loading()
    }

    func show(locations: [LocationCellViewModel]) {
        refreshControl.endRefreshing()
        contentUnavailableConfiguration = nil
        reload(with: locations)
    }

    func showMessage(_ viewModel: LocationsMessageViewModel) {
        refreshControl.endRefreshing()
        reload(with: [])

        var configuration = UIContentUnavailableConfiguration.empty()
        configuration.image = UIImage(systemName: viewModel.imageName)
        configuration.text = viewModel.title
        configuration.secondaryText = viewModel.message
        configuration.button = .borderedProminent()
        configuration.button.title = viewModel.actionTitle
        configuration.buttonProperties.primaryAction = UIAction { [weak self] _ in self?.presenter.didTapRetry() }
        contentUnavailableConfiguration = configuration
    }

    // MARK: Helpers

    private func reload(with locations: [LocationCellViewModel]) {
        self.locations = locations
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension LocationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: .locationCellReuseIdentifier,
            for: indexPath
        ) as? LocationCell else {
            return UITableViewCell()
        }

        cell.configure(with: locations[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension LocationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Strings

extension String {
    fileprivate static var locationsTitle: String { "Locations" }
}
