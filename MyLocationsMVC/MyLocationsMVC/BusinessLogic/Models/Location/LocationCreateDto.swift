//
//  LocationsCreateDto.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 01/04/2022.
//

import Foundation

struct LocationCreateDto: Codable {
    let latitude: Double
    let longitude: Double
    let description: String?
    let category: String
    let address: AddressCreateDto
}
