//
//  InterestCollectionViewCell.swift
//  foz
//
//  Created by Ahmed Medhat on 26/08/2021.
//

import UIKit
import SDWebImage

class InterestCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var interestImage: UIImageView!
    @IBOutlet weak var interestTitle: UILabel!
    @IBOutlet weak var radioBtn: UIButton!
    
    
    var interestListCellViewModel: InterestListCellViewModel? {
        didSet {
            interestImage.sd_setImage(with: URL(string: interestListCellViewModel?.image_url ?? ""), completed: nil)
            interestTitle.text = interestListCellViewModel?.title
//            interestRadioBtn.image = interestListCellViewModel?.radioBtnImage
        }
    }
}
