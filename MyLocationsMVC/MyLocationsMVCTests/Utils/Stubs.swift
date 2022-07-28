//
//  Stubs.swift
//  MyLocationsMVCTests
//
//  Created by Sabau Cristina on 07/03/2022.
//

import Foundation
@testable import MyLocationsMVC

extension Address {
    static func stub(
        street: String? = "street",
        postalCode: String? = "postalCode",
        city: String? = "city",
        country: String? = "country"
    ) -> Address {
        Address(
            street: street,
            postalCode: postalCode,
            city: city,
            country: country
        )
    }
}

extension Location {
    static func stub(
        id: String = UUID().uuidString,
        latitude: Double = 10,
        longitude: Double = 20,
        address: Address = .stub(),
        date: Date = .distantPast,
        description: String? = nil,
        category: String = "some"
    ) -> Location {
        Location(
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
