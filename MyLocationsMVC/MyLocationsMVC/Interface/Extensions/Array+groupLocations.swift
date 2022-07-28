//
//  Array+groupLocations.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 23/02/2022.
//

import Foundation

extension Array where Element == Location {
    func groupedByCategory() -> [String: [Location]] {
        Dictionary(grouping: self, by: { $0.category })
    }
}
