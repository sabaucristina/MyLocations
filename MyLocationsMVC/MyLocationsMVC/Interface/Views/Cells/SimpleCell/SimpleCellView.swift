//
//  SimpleCell.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 17/01/2022.
//

import UIKit

final class SimpleCellView: UITableViewCell {
    static let identifierName = String(describing: type(of: SimpleCellView.self))
    
    private lazy var contentStackView = UIStackView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var accesoryTextLabel = makeAccesoryTextLabel()
    private lazy var accesoryImageView = makeAccesoryImageView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func update(model: Model) {
        titleLabel.attributedText = NSAttributedString(
            string: model.title,
            attributes: [.font: model.titleFont]
        )
        switch model.accesory {
        case .text(let text):
            accesoryTextLabel.attributedText = NSAttributedString(
                string: text,
                attributes: [.font: model.accesoryTextFont]
            )
            accesoryTextLabel.isHidden = false
            accesoryImageView.isHidden = true
        case .checkmark(let checked):
            accesoryImageView.image = Icon.checkmark
            accesoryImageView.isHidden = !checked
            accesoryTextLabel.isHidden = checked
        }
    }
}

private extension SimpleCellView {
    func setupView() {
        selectionStyle = .none
        setupStackView()
        setupHierarchy()
        setupConstraints()
    }
    
    func setupStackView() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .horizontal
    }
    
    func setupHierarchy() {
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(accesoryTextLabel)
        contentStackView.addArrangedSubview(accesoryImageView)
        addSubview(contentStackView)
    }
    
    func setupConstraints() {
        let constraints = [
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: VerticalSpacing.pt8),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -VerticalSpacing.pt8),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: HorizontalSpacing.pt16 ),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -HorizontalSpacing.pt16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }
    
    func makeAccesoryTextLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .right
        
        return label
    }
    
    func makeAccesoryImageView() -> UIImageView {
        let imageView = UIImageView()
        
        return imageView
    }
}
