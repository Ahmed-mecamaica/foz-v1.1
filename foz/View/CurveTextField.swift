//
//  CurveTextView.swift
//  foz
//
//  Created by Ahmed Medhat on 18/08/2021.
//

import UIKit

class CurveTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        let image = UIImage(named: "personIcon")
//        imageview.contentMode = .scaleAspectFill
//        imageview.image = image
//        self.leftView = imageview
//        self.leftViewMode = .always
        self.attributedPlaceholder = NSAttributedString(string: "نرنمرنسميدرنسدمسر", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(cgColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))])
        self.layer.cornerRadius = 55/2
        self.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.2977650623)
        self.layer.borderWidth = 1
    }
    
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
