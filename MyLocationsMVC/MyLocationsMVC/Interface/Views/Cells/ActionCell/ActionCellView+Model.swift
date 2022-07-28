//
//  ActionCellView+Model.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 01/02/2022.
//

import Foundation
import UIKit

extension ActionCellView {
    struct Model {
        enum AccesoryType {
            case text(String)
            case image(UIImage)
            case none
        }
        
        var title: String
        var accesory: AccesoryType = .none
        let actionIcon: UIImage?
        let action: () -> Void
    }
}
