//
//  Address.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 08/02/2022.
//

import Foundation
import Contacts
import CoreLocation

struct Address: Codable, Hashable {
    let street: String?
    let postalCode: String?
    let city: String?
    let country: String?
    
    init(
        street: String?,
        postalCode: String?,
        city: String?,
        country: String?
    ) {
        self.street = street
        self.postalCode = postalCode
        self.city = city
        self.country = country
    }
    
    init(placemark: CLPlacemark) {
        street =  placemark.postalAddress?.street
        postalCode = placemark.postalCode
        city = placemark.postalAddress?.city
        country = placemark.country
    }
    
    func formattedAddress() -> String {
        let address = CNMutablePostalAddress()
        
        if let street = street,
           let postalCode = postalCode,
           let city = city,
           let country = country
        {
            address.street = street
            address.postalCode = postalCode
            address.city = city
            address.country = country
        }

        return formattedPostalAddress(from: address)
    }
    
    func shortFormatAddress() -> String {
        let address = CNMutablePostalAddress()
        
        if let street = street,
           let city = city
        {
            address.street = street
            address.city = city
        }
        return formattedPostalAddress(from: address)
    }
    
    func formattedPostalAddress(from address: CNMutablePostalAddress) -> String {
        let postalAddress = CNPostalAddressFormatter.addressFormatter.string(from: address)
        if postalAddress.isEmpty {
            return "Cannot find address for the current location"
        } else {
            return postalAddress
        }
    }
}
