//
//  LocationsResponseDto.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 01/04/2022.
//

import Foundation

struct LocationsResponseDto: Decodable {
    let locations: [LocationResponseDto]
}
