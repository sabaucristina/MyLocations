//
//  CustomHeaderLabel.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 04/02/2022.
//

import Foundation
import UIKit

final class CustomHeaderView: UITableViewHeaderFooterView {
    static let identifierName = String(describing: type(of: CustomHeaderView.self))
    lazy var headerLabel = makeHeaderLabel()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        headerLabel.text = model.title
        headerLabel.font = model.font
    }
}

private extension CustomHeaderView {
    func setupUI() {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(headerLabel)
        contentView.pinToSuperviewEdges()
        let constraints = [
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: VerticalSpacing.pt8),
            headerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -VerticalSpacing.pt8),
            headerLabel.leadingAnchor.constraint(equalTo:  contentView.leadingAnchor, constant: HorizontalSpacing.pt16 ),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HorizontalSpacing.pt16),
            headerLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func makeHeaderLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemGray
        label.numberOfLines = 0
        
        return label
    }
}
