//
//  UIKitPartialMocks.swift
//  Features
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import UIKit

// MARK: - UITableViewPartialMock

final class UITableViewPartialMock: UITableView {
    init() {
        super.init(frame: .zero, style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private(set) var reloadDataCalled = false

    override func reloadData() {
        reloadDataCalled = true
    }

    private(set) var dequeueReusableCellReceivedArguments: (identifier: String, indexPath: IndexPath)?
    var dequeueReusableCellReturnValue = UITableViewCell()

    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        dequeueReusableCellReceivedArguments = (identifier: identifier, indexPath: indexPath)
        return dequeueReusableCellReturnValue
    }

    private(set) var deselectRowReceivedArguments: (indexPath: IndexPath, animated: Bool)?

    override func deselectRow(at indexPath: IndexPath, animated: Bool) {
        deselectRowReceivedArguments = (indexPath: indexPath, animated: animated)
    }
}

// MARK: - UIRefreshControlPartialMock

final class UIRefreshControlPartialMock: UIRefreshControl {
    private(set) var endRefreshingCalled = false

    override func endRefreshing() {
        endRefreshingCalled = true
    }
}
