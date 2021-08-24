//
//  CurveTextView.swift
//  foz
//
//  Created by Ahmed Medhat on 18/08/2021.
//

import UIKit

class CurveTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    
    override func layoutSubviews() {
        super.layoutSubviews()

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
    
//    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0))
//    }
    
//    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10))
//    }
}
