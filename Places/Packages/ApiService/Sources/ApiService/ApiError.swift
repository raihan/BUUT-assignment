//
//  ApiError.swift
//  ApiService
//
//  Created by Abdullah Zubair on 11/11/2026.
//

import Foundation

public enum ApiError: Error, Sendable {
    case invalidUrl
    case invalidResponse
    case statusCode(Int)
    case decodeFailed(Error)
    case requestFailure(Error)
    case other(Error)
}
