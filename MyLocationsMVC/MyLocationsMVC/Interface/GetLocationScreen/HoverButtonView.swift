//
//  HoverButtonView.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 20/01/2022.
//

import Foundation
import UIKit

final class HoverButtonView: UIButton {    
    private var superviewConstraints = [NSLayoutConstraint]()
    private var bgBlur: UIVisualEffectView?
    private var model: Model?
    
    enum Constants {
        enum Colors {
            static let enabled = UIColor.systemYellow.withAlphaComponent(0.2)
            static let disabled = UIColor.systemGray2
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? Constants.Colors.enabled : Constants.Colors.disabled
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgBlur?.layer.cornerRadius = frame.size.height / 2
        bgBlur?.clipsToBounds = true
        layer.cornerRadius = frame.size.height / 2
        layer.shadowRadius = 5.0
        layer.shadowColor = UIColor.systemGray.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        self.model = model
        setAttributedTitle(
            NSAttributedString(
                string: model.title,
                attributes: [.font: model.titleFont]
            ),
            for: .normal
        )
    }
}

private extension HoverButtonView {
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.systemYellow.withAlphaComponent(0.2)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.isUserInteractionEnabled = false
        blur.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(blur, at: 0)
        blur.pinToSuperviewEdges()

        bgBlur = blur
    }
    
    @objc func tapped() {
        model?.action()
    }
}
