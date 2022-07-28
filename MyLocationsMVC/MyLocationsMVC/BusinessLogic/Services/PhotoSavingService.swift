//
//  PhotoSavingService.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 08/03/2022.
//

import UIKit

//TODO: refactor this when related viewModels are created
final class PhotoSavingService {
    static let shared = PhotoSavingService()
    static func photoURL(using id: String) -> URL {
        let paths = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )
        return paths[0].appendingPathComponent(id)
    }
    
    static func saveLocationImage(
        locationImage: UIImage,
        photoName: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        if let data = locationImage.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(
                    to: photoURL(using: photoName),
                    options: .atomic
                )
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(PhotoSavingService.makeNoImageDataError()))
        }
    }
}

// MARK: - Utils
private extension PhotoSavingService {
    static func makeNoImageDataError() -> Error {
        return NSError(
            domain: "",
            code: 0,
            userInfo: [
                NSLocalizedDescriptionKey: "Couldn't save the image"
            ]
        )
    }
}
