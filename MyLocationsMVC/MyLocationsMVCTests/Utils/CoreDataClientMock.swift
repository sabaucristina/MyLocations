//
//  CoreDataClientMock.swift
//  MyLocationsMVCTests
//
//  Created by Sabau Cristina on 07/03/2022.
//

@testable import MyLocationsMVC

final class CoreDataClientMock: CoreDataClientProtocol {

    var readLocationsFuncStub: (() -> [Location])!
    func readLocations() -> [Location] {
        readLocationsFuncStub()
    }
    
    var readLocationFuncStub: ((String) -> Location?)!
    func readLocation(with id: String) -> Location? {
        readLocationFuncStub(id)
    }
    
    var insertOrUpdateLocationFuncStub: ((Location, (Result<Void, Error>) -> Void) -> Void)!
    func insertOrUpdateLocation(
        location: Location,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        insertOrUpdateLocationFuncStub(location, completion)
    }
    
    var deleteLocationFuncStub: ((Location, @escaping(Result<Void, Error>) -> Void) -> Void)!
    func deleteLocation(location: Location, completion: @escaping (Result<Void, Error>) -> Void) {
        deleteLocationFuncStub(location, completion)
    }
}
