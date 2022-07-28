//
//  ApiRequestsService.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 30/03/2022.
//

import Foundation
import Alamofire

protocol APIServiceProtocol: AnyObject {
    func fetchLocations(
        completion: @escaping (Result<LocationsResponseDto, Error>) -> Void
    )
    func addLocation(
        with location: LocationCreateDto,
        completion: @escaping (Result<Location, Error>) -> Void
    )
    func updateLocation(
        id: String,
        with location: LocationUpdateDto,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    func deleteLocation(
        with id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class APIService: APIServiceProtocol {
    enum Constants {
        enum Urls {
            static let locationsUrl: URL! = URL(string: "server/locationsPath")
        }
    }
    
    func fetchLocations(
        completion: @escaping (Result<LocationsResponseDto, Error>) -> Void
    ) {
        AF.request(Constants.Urls.locationsUrl)
            .validate()
            .responseDecodable(
                of: LocationsResponseDto.self
            ) { (response) in
                completion(response.result.mapError { $0 })
            }
    }
    
    func addLocation(
        with location: LocationCreateDto,
        completion: @escaping (Result<Location, Error>) -> Void
    ) {
        let dataRequest = AF.request(
            Constants.Urls.locationsUrl,
            method: .post,
            parameters: location
        )
        dataRequest
            .validate()
            .responseDecodable(
                of: Location.self
            ) { (response) in
                completion(response.result.mapError { $0 })
            }
    }
    
    func updateLocation(
        id: String,
        with location: LocationUpdateDto,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let dataRequest = AF.request(
            Constants.Urls.locationsUrl.appendingPathComponent(id),
            method: .put,
            parameters: location,
            encoder: URLEncodedFormParameterEncoder(destination: .httpBody)
        )
        dataRequest
            .validate()
            .response() { (response) in
                completion(response.result.map { _ in }.mapError { $0 })
            }
    }
    
    func deleteLocation(
        with id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let dataRequest = AF.request(
            Constants.Urls.locationsUrl.appendingPathComponent(id),
            method: .delete
        )
        dataRequest
            .validate()
            .response() { (response) in
                completion(response.result.map { _ in }.mapError { $0 })
            }
    }
}
