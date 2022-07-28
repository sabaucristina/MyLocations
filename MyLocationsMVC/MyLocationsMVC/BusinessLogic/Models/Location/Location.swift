//
//  Location.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 28/01/2022.
//

import Foundation
import CoreLocation
import Contacts

struct Location: Codable, Hashable {
    let id: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let address: Address
    let date: Date
    let description: String?
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case address
        case date
        case description
        case category
    }
    
    init(
        id: String,
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        address: Address,
        date: Date,
        description: String?,
        category: String
    ) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.date = date
        self.description = description
        self.category = category
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
        address = try values.decode(Address.self, forKey: .address)
        description = try values.decode(String.self, forKey: .description)
        category = try values.decode(String.self, forKey: .category)
        
        let dateInSeconds = try values.decode(Int.self, forKey: .date)
        date = Date(timeIntervalSince1970: Double(dateInSeconds) * 100)
    }
}
