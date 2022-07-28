//
//  LocationResponseDto.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 01/04/2022.
//

import Foundation
import CoreLocation

struct LocationResponseDto: Codable {
    let id: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let address: Address
    let date: Date
    let description: String?
    let category: String
    
    func toDomain() -> Location {
        .init(
            id: id,
            latitude: latitude,
            longitude: longitude,
            address: address,
            date: date,
            description: description,
            category: category
        )
    }
}
