//
//  LocationDatabaseService.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 21/02/2022.
//

import Foundation
import UIKit

protocol LocationDatabaseProtocol: AnyObject {
    func getLocationData(
        completion: @escaping (Result<[Location], Error>) -> Void
    )
    func saveLocationData(
        locationDto: Location,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    func deleteLocationData(
        location: Location,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class LocationDatabaseService: LocationDatabaseProtocol {
    private let coreDataClient: CoreDataClientProtocol
    
    init(
        coreDataClient: CoreDataClientProtocol
    ) {
        self.coreDataClient = coreDataClient
    }
    
    convenience init() {
        self.init(coreDataClient: CoreDataClient())
    }
    
    func getLocationData(
        completion: @escaping (Result<[Location], Error>) -> Void
    ) {
        let locations = coreDataClient.readLocations()
        completion(.success(locations))
    }
    
    func saveLocationData(
        locationDto: Location,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        coreDataClient.insertOrUpdateLocation(
            location: locationDto,
            completion: completion
        )
    }
    
    func deleteLocationData(
        location: Location,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        coreDataClient.deleteLocation(
            location: location,
            completion: completion
        )
    }
}
