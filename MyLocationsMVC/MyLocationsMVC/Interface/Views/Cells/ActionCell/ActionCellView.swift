//
//  ActionCellView.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 01/02/2022.
//

import Foundation
import UIKit

final class ActionCellView: UITableViewCell {
    static let identifierName = String(describing: type(of: ActionCellView.self))
    private enum Constants {
        enum AccessoryChevron {
            static let width: CGFloat = 18
        }
        enum AccessoryImage {
            static let imageHeight: CGFloat = 180
        }
    }
    
    private lazy var contentStack = UIStackView()
    private lazy var accessoryStack = UIStackView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var accessoryChevron = makeChevronAccessory()
    private lazy var accessoryTitle = makeAccessoryTitle()
    private lazy var accessoryImage = makeImageViewContainer()
    
    private var model: Model?

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        self.model = model
        switch model.accesory {
        case let .text(title):
            accessoryTitle.text = title
            accessoryTitle.isHidden = false
            accessoryImage.isHidden = true
            titleLabel.isHidden = false
            titleLabel.setContentHuggingPriority(.required, for: .vertical)
        case let .image(image):
            accessoryImage.image = image
            accessoryTitle.isHidden = true
            titleLabel.isHidden = true
            titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
            accessoryImage.isHidden = false
        case .none:
            accessoryTitle.isHidden = true
            titleLabel.isHidden = false
            titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
            accessoryImage.isHidden = true
        }
        
        titleLabel.text = model.title
        accessoryChevron.image = model.actionIcon
    }
}

private extension ActionCellView {
    func setupView() { 
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .horizontal
        
        accessoryStack.translatesAutoresizingMaskIntoConstraints = false
        accessoryStack.axis = .horizontal
        accessoryStack.spacing = HorizontalSpacing.pt8
    }
    
    func setupHierarchy() {
        accessoryStack.addArrangedSubview(accessoryTitle)
        accessoryStack.addArrangedSubview(accessoryImage)
        accessoryStack.addArrangedSubview(accessoryChevron)
        
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(accessoryStack)
        
        contentView.addSubview(contentStack)
    }
    
    func setupConstraints() {
        let constraints = [
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: VerticalSpacing.pt8),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -VerticalSpacing.pt8),
            contentStack.leadingAnchor.constraint(equalTo:  contentView.leadingAnchor, constant: HorizontalSpacing.pt16 ),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HorizontalSpacing.pt16),
            titleLabel.widthAnchor.constraint(equalTo: contentStack.widthAnchor, multiplier: 0.5),
            accessoryChevron.widthAnchor.constraint(equalToConstant: Constants.AccessoryChevron.width),
            accessoryImage.heightAnchor.constraint(lessThanOrEqualToConstant: Constants.AccessoryImage.imageHeight)
        ]
      
        NSLayoutConstraint.activate(constraints)
    }
    
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }
    
    func makeAccessoryTitle() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        
        return label
    }
    
    func makeChevronAccessory() -> UIImageView {
        let defaultSymbolImage = UIImage()
        let imageView = UIImageView(image: defaultSymbolImage)
        let updatedConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        imageView.preferredSymbolConfiguration = updatedConfiguration
        imageView.contentMode = .right

        return imageView
    }
    
    func makeImageViewContainer() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
}
