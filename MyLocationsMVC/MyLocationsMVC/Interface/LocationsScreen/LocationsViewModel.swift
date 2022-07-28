//
//  LocationsViewModel.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 08/03/2022.
//

import UIKit

final class LocationsViewModel {
    private struct Section {
        let category: String
        var items: [Location]
    }
    private var sections = [Section]()
    
    var onReload: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?
    
    private let apiService: APIServiceProtocol
    
    init(
        apiService: APIServiceProtocol
    ) {
        self.apiService = apiService
    }
    
    convenience init() {
        self.init(apiService: APIService())
    }

    func getLocations() {
        apiService.fetchLocations() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(dto):
                let locations = dto.locations
                self.updateSection(withLocations: locations.map{ $0.toDomain() })
                self.onReload?(locations.isEmpty)
            case let .failure(error):
                self.onError?(error)
            }
        }
    }
    
    func deleteLocation(atIndex index: IndexPath) {
        let location = getLocation(atIndex: index)
        apiService.deleteLocation(with: location.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.getLocations()
                
            case let .failure(error):
                self.onError!(error)
            }
        }
    }
    
    private func updateSection(withLocations locations: [Location]) {
        sections = locations
            .groupedByCategory()
            .map(Section.init)
            .sorted(by: { $0.category < $1.category })
    }
    
    func getLocation(atIndex index: IndexPath) -> Location {
        sections[index.section].items[index.row]
    }
    
    func numberOfSections() -> Int {
        sections.count
    }
    
    func numberOfRowsInSection(atSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func headerTitle(atSection section: Int) -> String {
        sections[section].category.capitalized
    }  
}
