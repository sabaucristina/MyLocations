//
//  HoverButtonView+Model.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 20/01/2022.
//

import Foundation
import UIKit

extension HoverButtonView {
    struct Model {
        var title: String
        let titleFont: UIFont
        let action: () -> Void
    }
}
