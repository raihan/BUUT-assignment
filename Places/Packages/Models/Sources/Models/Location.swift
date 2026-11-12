//
//  Location.swift
//  Models
//
//  Created by Abdullah Zubair on 11/11/2026.
//

import Foundation

public struct Location: Decodable, Sendable, Equatable {
    public let name: String?
    public let lat: Double
    public let long: Double
    
    public init(name: String?, lat: Double, long: Double) {
        self.name = name
        self.lat = lat
        self.long = long
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.init(
            name: container.decodeIfPresent(String.self, forKey: .name),
            lat: container.decode(Double.self, forKey: .lat),
            long: container.decode(Double.self, forKey: .long)
        )
    }
 
    private enum CodingKeys: String, CodingKey {
        case name, lat, long
    }
}
