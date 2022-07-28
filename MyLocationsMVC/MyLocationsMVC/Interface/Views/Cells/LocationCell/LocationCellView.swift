//
//  LocationCellView.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 21/02/2022.
//

import Foundation
import UIKit

final class LocationCellView: UITableViewCell {
    static let identifierName = String(describing: type(of: LocationCellView.self))
    private lazy var contentStack = UIStackView()
    private lazy var descriptionStack = UIStackView()
    private lazy var circleImageView = makeImageView()
    private lazy var descriptionLabel = makeDescriptionLabel()
    private lazy var addressLabel = makeAddressLabel()
    private lazy var circleImageContainerView = UIView()
    
    private enum Constants {
        static let imageSide: CGFloat = 56
    }
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        descriptionLabel.text = model.description
        addressLabel.text = model.address.shortFormatAddress()
        if let photoURL = model.photoURL {
            circleImageView.image = UIImage(contentsOfFile: photoURL.path)
        } else {
            circleImageView.image = Image.defaultCircleImage?.withTintColor(.black)
        }
    }
}
//MARK: Setup View
private extension LocationCellView {
    func setupView() {
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .horizontal
        
        descriptionStack.translatesAutoresizingMaskIntoConstraints = false
        descriptionStack.axis = .vertical
        
        setupHierarchy()
        setupConstraints()
    }
    
    func setupHierarchy() {
        descriptionStack.addArrangedSubview(descriptionLabel)
        descriptionStack.addArrangedSubview(addressLabel)
        
        circleImageContainerView.addSubview(circleImageView)
        
        contentStack.addArrangedSubview(circleImageContainerView)
        contentStack.addArrangedSubview(descriptionStack)
        contentView.addSubview(contentStack)
    }
    
    func setupConstraints() {
        contentStack.setCustomSpacing(8, after: circleImageContainerView)
        let constraints = [
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: VerticalSpacing.pt8),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -VerticalSpacing.pt8),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: HorizontalSpacing.pt16),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HorizontalSpacing.pt16),
            circleImageView.widthAnchor.constraint(equalToConstant: Constants.imageSide),
            circleImageView.heightAnchor.constraint(equalToConstant: Constants.imageSide),
            circleImageView.topAnchor.constraint(equalTo: circleImageContainerView.topAnchor),
            circleImageView.leadingAnchor.constraint(equalTo: circleImageContainerView.leadingAnchor),
            circleImageView.trailingAnchor.constraint(equalTo: circleImageContainerView.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Constants.imageSide/2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }
    
    func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }
    
    func makeAddressLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16)
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }
}
