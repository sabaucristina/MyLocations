//
//  TextView.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 02/02/2022.
//

import Foundation
import UIKit

final class TextViewCell: UITableViewCell {
    static let identifierName = String(describing: type(of: TextViewCell.self))
    
    private lazy var textView = UITextView()
    private lazy var placeholderLabel = UILabel()
    private var model: Model?
    
    enum Constants {
        static let maxCharacters = 121
    }
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUIView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        self.model = model
        textView.font = model.textFont
        textView.becomeFirstResponder()
        if let text = model.text, !text.isEmpty {
            setDescriptionText(in: textView, with: text)
        } else {
            setPlaceholder(in: textView)
        }
        textView.delegate = self
    }
}

//MARK: SetupUI
private extension TextViewCell {
    func setupUIView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textView)
        
        let constraints =
        [
            textView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: VerticalSpacing.pt16
            ),
            textView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -VerticalSpacing.pt16
            ),
            textView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -HorizontalSpacing.pt16
            ),
            textView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: HorizontalSpacing.pt16
            ),
            
            textView.heightAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

//MARK: Helper methods
private extension TextViewCell {
    func setPlaceholder(in textView: UITextView) {
        textView.text = model?.placeholder
        textView.textColor = UIColor.lightGray
        model?.text = ""
        
        textView.selectedTextRange = textView.textRange(
            from: textView.beginningOfDocument,
            to: textView.beginningOfDocument
        )
    }
    
    func setDescriptionText(
        in textView: UITextView,
        with text: String
    ) {
        textView.textColor = UIColor.black
        textView.text = text
        model?.text = text
    }
}

//MARK: - TextView Delegate
extension TextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        model?.text = textView.text
    }
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        let updatedText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfCharacters = updatedText.count
        
        if updatedText.isEmpty {
            setPlaceholder(in: textView)
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            setDescriptionText(in: textView, with: text)
        } else if numberOfCharacters < Constants.maxCharacters {
            return true
        }
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard textView.textColor == UIColor.lightGray else { return }
        
        textView.selectedTextRange = textView.textRange(
            from: textView.beginningOfDocument,
            to: textView.beginningOfDocument
        )
    }
}
