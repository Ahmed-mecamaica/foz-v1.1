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
