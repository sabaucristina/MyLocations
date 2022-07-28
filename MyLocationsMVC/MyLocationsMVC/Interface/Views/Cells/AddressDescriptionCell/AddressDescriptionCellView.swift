//
//  AddressDescriptionCell.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 18/01/2022.
//

import UIKit

final class AddressDescriptionCellView: UITableViewCell {
    static let identifierName = String(describing: type(of: AddressDescriptionCellView.self))
    private lazy var addressLabel = makeAddressLabel()
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(addressLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        addressLabel.text = model.address.formattedAddress()
    }
}
private extension AddressDescriptionCellView {
    func setupConstraints() {
        let constraints = [
            addressLabel.topAnchor.constraint(equalTo: topAnchor, constant: VerticalSpacing.pt8),
            addressLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -VerticalSpacing.pt8),
            addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -HorizontalSpacing.pt16),
            addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: HorizontalSpacing.pt16)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func makeAddressLabel() -> UILabel {
        let addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.numberOfLines = 0
        addressLabel.textAlignment = .natural
        
        return addressLabel
    }
}
