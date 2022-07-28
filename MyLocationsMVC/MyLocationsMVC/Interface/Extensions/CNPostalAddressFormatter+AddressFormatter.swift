//
//  Cn.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 19/01/2022.
//

import Foundation
import Contacts

extension CNPostalAddressFormatter {
    static let addressFormatter: CNPostalAddressFormatter = {
        let formatter = CNPostalAddressFormatter()
        formatter.style = .mailingAddress
        return formatter        
    }()
}
