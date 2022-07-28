//
//  NumberFormatter+Coordinate.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 18/01/2022.
//

import UIKit

extension NumberFormatter {
    static let coordinateFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 10
        numberFormatter.minimumFractionDigits = 10
        
        return numberFormatter
    }()
}
