//
//  SimpleCellView+Model.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 18/01/2022.
//

import UIKit

extension SimpleCellView {
    struct Model {
        let title: String
        enum AccesoryType {
            case text(String)
            case checkmark(Bool)
        }
        
        let accesory: AccesoryType
        let titleFont: UIFont
        let accesoryTextFont: UIFont
        
        init(
            title: String,
            accesory: AccesoryType,
            titleFont: UIFont = .systemFont(ofSize: 18),
            accesoryTextFont: UIFont = .systemFont(ofSize: 14)
        ) {
            self.title = title
            self.accesory = accesory
            self.titleFont = titleFont
            self.accesoryTextFont = accesoryTextFont
        }
    }
}
