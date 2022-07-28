//
//  ReverseGeocodeService.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 19/01/2022.
//

import CoreLocation

protocol ReverseGeocodeProtocol: AnyObject {
    func findAddress(
        location: CLLocation,
        completion: @escaping (Result<CLPlacemark, Error>) -> Void
    )
}

final class ReverseGeocodeService: ReverseGeocodeProtocol {
    private let geocoder: CLGeocoder
    
    init(){
        geocoder = CLGeocoder()
    }
    
    func findAddress(
        location: CLLocation,
        completion: @escaping (Result<CLPlacemark, Error>) -> Void
    ) {
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            var result: Result<CLPlacemark, Error> = .failure(NSError())
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            if let error = error {
                result = .failure(error)
                return
            }
            
            if let placemark = placemarks?.first {
                result = .success(placemark)
                return
            }
        }
    }
}
