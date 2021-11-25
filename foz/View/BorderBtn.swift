//
//  BorderBtn.swift
//  foz
//
//  Created by Ahmed Medhat on 18/08/2021.
//

import UIKit

class BorderBtn: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 35
        self.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.borderWidth = 10
    }

}

extension UIButton {
    func myCouponBorderBtn(height: CGFloat) {
        self.layer.cornerRadius = height / 2
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.borderWidth = 0.7
    }
    
    func myCouponRedBorderBtn(height: CGFloat) {
        self.layer.cornerRadius = height / 2
        self.layer.borderColor = #colorLiteral(red: 0.6980392157, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
        self.layer.borderWidth = 0.7
    }
}
