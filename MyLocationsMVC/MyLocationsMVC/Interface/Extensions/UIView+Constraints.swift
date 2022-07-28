//
//  UIView+Constraints.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 20/01/2022.
//

import UIKit

extension UIView {
    func pinToSuperviewEdges() {
        guard let superview = superview else { return }
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
    }
}
