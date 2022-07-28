//
//  LocationDatabaseServiceMock.swift
//  MyLocationsMVCTests
//
//  Created by Sabau Cristina on 14/03/2022.
//

import Foundation
@testable import MyLocationsMVC

final class LocationDatabaseServiceMock: LocationDatabaseProtocol {
    
    var getLocationDataStub: ((@escaping (Result<[Location], Error>) -> Void) -> Void)!
    func getLocationData(
        completion: @escaping (Result<[Location], Error>) -> Void
    ) {
        getLocationDataStub(completion)
    }
    
    var saveLocationDataStub: ((Location, @escaping (Result<Void, Error>) -> Void) -> Void)!
    func saveLocationData(
        locationDto: Location,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
       saveLocationDataStub(locationDto, completion)
    }
    
    var deleteLocationDataStub: ((Location, @escaping (Result<Void, Error>) -> Void) -> Void)!
    func deleteLocationData(
        location: Location,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        deleteLocationDataStub(location, completion)
    }
}
