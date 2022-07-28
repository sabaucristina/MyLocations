//
//  MyLocationManager.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 04/12/2021.
//

import CoreLocation

enum LocationFetchInterval {
    case single
    case continuous
}

protocol MyLocationManagerProtocol: AnyObject {
    var isUpdatingLocationLive: Bool { get }
    var canRequestLocationPermission: Bool { get }
    var hasLocationPermissions: Bool { get }

    func requestPermissionIfNeeded(
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func getLatestLocation(
        interval: LocationFetchInterval,
        completion: @escaping (CLLocation) -> Void
    )
    
    func stopUpdatingLocation()
}

final class MyLocationManager: NSObject, MyLocationManagerProtocol {
    private let clLocationManager: CLLocationManager
    
    private var requestPermissionCompletion: ((Result<Void, Error>) -> Void)?
    private var latestLocationCompletion: ((CLLocation) -> Void)?
    private var locationFetchInterval: LocationFetchInterval?
    
    override init() {
        clLocationManager = CLLocationManager()
        super.init()
        clLocationManager.delegate = self
    }
    
    var isUpdatingLocationLive: Bool {
        locationFetchInterval == .continuous
    }
    
    var canRequestLocationPermission: Bool {
        clLocationManager.authorizationStatus == .notDetermined
    }
    
    var hasLocationPermissions: Bool {
        switch clLocationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
    func requestPermissionIfNeeded(
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        switch clLocationManager.authorizationStatus {
        case .denied, .restricted:
            completion(.failure(makeDeniedRestrictedError()))
            
        case .notDetermined:
            clLocationManager.requestWhenInUseAuthorization()
            requestPermissionCompletion = completion
            
        case .authorizedAlways, .authorizedWhenInUse:
            completion(.success(()))
            
        @unknown default:
            assertionFailure()
        }
    }
    
    func getLatestLocation(
        interval: LocationFetchInterval,
        completion: @escaping (CLLocation) -> Void
    ) {
        locationFetchInterval = interval
        clLocationManager.startUpdatingLocation()
        latestLocationCompletion = completion
    }
    
    func stopUpdatingLocation() {
        locationFetchInterval = nil
        clLocationManager.stopUpdatingLocation()
        latestLocationCompletion = nil
    }
}

// MARK: - CLLocationManagerDelegate
extension MyLocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        switch manager.authorizationStatus {
        case .denied, .restricted:
            requestPermissionCompletion?(.failure(makeDeniedRestrictedError()))
            
        case .authorizedAlways, .authorizedWhenInUse:
            requestPermissionCompletion?(.success(()))
            
        default:
            break
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        locations.last.map { latestLocationCompletion?($0) }
        switch locationFetchInterval {
        case .single:
            stopUpdatingLocation()
            
        case .continuous, .none:
            break
           /// assertionFailure("This must never happen")
        }
    }
}

// MARK: - Utils

private extension MyLocationManager {
    func makeDeniedRestrictedError() -> Error {
        NSError(
            domain: "",
            code: 0,
            userInfo: [
                NSLocalizedDescriptionKey: "This app needs location permission"
            ]
        )
    }
}
