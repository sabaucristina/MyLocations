//
//  GetLocationViewModel.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 08/03/2022.
//

import UIKit
import CoreLocation

final class GetLocationViewModel {
    enum CellModel {
        case simple(SimpleCellView.Model)
        case address(AddressDescriptionCellView.Model)
        case widget(WidgetCellView.Model)
        
        var identifier: String {
            switch self {
            case .address:
                return AddressDescriptionCellView.identifierName
            case .simple:
                return SimpleCellView.identifierName
            case .widget:
                return WidgetCellView.identifierName
            }
        }
    }
    
    var onReload: (() -> Void)?
    var onFailure: ((Error) -> Void)?
    var locationUpdated: (() -> Void)?
    var latestLocation: Location?
    private var cellModels = [CellModel]()
    private let myLocationManager: MyLocationManagerProtocol
    private let reverseGeocodeService: ReverseGeocodeProtocol
    
    init(
        myLocationManager: MyLocationManagerProtocol,
        reverseGeocodeService: ReverseGeocodeProtocol
    ) {
        self.myLocationManager = myLocationManager
        self.reverseGeocodeService = reverseGeocodeService
        
    }
    
    convenience init() {
        self.init(
            myLocationManager: MyLocationManager(),
            reverseGeocodeService: ReverseGeocodeService()
        )
    }
    
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRowsInSection() -> Int {
        cellModels.count
    }
    
    func getCellModel(atIndex indexPath: IndexPath) -> CellModel {
        cellModels[indexPath.row]
    }
    
    func updateCellModelsWithoutLocation() {
       cellModels = [ .widget(makeWidgetCellModel()) ]
    }
    
    func updateCellModelsWithLocation(location: Location) {
        cellModels = [
            .simple(makeLatCellModel(lat: location.latitude)),
            .simple(makeLongCellModel(long: location.longitude)),
            .address(.init(address: location.address))
        ]
    }
    
    func hasLocationPermission() -> Bool {
        myLocationManager.hasLocationPermissions
    }
    
    func isUpdatingLocationLive() -> Bool {
        myLocationManager.isUpdatingLocationLive
    }
    
    func stopUpdating() {
        myLocationManager.stopUpdatingLocation()
    }
    
    func updateLatestLocation() {
        myLocationManager.getLatestLocation(interval: .continuous) { sweetLocation in
            self.reverseGeocoding(clLocation: sweetLocation)
        }
    }
}

private extension GetLocationViewModel {
    func getLocationPermissions() {
        if myLocationManager.canRequestLocationPermission {
            myLocationManager.requestPermissionIfNeeded { result in
                switch result {
                case .success:
                    self.updateLocationOnce()
                    self.locationUpdated?()
                    
                case let .failure(error):
                    self.onFailure?(error)
                }
            }
        } else {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(
                    settingsUrl,
                    completionHandler: nil
                )
            }
        }
    }
    
    func reverseGeocoding(clLocation: CLLocation) {
        reverseGeocodeService.findAddress(location: clLocation) { result in
            switch result {
            case let .success(placemark):
                let id = UUID().uuidString
                self.latestLocation = Location(
                    id: id,
                    latitude: clLocation.coordinate.latitude,
                    longitude: clLocation.coordinate.longitude,
                    address: .init(placemark: placemark),
                    date: .now,
                    description: "",
                    category: ""
                )
                self.onReload?()
            case let .failure(error):
                self.onFailure?(error)
            }
        }
    }
}

// MARK: - Cell makers
private extension GetLocationViewModel {
    func makeLatCellModel(lat: CLLocationDegrees) -> SimpleCellView.Model {
        return SimpleCellView.Model(
            title: "Latitude",
            accesory: SimpleCellView.Model.AccesoryType.text(NumberFormatter.coordinateFormatter.string(for: lat) ?? "No value")
        )
    }
    
    func makeLongCellModel(long: CLLocationDegrees) -> SimpleCellView.Model {
        return SimpleCellView.Model(
            title: "Longitude",
            accesory: SimpleCellView.Model.AccesoryType.text(NumberFormatter.coordinateFormatter.string(for: long) ?? "No value")
        )
    }
    
    func makeWidgetCellModel() -> WidgetCellView.Model {
        return WidgetCellView.Model(
            title: "Needs location permissions",
            widgetImage: UIImage(named: "Logo"),
            action: { [weak self] in
                self?.getLocationPermissions()
            }
        )
    }
}

// MARK: - Actions
extension GetLocationViewModel {
    func getLocation() {
        myLocationManager.requestPermissionIfNeeded { result in
            switch result {
            case .success:
                self.updateLocationOnce()
                
            case let .failure(error):
                self.onFailure?(error)
            }
        }
    }
    
    @objc
    func updateLocationOnce() {
        myLocationManager.getLatestLocation(interval: .single) { sweetLocation in
            self.reverseGeocoding(clLocation: sweetLocation)
        }
    }
}

