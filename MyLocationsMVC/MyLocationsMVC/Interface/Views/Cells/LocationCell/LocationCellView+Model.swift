//
//  LocationCellView+Model.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 21/02/2022.
//

import Foundation
import UIKit

extension LocationCellView {
    struct Model {
        let description: String?
        let address: Address
        let photoURL: URL?
        
        init(
            description: String? = "(No Description)",
            address: Address,
            photoURL: URL?
        ) {
            self.description = description
            self.address = address
            self.photoURL = photoURL
        }
    }
}
