//
//  ProvidersListCell.swift
//  foz
//
//  Created by Ahmed Medhat on 24/10/2021.
//

import UIKit
import SDWebImage

class ProvidersListCell: UICollectionViewCell {
    
    @IBOutlet weak var providerImage: UIImageView!
    
    var providersListCellViewModel: ProvidersListCellViewModel? {
        didSet {
            providerImage.sd_setImage(with: URL(string: providersListCellViewModel!.provider_image))
        }
    }
}
