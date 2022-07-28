//
//  UIViewController+Views.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 20/01/2022.
//

import UIKit

extension UIViewController {
    func addHoverButton(
        model: HoverButtonView.Model,
        to view: UIView,
        over scrollView: UIScrollView?
    ) -> HoverButtonView {
        let button = HoverButtonView()
        button.update(model: model)
        view.addSubview(button)
        
        let constraints: [NSLayoutConstraint] = [
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -VerticalSpacing.pt16),
            button.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: HorizontalSpacing.pt40),
            button.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -HorizontalSpacing.pt40),
            button.heightAnchor.constraint(equalToConstant: ContentSize.px56)
        ]
        NSLayoutConstraint.activate(constraints)
        
        scrollView?.contentInset.bottom = (ContentSize.px56 + 2 * VerticalSpacing.pt16)
        return button
    }
}
