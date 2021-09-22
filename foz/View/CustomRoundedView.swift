//
//  CustomRoundedView.swift
//  foz
//
//  Created by Ahmed Medhat on 05/09/2021.
//

import UIKit

class CustomRoundedView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .bottomRight], radius: 15)
    }

}
