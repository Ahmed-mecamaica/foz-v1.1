//
//  RegisterUserBorderBtn.swift
//  foz
//
//  Created by Ahmed Medhat on 25/08/2021.
//

import UIKit

class RegisterUserBorderBtn: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 55/2
        self.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.2977650623)
        self.layer.borderWidth = 1
    }

}
