//
//  CurveView.swift
//  foz
//
//  Created by Ahmed Medhat on 04/10/2021.
//

import UIKit

class CurveView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
    }

}


extension UIView {
    func CurveFooterViewInsideMarketVC(height: CGFloat) {
        self.layer.cornerRadius = height/2
        self.layer.borderColor = #colorLiteral(red: 0.9137254902, green: 0.5803921569, blue: 0.03137254902, alpha: 1)
        self.layer.borderWidth = 1
    }
    
    func CurveHeaderViewInsideMarketVC() {
        self.layer.cornerRadius = 7
        self.layer.borderColor = #colorLiteral(red: 0.9137254902, green: 0.5803921569, blue: 0.03137254902, alpha: 1)
        self.layer.borderWidth = 1
    }
}
