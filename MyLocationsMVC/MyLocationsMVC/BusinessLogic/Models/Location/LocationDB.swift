//
//  LocationDB.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 01/03/2022.
//

import Foundation
import CoreData
import CoreLocation

@objc(LocationDB)
public class LocationDB: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationDB> {
        return NSFetchRequest<LocationDB>(entityName: "Location")
    }

    @NSManaged public var id: String
    @NSManaged public var category: String
    @NSManaged public var date: Date
    @NSManaged public var descriptionText: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var address: Data
    
    func update(with location: Location) {
        id = location.id
        longitude = location.longitude
        latitude = location.latitude
        descriptionText = location.description
        category = location.category
        date = location.date
        guard let addressData = try? JSONEncoder().encode(location.address) else {
            return assertionFailure("Failed to encode Address")
        }
        address = addressData
    }
    
    func getDto() -> Location? {
        guard let address = try? JSONDecoder().decode(Address.self, from: address) else { return nil }
        return Location(
            id: id,
            latitude: latitude,
            longitude: longitude,
            address: address,
            date: date,
            description: descriptionText,
            category: category
        )
    }
}
