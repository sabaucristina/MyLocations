//
//  WidgetCellView.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 21/01/2022.
//

import Foundation
import UIKit

final class WidgetCellView: UITableViewCell {
    static let identifierName = String(describing: type(of: WidgetCellView.self))
    private lazy var contentStackView = UIStackView()
    private lazy var widgetImage = makeImageView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var permissionsButton = makePermissionButton()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var model: Model?
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupStackView()
        setupHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        self.model = model
        widgetImage.image = model.widgetImage
        titleLabel.text = model.title
    }
}

private extension WidgetCellView {
    func setupStackView() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        
        permissionsButton.insetsLayoutMarginsFromSafeArea = false  
    }
    
    func setupHierarchy() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.setCustomSpacing(24, after: titleLabel)
        contentStackView.addArrangedSubview(widgetImage)
        contentStackView.setCustomSpacing(40, after: widgetImage)
        contentStackView.addArrangedSubview(containerView)
        containerView.addSubview(permissionsButton)
    }
    
    func setupConstraints() {
        let constraints = [
            permissionsButton.centerXAnchor.constraint(
                equalTo: containerView.centerXAnchor
            ),
            permissionsButton.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: HorizontalSpacing.pt8
            ),
            permissionsButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            permissionsButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            permissionsButton.heightAnchor.constraint(equalToConstant: 42),
            
            contentStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: VerticalSpacing.pt32
            ),
            contentStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -VerticalSpacing.pt32
            ),
            contentStackView.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),
            contentStackView.leadingAnchor.constraint(
                greaterThanOrEqualTo: contentView.leadingAnchor,
                constant: HorizontalSpacing.pt16
            )
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        
        return label
    }
    
    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        return imageView
    }
    
    func makePermissionButton() -> UIButton {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height / 2
        
        button.setAttributedTitle(
            NSAttributedString(
                string: "Change permissions", attributes: [
                    .font: UIFont.italicSystemFont(ofSize: 16),
                    .foregroundColor: UIColor.black.withAlphaComponent(0.8)
                ]
            ),
            for: .normal
        )
        button.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        button.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func tapped(sender: UIButton) {
        model?.action()
    }
}
