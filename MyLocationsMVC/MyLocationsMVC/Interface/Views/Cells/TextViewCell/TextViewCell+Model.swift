//
//  TextViewCell+Model.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 02/02/2022.
//

import Foundation
import UIKit

extension TextViewCell {
    class Model {
        init(
            placeholder: String,
            text: String?,
            textFont: UIFont = .systemFont(ofSize: 18),
            textDidChange: ((String?) -> Void)? = nil
        ) {
            self.placeholder = placeholder
            self.text = text
            self.textFont = textFont
            self.textDidChange = textDidChange
        }
        
        let placeholder: String
        let textFont: UIFont
        var textDidChange: ((String?) -> Void)?
        var text: String? {
            didSet {
                textDidChange?(text)
            }
        }
    }
}
