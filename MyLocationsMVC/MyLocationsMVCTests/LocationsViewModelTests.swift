//
//  LocationsViewModelTests.swift
//  MyLocationsMVCTests
//
//  Created by Sabau Cristina on 14/03/2022.
//

import XCTest
@testable import MyLocationsMVC

struct TestError: Error, Equatable {
    let id = "some id"
}

//TODO: refactor LocationsViewModel
final class LocationsViewModelTests: XCTestCase {
    private var locationServiceMock: LocationDatabaseServiceMock!
    private var location: Location!
    private var locations: [Location]!
    private var sutVM: LocationsViewModel!
    
    override func setUp(){
        locationServiceMock = LocationDatabaseServiceMock()
        location = .stub()
        locations = Array(repeating: .stub(), count: 3)
        sutVM = LocationsViewModel(locationDatabaseService: locationServiceMock)
    }
    
    // when error
    func testNumberOfSections_whenGetLocationFails_returnsNoSections() {
        locationServiceMock.getLocationDataStub = { completion in
            let error = NSError()
            completion(.failure(error))
        }
        
        sutVM.getLocations()
        XCTAssertEqual(sutVM.numberOfSections(), 0)
    }
    
    // when success
    // when all locations are the same category
    
    func setupWhenGetLocationSucceedsWithSameCategory() {
        locationServiceMock.getLocationDataStub = { completion in
            completion(.success(self.locations))
        }
        sutVM.getLocations()
    }
    
    func test_whenGetLocationSucceeds_numberOfSections_returnsExpectedValue() {
        setupWhenGetLocationSucceedsWithSameCategory()
        XCTAssertEqual(sutVM.numberOfSections(), 1)
    }
    
    func test_whenGetLocationSucceeds_numberOfRowsInSection_returnsNumberOfLocations() {
        setupWhenGetLocationSucceedsWithSameCategory()
        XCTAssertEqual(sutVM.numberOfRowsInSection(atSection: 0), 3)
    }
    
    func test_whenGetLocationSucceeds_locationAtIndex_returnsLocationsInCorrectOrder() {
        setupWhenGetLocationSucceedsWithSameCategory()
        let retrievedLocations = (0..<3).map { row in
            sutVM.getLocation(atIndex: .init(row: row, section: 0))
        }
        XCTAssertEqual(retrievedLocations, locations)
    }
    
    func test_whenGetLocationSucceeds_headerTitle_returnsLocationCategoryCapitalized() {
        setupWhenGetLocationSucceedsWithSameCategory()
        XCTAssertEqual(sutVM.headerTitle(atSection: 0), "Some")
    }
    
    func test_whenGetLocationSucceeds_whenDeleteFails_onErrorIsCalled() {
        setupWhenGetLocationSucceedsWithSameCategory()
        
        var error: TestError?
        sutVM.onError = { newError in
            error = newError as? TestError
        }
        locationServiceMock.deleteLocationDataStub = { (location, completion) in
            completion(.failure(TestError()))
        }
        
        sutVM.deleteLocation(atIndex: .init(row: 0, section: 0))
        XCTAssertEqual(error, TestError())
    }
    
    func test_whenGetLocationSucceeds_whenDeleteSucceeds_reloadIsCalled() {
        setupWhenGetLocationSucceedsWithSameCategory()
        
        var isEmpty: Bool?
        sutVM.onReload = {
            isEmpty = $0
        }
        locationServiceMock.deleteLocationDataStub = { (location, completion) in
            completion(.success(()))
        }
        locationServiceMock.getLocationDataStub =  {
            $0(.success([]))
        }
        
        sutVM.deleteLocation(atIndex: .init(row: 0, section: 0))
        XCTAssertEqual(isEmpty, true)
        XCTAssertEqual(sutVM.numberOfSections(), 0)
    }
    
    // when all locations are different categories
    
    func setupWhenGetLocationSucceedsWithDifferentCategory() {
        locationServiceMock.getLocationDataStub = { completion in
            completion(
                .success(
                    [
                        .stub(id: "", category: "bb"),
                        .stub(id: "", category: "aa")
                    ]
                )
            )
        }
        sutVM.getLocations()
    }
    
    func test_whenGetLocationSucceedsWithDifferentCategory_numberOfSections_returnsExpectedValue() {
        setupWhenGetLocationSucceedsWithDifferentCategory()
        XCTAssertEqual(sutVM.numberOfSections(), 2)
    }
    
    func test_whenGetLocationSucceedsWithDifferentCategory_numberOfRowsInSection_returnsNumberOfLocations() {
        setupWhenGetLocationSucceedsWithDifferentCategory()
        XCTAssertEqual(sutVM.numberOfRowsInSection(atSection: 0), 1)
        XCTAssertEqual(sutVM.numberOfRowsInSection(atSection: 1), 1)
    }
    
    func test_whenGetLocationSucceedsWithDifferentCategory_locationAtIndex_returnsLocationsInCorrectOrder() {
        setupWhenGetLocationSucceedsWithDifferentCategory()
        let retrievedLocations = [0, 1].map { section in
            sutVM.getLocation(atIndex: .init(row: 0, section: section))
        }
        XCTAssertEqual(
            retrievedLocations, [
                .stub(id: "", category: "aa"),
                .stub(id: "", category: "bb")
            ]
        )
    }
    
    func test_whenGetLocationSucceedsWithDifferentCategory_headerTitle_returnsLocationCategoryCapitalized() {
        setupWhenGetLocationSucceedsWithDifferentCategory()
        XCTAssertEqual(sutVM.headerTitle(atSection: 0), "Aa")
        XCTAssertEqual(sutVM.headerTitle(atSection: 1), "Bb")
    }
}
