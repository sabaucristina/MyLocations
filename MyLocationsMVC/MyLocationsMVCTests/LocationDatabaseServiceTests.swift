//
//  MyLocationsMockTests.swift
//  MyLocationsMVCTests
//
//  Created by Sabau Cristina on 04/03/2022.
//

import XCTest
@testable import MyLocationsMVC

final class LocationDatabaseServiceTests: XCTestCase {
    private var coreDataClientMock: CoreDataClientMock!
    private var locationDatabaseServices: LocationDatabaseService!
    private var location: Location!
    private var locations: [Location]!
    
    override func setUp() {
        coreDataClientMock = CoreDataClientMock()
        locationDatabaseServices = LocationDatabaseService(coreDataClient: coreDataClientMock)
        location = .stub()
        locations = Array(repeating: Location.stub(), count: 3)
    }
    
    func testReadLocations_ReturnsLocationsInCoreDataClient() {
        coreDataClientMock.readLocationsFuncStub = {
            self.locations
        }
        
        var storedLocations: [Location]?
        locationDatabaseServices.getLocationData { result in
            switch result {
            case let .success(returnedLocations):
                storedLocations = returnedLocations
            default:
                break
            }
        }
        
        XCTAssertEqual(storedLocations, locations)
    }
    
    func testDeleteLocation_CallsCoreDataClientMethod() {
        var passedLocation: Location?
        coreDataClientMock.deleteLocationFuncStub = { (location, completion) in
            passedLocation = location
            completion(.success(()))
        }
        
        var result: Result<Void, Error>?
        locationDatabaseServices.deleteLocationData(
            location: location
        ) { newResult in
            result = newResult
        }
        XCTAssertEqual(location, passedLocation)
        XCTAssertNotNil(result)
        XCTAssertNoThrow(try result?.get())
    }
    
    func testInsertOrUpdate_CallsCoreDataClientMethod() {
        var passedLocation: Location?
        coreDataClientMock.insertOrUpdateLocationFuncStub = { (location, completion) in
            passedLocation = location
            completion(.success(()))
        }
        
        var result: Result<Void, Error>?
        locationDatabaseServices.saveLocationData(locationDto: location) { newResult in
            result = newResult
        }
        
        XCTAssertEqual(location, passedLocation)
        XCTAssertNotNil(result)
        XCTAssertNoThrow(try result?.get())
    }
}
