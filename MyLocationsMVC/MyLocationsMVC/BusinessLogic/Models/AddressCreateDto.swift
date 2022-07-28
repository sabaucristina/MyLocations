//
//  AddressCreateDto.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 01/04/2022.
//

import Foundation

struct AddressCreateDto: Codable {
    let street: String?
    let postalCode: String?
    let city: String?
    let country: String?
    
    init(address: Address) {
        self.street = address.street
        self.postalCode = address.postalCode
        self.city = address.city
        self.country = address.country
    }
}
