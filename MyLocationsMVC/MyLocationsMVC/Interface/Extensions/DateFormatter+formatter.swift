//
//  DateFormatter+formatter.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 31/01/2022.
//

import Foundation
extension DateFormatter {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }()
}
