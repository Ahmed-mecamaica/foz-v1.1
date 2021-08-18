//
//  CurveView.swift
//  foz
//
//  Created by Ahmed Medhat on 18/08/2021.
//

import UIKit

class CurveView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
    }

}
