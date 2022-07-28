//
//  WidgetCellView+Model.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 21/01/2022.
//

import Foundation
import UIKit

extension WidgetCellView {
    struct Model {
        let title: String
        let widgetImage: UIImage?
        let action: () -> Void
    }
}
