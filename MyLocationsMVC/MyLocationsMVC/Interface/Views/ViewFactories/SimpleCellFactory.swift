//
//  SimpleCellFactory.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 28/01/2022.
//

import CoreLocation

enum SimpleCellFactory {
    static func latitude(_ value: CLLocationDegrees) -> SimpleCellView.Model {
        return SimpleCellView.Model(
            title: "Latitude",
            accesory: SimpleCellView.Model.AccesoryType.text( NumberFormatter.coordinateFormatter.string(for: value) ?? "No value")
        )
    }
    
    static func longitude(_ value: CLLocationDegrees) -> SimpleCellView.Model {
        return SimpleCellView.Model(
            title: "Longitude",
            accesory: SimpleCellView.Model.AccesoryType.text( NumberFormatter.coordinateFormatter.string(for: value) ?? "No value")
        )
    }
}
