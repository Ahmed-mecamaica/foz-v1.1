//
//  BottomRadiusView.swift
//  foz
//
//  Created by Ahmed Medhat on 05/09/2021.
//

import UIKit

class BottomRadiusView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.bottomRight, .bottomLeft], radius: 15)
    }

}
