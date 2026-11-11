//
//  LocationCell.swift
//  UIComponents
//
//  Created by Abdullah Zubair on 11/11/2026.
//  Copyright (c) 2026 DEPT. All rights reserved.
//

import UIKit

public final class LocationCell: UITableViewCell {
    public func configure(with viewModel: LocationCellViewModel) {
        var content = UIListContentConfiguration.subtitleCell()
        content.image = UIImage(systemName: .locationCellImageName)
        content.text = viewModel.name
        content.secondaryText = viewModel.coordinates
        content.secondaryTextProperties.color = .secondaryLabel
        contentConfiguration = content
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        contentConfiguration = nil
    }
}

// MARK: - Strings

extension String {
    public static var locationCellReuseIdentifier: String { "LocationCell" }

    fileprivate static var locationCellImageName: String { "mappin.circle.fill" }
}
