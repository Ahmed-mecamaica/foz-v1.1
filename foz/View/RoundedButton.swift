//
//  RoundedButton.swift
//  foz
//
//  Created by Ahmed Medhat on 16/08/2021.
//

import UIKit

class RoundedButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 55/2
    }

}
